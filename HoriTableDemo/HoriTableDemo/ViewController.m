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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSListView *listView = [[NSListView alloc] initWithFrame:CGRectMake(0, 200, 320, 100)];
    [listView setDelegate:self];
    [listView setDataSource:self];
    [listView setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:listView];
    [listView release];
}

- (NSInteger)numberOfColumnsInListView:(NSListView *)listView
{
    return 10;
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
    [cell.titleContentLabel setText:[NSString stringWithFormat:@"第%d行",index+1]];

    return cell;
}

- (void) listView:(NSListView *)listView didSelectColumnAtIndex:(NSInteger)index {
    NSLog(@"点击了cell: %d",index);
}


- (CGFloat)widthForColumnAtIndex:(NSInteger)index
{
    return 100;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
