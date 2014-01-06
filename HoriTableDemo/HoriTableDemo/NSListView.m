//
//  NSListView.m
//  HoriTableDemo
//
//  Created by 王兴朝 on 13-5-9.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//

#import "NSListView.h"
#import "NSListCell.h"

@implementation UIScrollView (Rect)

- (CGRect) visibleRect {
    CGRect rect;
    rect.origin = self.contentOffset;
    rect.size = self.bounds.size;
	return rect;
}

@end

@interface NSListView() <UIScrollViewDelegate>
{
    UIScrollView *rootScrollView; //根视图
    int height;  //视图的高度
    int selectedIndex;  //默认选中
    UIColor *separatorColor;
}

@end

@implementation NSListView
@synthesize delegate;
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //创建一个scrollView用于横向滚动
        rootScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        rootScrollView.contentOffset = CGPointZero;
        rootScrollView.delegate = self;
        rootScrollView.canCancelContentTouches = NO;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidTapEvent:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;   //单点
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [rootScrollView addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        [self addSubview:rootScrollView];
        [self bringSubviewToFront:rootScrollView];
        [rootScrollView release];
        
        height = frame.size.height;
        //设置默认选中
        selectedIndex = -1;
        separatorColor = [UIColor blackColor];

    }
    return self;
}

//重写setdatasource方法
- (void)setDataSource:(id<NSListViewDataSource>)_dataSource
{
    dataSource = _dataSource;
    [self loadData];  //加载数据
}

#pragma mark -
#pragma mark 加载数据
- (void)loadData
{
    
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfColumnsInListView:)]) {
        NSInteger theColumns = [dataSource numberOfColumnsInListView:self];
        
        if (theColumns <= 0) {
            return;
        }
        
        
        visibleRange = SRangeMake(0, 0);
        columns = theColumns;
        
        columRects = [[NSMutableArray alloc] initWithCapacity:columns];
        
        CGFloat left = 0; //临时变量，记录每个cell的x坐标
        for (int index=0; index < columns; index++) {
            CGFloat width = height;
            
            if (dataSource &&[dataSource respondsToSelector:@selector(widthForColumnAtIndex:)]) {
                width = [dataSource widthForColumnAtIndex:index];
            }
            
            CGRect rect = CGRectMake(left, 0, width, height);
            
            [columRects addObject:NSStringFromCGRect(rect)];
            left += width;
        }
        
        rootScrollView.contentSize = CGSizeMake(left, height);
    }
    
    
    if (!visibleListCells) {
        visibleListCells = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    CGRect rect = [rootScrollView visibleRect];  //可以看见区域

    //以上是设置cell的frame还没有具体的加载cell到scrollView上
    int index = visibleRange.start;
    CGFloat left = 0;
    while (left <= rect.size.width) {
        
        if (index >= columRects.count) {
            break;
        }
        CGRect frame = CGRectFromString([columRects objectAtIndex:index]);
        [self requestCellWithIndex:index direction:NSDirectionTypeLeft];
        left += frame.size.width;
        
        if (left <= rect.size.width) {
            index ++;
        }
    }
    
    visibleRange.end = index;
    
    
}


