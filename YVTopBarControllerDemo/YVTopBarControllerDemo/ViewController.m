//
//  ViewController.m
//  YVTopBarControllerDemo
//
//  Created by yi von on 2018/8/27.
//  Copyright © 2018年 YiVon. All rights reserved.
//

#import "ViewController.h"
#import "YVDefaultTopBarController.h"
#import "YVCustomTopBarController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.translucent = NO;
    self.title = @"YVTopBarControllerDemo";
    
    _titles = @[@"默认TopBar",@"自定义TopBar"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableView-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        YVDefaultTopBarController *defaultTBC = [[YVDefaultTopBarController alloc]init];
        defaultTBC.title = _titles[indexPath.row];
        [self.navigationController pushViewController:defaultTBC animated:YES];
    }
    else{
        YVCustomTopBarController *customTBC = [[YVCustomTopBarController alloc]init];
        customTBC.title = _titles[indexPath.row];
        [self.navigationController pushViewController:customTBC animated:YES];
    }
}

@end
