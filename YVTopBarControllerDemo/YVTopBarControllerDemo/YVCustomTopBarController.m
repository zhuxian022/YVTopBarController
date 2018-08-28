//
//  YVCustomTopBarController.m
//  YVTopBarControllerDemo
//
//  Created by ale tan on 2018/8/28.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "YVCustomTopBarController.h"
#import "UIViewController+YVTopBarController.h"
#import "CustomTopBarItem.h"

@interface YVCustomTopBarController ()

@end

@implementation YVCustomTopBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addControllers{
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor yellowColor], nil];
    for (NSInteger i=0; i<array.count; i++) {
        UIViewController *viewController = [UIViewController new];
        viewController.title = [NSString stringWithFormat:@"页面%ld",(long)i];
        viewController.view.backgroundColor = array[i];
        [viewControllers addObject:viewController];
    }
    self.viewControllers = viewControllers;
    
    self.topBar.tintColor = [UIColor redColor];
}

- (void)didScrollToIndex:(NSInteger)index{
    NSLog(@"scrollToIndex:%ld",(long)index);
}

#pragma mark
- (CGFloat)heightForTopBar:(YVTopBar *)topBar{
    return 110;
}

- (CGSize)topBar:(YVTopBar *)topBar SizeForIndex:(NSInteger)index{
    return CGSizeMake(80, 80);
}

- (NSString *)reUsableItemClassNameForTopBar:(YVTopBar *)topBar{
    return @"CustomTopBarItem";
}

- (YVTopBarItem *)topBar:(YVTopBar *)topBar ReUsableItem:(YVTopBarItem *)reUsableItem TitleItemForIndex:(NSInteger)index{
    CustomTopBarItem *customItem = (CustomTopBarItem *)reUsableItem;
    customItem.titleLabel.text = [NSString stringWithFormat:@"页面%ld",(long)index];
    return customItem;
}
@end
