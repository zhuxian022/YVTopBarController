# YVTopBarController

![quickLook](https://github.com/zhuxian022/YVTopBarController/blob/master/view.gif?raw=true)

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
#### implemente YVTopBarDataSource
