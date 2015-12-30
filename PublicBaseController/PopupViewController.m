//
//  PopupViewController.m
//  PlazaTravel
//
//  Created by liuyichen on 15/12/21.
//  Copyright © 2015年 yichen. All rights reserved.
//

#import "PopupViewController.h"
#import "UIViewController+STPopup.h"
#import "ShufflingFigureViewController.h"

@interface PopupViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PopupViewController

{
    UIView *_separatorView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"我的收藏";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonDidTap)];
    
    _separatorView = [UIView new];
    _separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.view addSubview:_separatorView];
    
    _tableView=[[UITableView alloc]init];
    _tableView.layer.borderWidth=2.0f;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell00"];
    [self.view addSubview:_tableView];
    
    [self.tableView reloadData];
}

#pragma mark-> 布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _separatorView.frame = CGRectMake(0, self.view.frame.size.height - 44 - 0.5, self.view.frame.size.width, 0.5);
    _tableView.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 20);
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell00" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell00"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShufflingFigureViewController *shufflFVC = [[ShufflingFigureViewController alloc] init];
    UINavigationController *navS = [[UINavigationController alloc] initWithRootViewController:shufflFVC];
    [self presentViewController:navS animated:YES completion:nil];
}

- (void)closeButtonDidTap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
