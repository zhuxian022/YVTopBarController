# YVTopBarController

![quickLook](https://github.com/zhuxian022/YVTopBarController/blob/master/view.gif?raw=true)

## Installation
#### 1.cocoapod 
```Object-C
pod 'YVTopBarController', '~> 1.1.1'
```

#### 2.add Files to your project

## Update 
* #### 2018.08.28 First version   v0.0.1
* #### 2018.08.29 Custom titleColor、titleFont、tintFont  v1.0
* #### 2018.08.29 decoupling macro definition
* #### 2019.05.27 fix bugs

## How To Use
#### create a subClass of UIViewController
#### import "UIViewController+YVTopBarController.h"
#### set viewControllers
```Object-C
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
}
```

### Attentions:
#### 1.topBarItem's text equals to childViewController's title.if childViewController's title is `nil`,defaultTopBarItem's text is `nil`
#### 2.childViewController's view layout should include topBar's frame.

## Change ViewController Event
#### implemente method 
```Object-C
- (void)didScrollToIndex:(NSInteger)index    
```

## Custom Your TopBarItem
#### implement YVTopBarDataSource
```Object-C
//topBar高度
- (CGFloat)heightForTopBar:(YVTopBar *)topBar;

//每个item的size
- (CGSize)topBar:(YVTopBar *)topBar SizeForIndex:(NSInteger)index;

//间隔
- (CGFloat)sepeWidthForTopBar:(YVTopBar *)topBar;

/*
***自定义item必须实现下面两个方法
*/

//自定义item的类名，方便collectionView注册
- (NSString *)reUsableItemClassNameForTopBar:(YVTopBar *)topBar;

//对reUsableItem填充数据、设置样式...
- (YVTopBarItem *)topBar:(YVTopBar *)topBar ReUsableItem:(YVTopBarItem *)reUsableItem TitleItemForIndex:(NSInteger)index;    
```
