//
//  ViewController.m
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/27.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+YVTopBarController.h"

@interface ViewController ()<UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:[UIColor redColor],[UIColor greenColor],[UIColor yellowColor], nil];
    for (NSInteger i=0; i<array.count; i++) {
        UIViewController *viewController = [UIViewController new];
        viewController.title = [NSString stringWithFormat:@"页面%ld",(long)i];
        viewController.view.backgroundColor = array[i];
        [viewControllers addObject:viewController];
    }
    self.viewControllers = viewControllers;
}

- (void)didScrollToIndex:(NSInteger)index{
    NSLog(@"scrollToIndex:%ld",(long)index);
}

#pragma mark
- (CGSize)topBar:(YVTopBar *)topBar SizeForIndex:(NSInteger)index{
    return CGSizeMake(YViPhoneWidth/2, YVTopBarItemHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
