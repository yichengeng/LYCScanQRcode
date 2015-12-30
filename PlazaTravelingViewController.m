//
//  PlazaTravelingViewController.m
//  PlazaTravel
//
//  Created by liuyichen on 15/12/8.
//  Copyright © 2015年 yichen. All rights reserved.
//

#import "PlazaTravelingViewController.h"
#import "Scan2DBarcodeController.h"
#import "ShufflingFigureViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface PlazaTravelingViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *pageSegement;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollowView;




@end

@implementation PlazaTravelingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pageSegement addTarget:self action:@selector(handlePageSegment:) forControlEvents:UIControlEventValueChanged];
    self.scrollowView.delegate = self;
    [self designNavigationBarStyle];
    
    
}

#pragma mark - DesignNavigationBarStyle
- (void)designNavigationBarStyle
{
    self.navigationItem.title = @"逸云游";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:19.0f]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:244/255.0 green:123/255.0 blue:211/255.0 alpha:0.5];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-saoerweima"] style:UIBarButtonItemStyleDone target:self action:@selector(handleScanBarAction:)];
    [self.navigationItem.leftBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"_location@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(handleRightBarAction:)];
    [self.navigationItem.rightBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)handleScanBarAction:(UIBarButtonItem *)sender
{
    Scan2DBarcodeController *scanBCVC = [[Scan2DBarcodeController alloc] init];
    UINavigationController *navS = [[UINavigationController alloc] initWithRootViewController:scanBCVC];
    [self presentViewController:navS animated:YES completion:nil];
}

- (void)handleRightBarAction:(UIBarButtonItem *)sender
{
    ShufflingFigureViewController *shufflFVC = [[ShufflingFigureViewController alloc] init];
    UINavigationController *navS = [[UINavigationController alloc] initWithRootViewController:shufflFVC];
    shufflFVC.URLstring = @"http://ditu.amap.com/around";
    shufflFVC.titleString = @"位置搜索";
    [self presentViewController:navS animated:YES completion:nil];
}

- (void)handlePageSegment:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
        {
            [self.scrollowView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        }
            break;
        case 1:
        {
            [self.scrollowView setContentOffset:CGPointMake(WIDTH, 0.0) animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageSegement.selectedSegmentIndex = self.scrollowView.contentOffset.x / WIDTH;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
