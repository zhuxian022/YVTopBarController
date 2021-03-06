//
//  YVTopBar.m
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/27.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "YVTopBar.h"

//弱引用
#define YVWeakSelf  __weak __typeof(self)weakSelf = self

@interface YVTopBar ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionViewFlowLayout *layout;

@end

@implementation YVTopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //默认样式
        _titleColor = [UIColor lightGrayColor];
        _titleFont = [UIFont systemFontOfSize:12];
        _tintFont = [UIFont systemFontOfSize:13];
        
        [self addTitleCollectionView];
        [self addBottomLine];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    
    if (_ItemsView) {
        [_ItemsView reloadData];
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    
    if (_ItemsView) {
        [_ItemsView reloadData];
    }
}

- (void)setTintFont:(UIFont *)tintFont{
    _tintFont = tintFont;
    
    if (_ItemsView) {
        [_ItemsView reloadData];
    }
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    _numberOfItem = titles?titles.count:0;

    if (!_selectedIndex) {
        _selectedIndex = 0;
    }
    
    [_ItemsView reloadData];
    
    YVWeakSelf;
    if ([_dataSource respondsToSelector:@selector(topBar:ReUsableItem:TitleItemForIndex:)]) {
        [_ItemsView performBatchUpdates:^{
            [weakSelf.ItemsView reloadData];
        } completion:^(BOOL finished) {
            [weakSelf.ItemsView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:weakSelf.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }];
    }
}

- (void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    
    [_ItemsView reloadData];
    _bottomLine.backgroundColor = tintColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    YVTopBarItem *oldItem = (YVTopBarItem *)[_ItemsView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
    oldItem.selected = NO;
    [_ItemsView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES];
    
    _selectedIndex = selectedIndex;
    
    if (_selectedIndex < _titles.count) {
        [_ItemsView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
        [_ItemsView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionNone];
        
        YVTopBarItem *item = (YVTopBarItem *)[_ItemsView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0]];
        [self changeBottomLineFrame:item.frame WithAnimated:animated];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _ItemsView.backgroundColor = backgroundColor;
    [_ItemsView reloadData];
}

- (void)setDataSource:(id<YVTopBarDataSource>)dataSource{
    _dataSource = dataSource;
    
    //注册cell
    if ([_dataSource respondsToSelector:@selector(reUsableItemClassNameForTopBar:)]) {
        NSString *itemName = [_dataSource reUsableItemClassNameForTopBar:self];
        
        if ([[NSBundle mainBundle] pathForResource:itemName ofType:@"xib"] != nil || [[NSBundle mainBundle] pathForResource:itemName ofType:@"nib"] != nil) {
            [_ItemsView registerNib:[UINib nibWithNibName:itemName bundle:nil] forCellWithReuseIdentifier:itemName];
        }
        else{
            [_ItemsView registerClass:NSClassFromString(itemName) forCellWithReuseIdentifier:itemName];
        }
    }
}

- (void)reload{
    [_ItemsView reloadData];
}

#pragma mark -UI-
- (void)addTitleCollectionView{
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0;                          //最小行间距
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _ItemsView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_layout];
    _ItemsView.dataSource = self;
    _ItemsView.delegate = self;
    
    _ItemsView.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        _ItemsView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    _ItemsView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_ItemsView];
    
    //注册cell
    [_ItemsView registerClass:[YVTopBarItem class] forCellWithReuseIdentifier:@"YVTopBarItem"];
    
    //底部分割线
    _sepeLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_ItemsView.frame), CGRectGetMaxY(_ItemsView.frame), CGRectGetWidth(_ItemsView.frame), 0.5)];
    _sepeLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_sepeLine];
}

//滚动条
- (void)addBottomLine{
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_ItemsView.frame)-YVSlideLineHeight, 0, YVSlideLineHeight)];
    _bottomLine.backgroundColor = self.tintColor;
    [_ItemsView addSubview:_bottomLine];
}

- (void)changeBottomLineFrame:(CGRect)itemFrame WithAnimated:(BOOL)animated{
    YVWeakSelf;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomLine.frame = CGRectMake(CGRectGetMinX(itemFrame), CGRectGetMaxY(weakSelf.ItemsView.frame)-YVSlideLineHeight, CGRectGetWidth(itemFrame), YVSlideLineHeight);
        }];
    }
    else{
        self.bottomLine.frame = CGRectMake(CGRectGetMinX(itemFrame), CGRectGetMaxY(weakSelf.ItemsView.frame)-YVSlideLineHeight, CGRectGetWidth(itemFrame), YVSlideLineHeight);
    }
}

#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _titles.count;
}

//最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    if ([self.dataSource respondsToSelector:@selector(sepeWidthForTopBar:)]) {
        return [self.dataSource sepeWidthForTopBar:self];
    }
    else{
        return YVDefaultSepeWidth;
    }
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.dataSource respondsToSelector:@selector(sepeWidthForTopBar:)]) {
        return [self.dataSource sepeWidthForTopBar:self];
    }
    else{
        return YVDefaultSepeWidth;
    }
}

