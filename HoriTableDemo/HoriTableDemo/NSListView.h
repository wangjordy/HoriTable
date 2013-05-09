//
//  NSListView.h
//  HoriTableDemo
//
//  Created by 王兴朝 on 13-5-9.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义一种结构体，用来表示区间。表示一个 从 几到几 的概念
typedef struct _SRange{
    NSInteger start;
    NSInteger end;
}SRange;


//在滑动过程中表示向左滑还是向右滑
typedef enum _NSDirection{
    NSDirectionTypeLeft,  //表示向左滑
    NSDirectionTypeRight  //表示向右滑
} NSDirectionType;


NS_INLINE SRange SRangeMake(NSInteger start, NSInteger end){
    SRange range;
    range.start = start;  //范围开始
    range.end = end;  //范围结束
    return range;
}

//该int数是否在SRange区间内， r整形区间 i要比较的数
//返回 i在区间r内，返回YES； 否则返回NO
NS_INLINE BOOL InRange(SRange r, NSInteger i){
    return (r.start <= i) && (r.end >= i);
}

@class NSListView;
@class NSListCell;

@protocol NSListViewDelegate <NSObject>

//当前列 被选中的事件      index表示当前所在的列
- (void)listView:(NSListView *)listView didSelectColumnAtIndex:(NSInteger)index;

@end

@protocol NSListViewDataSource <NSObject>

@optional
//共有多少列
- (NSInteger)numberOfColumnsInListView:(NSListView *)listView;
//列宽
- (CGFloat)widthForColumnAtIndex:(NSInteger)index;
//详细的加载
- (NSListCell *)listView:(NSListView *)listView viewForColumnAtIndex:(NSInteger)index;

@end


@interface NSListView : UIView
{
    NSInteger columns;  //ListCell 个数
    
    SRange visibleRange;  //表示可见的column范围
    CGRect visibleRect;  //设置scrollView 的可见区域
    
    NSMutableArray *columRects; //所有的Cell的frame集合
    NSMutableArray *visibleListCells;  //可见的ListCell集合
    
    NSMutableDictionary *reuseableListCells; //可重复利用的ListCells

}
@property (nonatomic,assign) id <NSListViewDelegate> delegate;
@property (nonatomic,assign) id <NSListViewDataSource> dataSource;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;


@end
