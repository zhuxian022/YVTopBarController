# YVTopBarController


## How To Use
#### Create a subClass of YVTopBarController
#### set viewControllers

### Attentions:
#### 1.topBarItem's text equals to childViewController's title.if childViewController's title is `nil`,defaultTopBarItem's text is `nil`
#### 2.childViewController's view layout should include topBar's frame.

## Change ViewController Event
#### implemente method 
```Object-C
    - (void)didScrollToIndex:(NSInteger)index    
```

## Custom Your TopBarItem
#### implemente NavTabBarTitleViewDataSource
