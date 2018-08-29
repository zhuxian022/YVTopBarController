//
//  YVDemoViewController.m
//  YVTopBarControllerDemo
//
//  Created by ale tan on 2018/8/28.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "YVDefaultTopBarController.h"
#import "UIViewController+YVTopBarController.h"

@interface YVDefaultTopBarController ()

@end

@implementation YVDefaultTopBarController

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
    
    //自定义样式
    if (_customStyle) {
        self.topBar.titleColor = [UIColor grayColor];
        self.topBar.tintColor = [UIColor redColor];
        self.topBar.titleFont = [UIFont systemFontOfSize:15];
        self.topBar.tintFont = [UIFont systemFontOfSize:17];
    }
}

- (void)didScrollToIndex:(NSInteger)index{
    NSLog(@"scrollToIndex:%ld",(long)index);
}

@end
