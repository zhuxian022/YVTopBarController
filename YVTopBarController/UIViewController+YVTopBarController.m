//
//  UIViewController+YVTopBarController.m
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/27.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "UIViewController+YVTopBarController.h"
#import <objc/runtime.h>

@implementation UIViewController (YVTopBarController)


- (void)didScrollToIndex:(NSInteger)index{
    
}

#pragma mark -Setter-

#pragma mark - viewControllers-
static const char YVViewControllers = '\0';
- (void)setViewControllers:(NSMutableArray *)viewControllers{
    objc_setAssociatedObject(self, &YVViewControllers,
                             viewControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.contentView setViewControllers:@[viewControllers[self.selectedIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    //处理标题
    NSMutableArray *titles = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        if (vc.title) {
            [titles addObject:vc.title];
        }
        else{
            [titles addObject:@""];
        }
    }
    self.topBar.titles = titles;
}

- (NSMutableArray *)viewControllers{
    NSMutableArray *array = objc_getAssociatedObject(self, &YVViewControllers);
    if (array) {
        return array;
    }
    else{
        return [NSMutableArray array];
    }
}

#pragma mark - selectedIndex-
static const char YVSelectedIndex = '\0';
- (void)setSelectedIndex:(NSInteger)selectedIndex{
    NSInteger oldIndex = self.selectedIndex;
    if (selectedIndex<self.viewControllers.count){
        if (self.contentView) {
            [self.contentView setViewControllers:@[self.viewControllers[selectedIndex]] direction:oldIndex<selectedIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        if (self.topBar) {
            self.topBar.selectedIndex = selectedIndex;
        }
    }
    
    objc_setAssociatedObject(self, &YVSelectedIndex,
                             [NSString stringWithFormat:@"%ld",(long)selectedIndex], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)selectedIndex{
    NSString *index = objc_getAssociatedObject(self, &YVSelectedIndex);
    if (index) {
        return [index integerValue];
    }
    else{
        return 0;
    }
}

#pragma mark -contentView-
static const char YVContentView = '\0';
- (UIPageViewController *)contentView{
    UIPageViewController *pageViewController = objc_getAssociatedObject(self, &YVContentView);
    if (!pageViewController) {
        pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        pageViewController.delegate = self;
        pageViewController.dataSource = self;
        
        if (self.selectedIndex<self.viewControllers.count) {
            [pageViewController setViewControllers:@[self.viewControllers[self.selectedIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        }
        
        [self addChildViewController:pageViewController];
        [self.view addSubview:pageViewController.view];
        
        objc_setAssociatedObject(self, &YVContentView, pageViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return pageViewController;
}

#pragma mark -topBar-
static const char YVTopBarView = '\0';
- (YVTopBar *)topBar{
    YVTopBar *topBarView = objc_getAssociatedObject(self, &YVTopBarView);
    if (!topBarView) {
        CGFloat height = [self heightForTopBar:nil];
        
        topBarView = [[YVTopBar alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.translucent?YVTopBarNavigationHeight:0, YVTopBariPhoneWidth, height)];
        topBarView.delegate = self;
        topBarView.dataSource = self;
        topBarView.selectedIndex = self.selectedIndex;
        
        if (self.viewControllers.count) {
            //处理标题
            NSMutableArray *titles = [NSMutableArray array];
            for (UIViewController *vc in self.viewControllers) {
                if (vc.title) {
                    [titles addObject:vc.title];
                }
                else{
                    [titles addObject:@""];
                }
            }
            topBarView.titles = titles;
        }
        
        [self.view addSubview:topBarView];
        
        objc_setAssociatedObject(self, &YVTopBarView, topBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return topBarView;
}

#pragma mark -UIPageViewController-
//数据源
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (index == 0 || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self.viewControllers objectAtIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (index == self.viewControllers.count - 1 || (index == NSNotFound)) {
        
        return nil;
    }
    
    index++;
    
    return [self.viewControllers objectAtIndex:index];
}

//滑动开始事件
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    UIViewController *nextVC = [pendingViewControllers firstObject];
    
    NSInteger index = [self.viewControllers indexOfObject:nextVC];
    
    objc_setAssociatedObject(self, &YVSelectedIndex,
                             [NSString stringWithFormat:@"%ld",(long)index], OBJC_ASSOCIATION_ASSIGN);
    
//    self.topBar.selectedIndex = index;
    
//    [self didScrollToIndex:index];
}

//滑动完成事件
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    UIViewController *vc = [previousViewControllers lastObject];
    NSUInteger index = [self.viewControllers indexOfObject:vc];
    
    //    NSLog(@"finish=%@,complete=%@,index=%lu",finished?@"Yes":@"NO",completed?@"Yes":@"NO",(unsigned long)index);
    if (index != NSNotFound){
        //没有完成页面切换 还原_currentIndex
        if (!completed && finished){
            objc_setAssociatedObject(self, &YVSelectedIndex,
                                     [NSString stringWithFormat:@"%ld",(long)index], OBJC_ASSOCIATION_ASSIGN);
        }
        else{
            [self didScrollToIndex:self.selectedIndex];
        }
    }
    
    //    NSLog(@"selectedIndex=%ld",(long)_selectedIndex);
    self.topBar.selectedIndex = self.selectedIndex;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.selectedIndex <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -TopBarDelegate-
- (CGFloat)heightForTopBar:(YVTopBar *)topBar{
    return YVTopBarItemHeight;
}

- (void)topBar:(YVTopBar *)topBar didClickIndex:(NSInteger)index{
    NSInteger oldIndex = self.selectedIndex;
    
    objc_setAssociatedObject(self, &YVSelectedIndex,
                             [NSString stringWithFormat:@"%ld",(long)index], OBJC_ASSOCIATION_ASSIGN);
    
    if (self.selectedIndex<self.viewControllers.count){
        if (self.contentView) {
            [self.contentView setViewControllers:@[self.viewControllers[self.selectedIndex]] direction:(oldIndex<self.selectedIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse) animated:YES completion:nil];
        }
        
        [self didScrollToIndex:self.selectedIndex];
    }
}

@end
