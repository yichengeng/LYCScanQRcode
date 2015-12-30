//
//  ShufflingFigureViewController.m
//  PlazaTravel
//
//  Created by liuyichen on 15/12/19.
//  Copyright © 2015年 yichen. All rights reserved.
//

#import "ShufflingFigureViewController.h"
#import "MONActivityIndicatorView.h"
#import "UIImageView+WebCache.h"

@interface ShufflingFigureViewController ()<UIWebViewDelegate, MONActivityIndicatorViewDelegate>

@property (nonatomic, strong)UIWebView *webView;
//加载指示器
@property (nonatomic, strong)MONActivityIndicatorView *indicator;

@end

@implementation ShufflingFigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self designNavigationBarStyle];
    if ([_URLstring hasPrefix:@"http://"]) {
        /// 防止数据中有中文
        NSString *string = [_URLstring stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        NSURL *URL = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [_webView loadRequest:request];
        
        /**
         * 设置代理
         */
        _webView.delegate = self;
        [self.view addSubview:_webView];
        
        /**
         *  创建指示器对象
         */
        self.indicator = [[MONActivityIndicatorView alloc] init];
        _indicator.delegate = self;
        /**
         *  彩色点的个数
         */
        _indicator.numberOfCircles = 15;
        /**
         *  彩色点的大小
         */
        _indicator.radius = 6;
        /**
         *  彩色点的间距
         */
        _indicator.internalSpacing = 5;
        /**
         *  持续时间
         */
        _indicator.duration = 0.9;
        /**
         *  彩色点创建的延迟
         */
        _indicator.delay = 0.3;
        _indicator.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
        [self.view addSubview:_indicator];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"^~^网址有误,请核对网址后进入" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -- DesignNavigationBarStyle
- (void)designNavigationBarStyle
{
    self.navigationItem.title = _titleString;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:19.0f]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back@2x"] style:UIBarButtonItemStyleDone target:self action:@selector(handleLeftBarAction:)];
    [self.navigationItem.leftBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}



- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView circleBackgroundColorAtIndex:(NSUInteger)index
{
    return [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:0.5];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)handleLeftBarAction:(UIBarButtonItem *)sender
{
    [_indicator stopAnimating];
    ///SDWebImage清除缓存
    [[SDImageCache sharedImageCache] cleanDisk];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    /**
     *  设置样式
     */
    [self.view addSubview: _indicator];
    [_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicator stopAnimating];
    ///SDWebImage清除缓存
    [[SDImageCache sharedImageCache] cleanDisk];
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