//网格上左下右间距
- (UIEdgeInsets )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if ([self.dataSource respondsToSelector:@selector(sepeWidthForTopBar:)]) {
        CGFloat sepeWidth = [self.dataSource sepeWidthForTopBar:self];
        return UIEdgeInsetsMake(0, sepeWidth, 0, sepeWidth);
    }
    else{
        return UIEdgeInsetsMake(0, YVDefaultSepeWidth, 0, YVDefaultSepeWidth);
    }
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(topBar:SizeForIndex:)]) {
        return [_dataSource topBar:self SizeForIndex:indexPath.item];
    }
    else{
        CGFloat sepeWidth = YVDefaultSepeWidth;
        if ([_dataSource respondsToSelector:@selector(sepeWidthForTopBar:)]) {
            sepeWidth = [_dataSource sepeWidthForTopBar:self];
        }
        
        if (indexPath.item<_titles.count) {
            return [YVTopBarItem sizeWithTitle:_titles[indexPath.item] MaxCount:_numberOfItem SepeWidth:sepeWidth Font:_tintFont?_tintFont:[UIFont systemFontOfSize:13]];
        }
        else{
            return [YVTopBarItem sizeWithTitle:@"" MaxCount:_numberOfItem SepeWidth:sepeWidth Font:_tintFont?_tintFont:[UIFont systemFontOfSize:13]];
        }
    }
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(topBar:ReUsableItem:TitleItemForIndex:)]) {
        
        YVTopBarItem *item = nil;
        
        if ([_dataSource respondsToSelector:@selector(reUsableItemClassNameForTopBar:)]) {
            NSString *className = [_dataSource reUsableItemClassNameForTopBar:self];
            item = [_ItemsView dequeueReusableCellWithReuseIdentifier:className forIndexPath:indexPath];
        }
        
        //选中
        if (indexPath.item == _selectedIndex) {
            item.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self changeBottomLineFrame:item.frame WithAnimated:NO];
        }
        else{
            item.selected = NO;
        }
        
        return [_dataSource topBar:self ReUsableItem:item TitleItemForIndex:indexPath.item];
    }
    else{
        YVTopBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"YVTopBarItem" forIndexPath:indexPath];
        item.backgroundColor = self.backgroundColor;
        item.tintColor = self.tintColor;
        [item styleWithTitleColor:_titleColor TitleFont:_titleFont TintFont:_tintFont];
        
        [item loadWithTitle:_titles[indexPath.item]];
        
        //选中
        if (indexPath.item == _selectedIndex) {
            item.selected = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self changeBottomLineFrame:item.frame WithAnimated:NO];
        }
        else{
            item.selected = NO;
        }
        
        return item;
    }
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != _selectedIndex) {
        YVTopBarItem *oldItem = (YVTopBarItem *)[_ItemsView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
        oldItem.selected = NO;
        [collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] animated:YES];
        
        _selectedIndex = indexPath.item;
        
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        
        if ([_delegate respondsToSelector:@selector(topBar:didClickIndex:)]) {
            [_delegate topBar:self didClickIndex:indexPath.item];
        }
        
        YVTopBarItem *item = (YVTopBarItem *)[_ItemsView cellForItemAtIndexPath:indexPath];
        [self changeBottomLineFrame:item.frame WithAnimated:YES];
    }
}

@end

#pragma mark -YVTopBarItem-
@interface YVTopBarItem ()

@property (nonatomic ,strong) UILabel *titleLabel;

/*
 标题颜色
 
 选中颜色设置tintColor
 */
@property (nonatomic ,strong) UIColor *titleColor;

/*
 标题字体
 */
@property (nonatomic ,strong) UIFont *titleFont;

/*
 选中标题字体
 */
@property (nonatomic ,strong) UIFont *tintFont;

@end

@implementation YVTopBarItem

+ (CGSize)sizeWithTitle:(NSString *)title MaxCount:(NSInteger)maxCount SepeWidth:(CGFloat)sepeWidth Font:(UIFont *)font{
    if (maxCount) {
        return CGSizeMake((YVTopBariPhoneWidth-1-sepeWidth*(maxCount+1))/maxCount, YVTopBarItemHeight);
    }
    else{
        NSMutableDictionary *attr = [NSMutableDictionary new];
        
        attr[NSFontAttributeName] = font;
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(YVTopBariPhoneWidth, YVTopBarItemHeight)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil].size;
        return CGSizeMake(size.width, YVTopBarItemHeight);
    }
}

- (void)styleWithTitleColor:(UIColor *)titleColor TitleFont:(UIFont *)titleFont TintFont:(UIFont *)tintFont{
    _titleColor = titleColor;
    _titleFont = titleFont;
    _tintFont = tintFont;
}

- (void)loadWithTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.titleLabel.font = _tintFont;
        self.titleLabel.textColor = self.tintColor;
    }
    else{
        self.titleLabel.font = _titleFont;
        self.titleLabel.textColor = _titleColor;
    }
}

#pragma mark -UI-
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.font = _titleFont;
        _titleLabel.textColor = _titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    else{
        _titleLabel.frame = self.bounds;
    }
    
    return _titleLabel;
}

@end