- (void)reloadData
{

    //重新去加载start与end的
    if (!visibleListCells) {
        visibleListCells = [[NSMutableArray alloc] initWithCapacity:5];
    }
    
    [visibleListCells removeAllObjects];
    
    if (reuseableListCells) {
        [reuseableListCells removeAllObjects];
        [reuseableListCells release];
        reuseableListCells = nil;
    }
    
    for (UIView *subView in rootScrollView.subviews) {
        if ([subView isKindOfClass:[NSListCell class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfColumnsInListView:)]) {
        
        NSInteger theColumns = [dataSource numberOfColumnsInListView:self];
        if (theColumns <= 0) {
            return;
        }
        
        visibleRange = SRangeMake(0, 0);
        columns = theColumns;
        
        if (columRects == nil) {
            columRects = [[NSMutableArray alloc] initWithCapacity:columns];
        }
        [columRects removeAllObjects];
        
        CGFloat left = 0; //临时变量，记录每个cell的x坐标
        for (int index=0; index < columns; index++) {
            CGFloat width = height;
            
            if (dataSource &&[dataSource respondsToSelector:@selector(widthForColumnAtIndex:)]) {
                width = [dataSource widthForColumnAtIndex:index];
            }
            
            CGRect rect = CGRectMake(left, 0, width, height);
            
            [columRects addObject:NSStringFromCGRect(rect)];
            left += width;
        }
        
        rootScrollView.contentSize = CGSizeMake(left, height);
    }

    CGRect rect = [rootScrollView visibleRect];  //可以看见区域
    
    //以上是设置cell的frame还没有具体的加载cell到scrollView上
    int index = visibleRange.start;
    CGFloat left = 0;
    while (left <= rect.size.width) {
        
        if (index >= columRects.count) {
            break;
        }
        CGRect frame = CGRectFromString([columRects objectAtIndex:index]);
        [self requestCellWithIndex:index direction:NSDirectionTypeLeft];
        left += frame.size.width;
        
        if (left <= rect.size.width) {
            index ++;
        }
    }
    
    visibleRange.end = index;
    [rootScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}


- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSListCell *cell = nil;
    NSMutableArray *reuseCells = [reuseableListCells objectForKey:identifier];
    
    if ([reuseCells count] > 0) {
        cell = [reuseCells objectAtIndex:0];
//        [reuseCells removeObject:cell]; //不应该在这里删除，很容易将cell释放了
    }
    return cell;
}

#pragma mark -
#pragma mark 加载NSListCell
- (NSListCell *)requestCellWithIndex:(NSInteger)index direction:(NSDirectionType)direction
{
    CGRect frame = CGRectFromString([columRects objectAtIndex:index]);
    
    NSListCell *cell = [dataSource listView:self viewForColumnAtIndex:index];
    
    cell.frame = frame;
    cell.tag = index;

    cell.separatorView.frame = CGRectMake(frame.size.width-1, 0, 1, frame.size.height);
//    cell.separatorView.backgroundColor = separatorColor;  //分割线
    if (selectedIndex == index) {
        cell.selected = YES;
    }
    
    [rootScrollView addSubview:cell];
    
    if (reuseableListCells.count>0) {
        NSMutableArray *reuseCells = [reuseableListCells objectForKey:cell.reuseIdentifier];
        if (reuseCells.count>0) {
            [reuseCells removeObject:cell];
        }
    }
    
    
    
    
    if (direction == NSDirectionTypeLeft) {
        [visibleListCells addObject:cell];
    }else if (direction == NSDirectionTypeRight){
        [visibleListCells insertObject:cell atIndex:0];
    }
    
    return cell;
}

#pragma mark -
#pragma mark CELL复用
/*
 *  这段代码表示将可见数组中第一个cell取出来，放到复用的数组中， 并且将这个cell从scrollView remove掉
 */
- (void)inqueueReusableWithView:(NSListCell *)reuseView
{
    NSString *identifier = reuseView.reuseIdentifier;
    
    if (!reuseableListCells) {
        reuseableListCells = [[NSMutableDictionary alloc] initWithCapacity:5]; //初始化可复用的CELL字典
    }
    
    NSMutableArray *cells = [reuseableListCells valueForKey:identifier];
    if (!cells) {
        cells = [[[NSMutableArray alloc] initWithCapacity:5] autorelease];
        [reuseableListCells setValue:cells forKey:identifier];
    }
    
    
    reuseView.selected = NO;
    [cells addObject:reuseView];
    [visibleListCells removeObject:reuseView];
    [reuseView removeFromSuperview];
}

#pragma mark -
#pragma mark 加载子视图

//设置rootScroll子视图
- (void)reLayoutSubViewsWithOffset:(CGFloat)offset
{
    int start = visibleRange.start;
    int end = visibleRange.end;
    
    //获取当前显示的第一个cell的frame（这里的第一个根据start确定）
    CGRect startFrame = CGRectFromString([columRects objectAtIndex:start]);
    //获取当前显示的最后一个cell的frame（这里的第一个根据end确定）
    CGRect endFrame = CGRectFromString([columRects objectAtIndex:end]);
    
    //判断滑动方向
    if (offset > 0) {
        //向左滑动--显示右侧的新cell (显示右侧的区域)
        
        //判断--如果可见区域的第一个移除区域外，则放入复用池中
        if ((visibleRect.origin.x) >= (startFrame.origin.x + startFrame.size.width)) {
            NSListCell *cell = (NSListCell *) [visibleListCells objectAtIndex:0];
            [self inqueueReusableWithView:cell];
            start += 1;
            visibleRange.start = start;
        }
        
        //如果最后一个的末尾被滚进区域，则加载下一个
        if ((visibleRect.origin.x + visibleRect.size.width) >= (endFrame.origin.x + endFrame.size.width)) {
            end += 1;
            if (end < columns) {
                [self requestCellWithIndex:end direction:NSDirectionTypeLeft];
                visibleRange.end = end;
            }
        }
        
    }else {
        //向右滑动--显示左侧的新cell
        
        //判断如果可见区域的最后一个移除区域外，则放进可复用池里面， 允许可复用
       if (endFrame.origin.x >= (visibleRect.origin.x + visibleRect.size.width)) {
            NSListCell *cell = (NSListCell *)[visibleListCells lastObject];
            [self inqueueReusableWithView:cell];
            end -= 1;
            visibleRange.end = end;
        }
        
        if (startFrame.origin.x >= visibleRect.origin.x) {
            start -= 1;
            if (start >= 0) {
                [self requestCellWithIndex:start direction:NSDirectionTypeRight];
                visibleRange.start = start;
            }
        }
        
    }

}


#pragma mark -
#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGRect tempRect = [scrollView visibleRect];
    
    CGFloat offsetX = tempRect.origin.x - visibleRect.origin.x;
    visibleRect = tempRect;
    //重新设置子视图的offsetX向右滚动(手势向左)offsetX>0,
    [self reLayoutSubViewsWithOffset:offsetX];
    
}

