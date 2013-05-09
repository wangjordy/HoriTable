//
//  NSListCell.m
//  HoriTableDemo
//
//  Created by 王兴朝 on 13-5-9.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//

#import "NSListCell.h"

@implementation NSListCell
@synthesize separatorView;
@synthesize reuseIdentifier;
@synthesize titleContentLabel;


- (id)initWithReuseIdentifier:(NSString *)thereuseIdentifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.reuseIdentifier = thereuseIdentifier;
        
        //设置分割线
        UIView *_separatorView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width-1, 0, self.bounds.size.width, self.bounds.size.height)];
        [_separatorView setBackgroundColor:[UIColor blackColor]];
        self.separatorView = _separatorView;
        [self addSubview:_separatorView];
        [_separatorView release];
        
        UILabel *theTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 20)];
        [theTitleLabel setText:@""];
        [theTitleLabel setBackgroundColor:[UIColor clearColor]];
        [theTitleLabel setTextColor:[UIColor blackColor]];
        [theTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [theTitleLabel setFont:[UIFont systemFontOfSize:14]];
        self.titleContentLabel = theTitleLabel;
        [self addSubview:theTitleLabel];
        [theTitleLabel release];
    }
    return self;
}

- (void)setTextContent:(NSString *)content
{
    NSLog(@"CONTENT: %@",content);
    
    [self.titleContentLabel setText:content];
}


- (void)dealloc
{
    [reuseIdentifier release];
    reuseIdentifier = nil;
    
    separatorView = nil;
    titleContentLabel = nil;
    [super dealloc];
}

@end
