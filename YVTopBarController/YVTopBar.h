//
//  YVTopBar.h
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/27.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YVTopBarItemHeight 35
#define YVDefaultSepeWidth 0
#define YVSlideLineHeight 1

#define YVIsDeviceIPhoneX  CGSizeEqualToSize([UIScreen mainScreen].currentMode.size, CGSizeMake(1125, 2436))

//设备宽高
#define YViPhoneWidth ([UIScreen mainScreen].bounds.size.width)
//导航栏、tabbar
#define YVNavigationHeight (YVIsDeviceIPhoneX?88:64)

@class YVTopBar;
@class YVTopBarItem;

#pragma mark -DataSource-
@protocol YVTopBarDataSource <NSObject>

@optional
- (CGSize)topBar:(YVTopBar *)topBar SizeForIndex:(NSInteger)index;

- (CGFloat)sepeWidthForTopBar:(YVTopBar *)topBar;

- (CGFloat)heightForTopBar:(YVTopBar *)topBar;

#pragma mark -Custom Item-
/*
    ***自定义item必须实现下面两个方法
 */
- (NSString *)reUsableItemClassNameForTopBar:(YVTopBar *)topBar;

- (YVTopBarItem *)topBar:(YVTopBar *)topBar ReUsableItem:(YVTopBarItem *)reUsableItem TitleItemForIndex:(NSInteger)index;

@end

#pragma mark -Delegate-
@protocol YVTopBarDelegate <NSObject>

@optional
- (void)topBar:(YVTopBar *)topBar didClickIndex:(NSInteger)index;

@end

#pragma mark -TopBar-
@interface YVTopBar : UIView

@property (nonatomic ,weak) id<YVTopBarDataSource> dataSource;
@property (nonatomic ,weak) id<YVTopBarDelegate> delegate;

@property (nonatomic ,strong) UICollectionView *ItemsView;

/*
 滚动横条
 */
@property (nonatomic ,strong) UIView *bottomLine;

/*
 当前显示第几个,默认为0
 */
@property (nonatomic ,assign) NSInteger selectedIndex;

/*
 顶部菜单显示几个，为0则根据每个子控制器的标题宽度自适应，不为0则平均宽度
 */
@property (nonatomic ,assign) NSInteger numberOfItem;

/*
 顶部菜单标题
 */
@property (nonatomic ,strong) NSArray *titles;

//重新加载
- (void)reload;

@end

#pragma mark -TopBarItem-
@interface YVTopBarItem : UICollectionViewCell

+ (CGSize)sizeWithTitle:(NSString *)title MaxCount:(NSInteger)maxCount SepeWidth:(CGFloat)sepeWidth;

- (void)loadWithTitle:(NSString *)title;

@end