#pragma mark -
#pragma mark ScrollView点击事件
- (IBAction)scrollViewDidTapEvent:(UITapGestureRecognizer *)sender
{   
    //得到点击的区域
    CGPoint touchPoint = [sender locationInView:rootScrollView];
    
    //根据点击区域的坐标，算出当前所在的列
    //遍历所有 可见区域的cell
    for (NSListCell *cell in visibleListCells) {
        CGRect frame = cell.frame;
        
        if (touchPoint.x > frame.origin.x && touchPoint.x <= frame.origin.x + frame.size.width) {
            [self didSelectedCell:cell index:cell.tag];
            break;
        }
        
        //上述的if与此相同
        //        if  (CGRectContainsPoint(frame, touchPoint)){
        //
        //        }
    }
     
}

//点击某一个Cell
- (void)didSelectedCell:(NSListCell *)cell index:(NSInteger)index
{
    if (selectedIndex == index) {
        return;
    }
    
    [cell setSelected:YES];
    
    if (delegate && [delegate respondsToSelector:@selector(listView:didSelectColumnAtIndex:)]) {
        [delegate listView:self didSelectColumnAtIndex:index];
    }
    
    //如果前一个选中的cell在可视区域内，则取消选中
    if (InRange(visibleRange, selectedIndex)) {
        int i = selectedIndex - visibleRange.start;
        NSListCell *cell1 = [visibleListCells objectAtIndex:i];
        cell1.selected = NO;
    }
    
    selectedIndex = index;
}

- (void)dealloc
{
    delegate = nil;
    dataSource = nil;
    
    [columRects release];
    columRects = nil;
    
    [visibleListCells release];
    visibleListCells = nil;
    
    [reuseableListCells release];
    reuseableListCells = nil;
    
    [super dealloc];
}

@end
