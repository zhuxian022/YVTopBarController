//
//  UIViewController+YVTopBarController.h
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/27.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YVTopBar.h"

@interface UIViewController (YVTopBarController)<YVTopBarDataSource,YVTopBarDelegate,UIPageViewControllerDataSource,UIPageViewControllerDelegate>

/*
 子控制器
 */
@property (nonatomic ,strong) NSMutableArray *viewControllers;

/*
 mainView
 */
@property (nonatomic ,strong ,readonly) UIPageViewController *contentView;

/*
 titleView
 */
@property (nonatomic ,strong ,readonly) YVTopBar *topBar;

/*
 当前显示第几个,默认为0
 */
@property (nonatomic ,assign) NSInteger selectedIndex;

//通过重写此方法，获取滑动时的action
- (void)didScrollToIndex:(NSInteger)index;

@end
