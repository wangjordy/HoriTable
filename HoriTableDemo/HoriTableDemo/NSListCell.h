//
//  NSListCell.h
//  HoriTableDemo
//
//  Created by 王兴朝 on 13-5-9.
//  Copyright (c) 2013年 bitcar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSListCell : UITableViewCell

@property (nonatomic, copy) NSString * reuseIdentifier;
@property (nonatomic, assign) UIView *separatorView;
@property (nonatomic, assign) UILabel *titleContentLabel;
- (id)initWithReuseIdentifier:(NSString *) reuseIdentifier;

- (void)setTextContent:(NSString *)content;

@end
