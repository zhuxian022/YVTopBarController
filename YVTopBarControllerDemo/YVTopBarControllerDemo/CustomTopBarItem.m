//
//  CustomTopBarItem.m
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/28.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "CustomTopBarItem.h"

@implementation CustomTopBarItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:self];
    
    if (selected) {
        _titleLabel.textColor = [UIColor redColor];
    }
    else{
        _titleLabel.textColor = [UIColor blackColor];
    }
}

@end
