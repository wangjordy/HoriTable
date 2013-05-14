//
//  ViewController.m
//  HoriTableDemo
//
//  Created by 王兴朝 on 13-5-9.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//

#import "ViewController.h"
#import "NSListView.h"
#import "NSListCell.h"

@interface ViewController () <NSListViewDelegate,NSListViewDataSource>
{
    NSArray *infoArray;
    NSListView *rootListView;
}
@property (nonatomic, retain) NSArray *infoArray;
@end

@implementation ViewController
@synthesize infoArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.infoArray = [NSArray arrayWithObjects:@"Jordy", @"Jo", @"Jor", @"Jord", @"Jim", @"Beijing", @"TheValue", @"The", @"vam",nil];
    
    rootListView = [[NSListView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    [rootListView setDelegate:self];
    [rootListView setDataSource:self];
    [rootListView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:rootListView];
    [rootListView release];
    
    
    
    
}

- (NSInteger)numberOfColumnsInListView:(NSListView *)listView
{
    return [self.infoArray count];
}

- (NSListCell *)listView:(NSListView *)listView viewForColumnAtIndex:(NSInteger)index
{
    static NSString *Identifier = @"NSListCellIndentifer";
    NSListCell *cell = [listView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[[NSListCell alloc] initWithReuseIdentifier:Identifier] autorelease];
    }
    
    cell.alpha = 0.5;
    cell.backgroundColor = [UIColor yellowColor];
//    [cell.titleContentLabel setText:[NSString stringWithFormat:@"第%d行",index+1]];
    
    [cell.titleContentLabel setText:[self.infoArray objectAtIndex:index]];
    return cell;
}

- (void) listView:(NSListView *)listView didSelectColumnAtIndex:(NSInteger)index {
    NSLog(@"点击了cell: %d",index);
}


- (CGFloat)widthForColumnAtIndex:(NSInteger)index
{
    return 100;
}

- (IBAction)onTestButtonClick:(id)sender
{
    self.infoArray = [NSArray arrayWithObjects:@"FU", @"MU",@"Beijing", @"TheValue", @"The", @"vam",nil];
    [rootListView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
