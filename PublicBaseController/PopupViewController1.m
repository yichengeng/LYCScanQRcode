//
//  PopupViewController1.m
//  PlazaTravel
//
//  Created by liuyichen on 15/12/21.
//  Copyright © 2015年 yichen. All rights reserved.
//

#import "PopupViewController1.h"
#import "UIViewController+STPopup.h"
#import "STPopupController.h"
#import "Masonry.h"
#import "QRCodeGenerator.h"
#import "ShufflingFigureViewController.h"
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

@interface PopupViewController1 ()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *outImageView;

@end

@implementation PopupViewController1

{
    UIView *_separatorView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"二维码";
        self.contentSizeInPopup = CGSizeMake(300, 400);
        self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonDidTap)];
    /// 设置弹窗的底层视图
    _separatorView = [UIView new];
    _separatorView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.view addSubview:_separatorView];
    
    /// 设置输入框的属性
    _textField = [UITextField new];
    _textField.placeholder = @"Tap to input";
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.placeholder =@" 请输入二维码内容,网址请以http://开头";
    
    /// 设置输入框的代理
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.layer.masksToBounds = YES;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.font = [UIFont boldSystemFontOfSize:15.0];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];
    
    // 设置定时器
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(create) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
    /// 设置放置二维码图的ImageView
    _outImageView = [[UIImageView alloc]init];
    _outImageView.layer.borderWidth = 2.0f;
    _outImageView.layer.borderColor = [UIColor redColor].CGColor;
    _outImageView.userInteractionEnabled = YES;
    UIImage *image = [UIImage imageNamed:@"pugongying"];
    UIImage *tempImage = [QRCodeGenerator qrImageForString:@"逸云游" imageSize:270 Topimg:image withColor:RandomColor];
    _outImageView.image = tempImage;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [_outImageView addGestureRecognizer:longPress];
    [self.view addSubview:_outImageView];
    
}

#pragma mark-> 二维码生成
-(void)create{
    
    UIImage *image=[UIImage imageNamed:@"pugongying"];
    NSString*tempStr;
    if(self.textField.text.length==0){
        if (![tempStr isEqualToString:@"http://www.bilibili.com/"]) {
            tempStr = @"http://www.bilibili.com/";
        }
        UIImage *tempImage = [QRCodeGenerator qrImageForString:tempStr imageSize:270 Topimg:image withColor:RandomColor];
        
        _outImageView.image = tempImage;
    }else{
        
        tempStr = self.textField.text;
        
        UIImage *tempImage = [QRCodeGenerator qrImageForString:tempStr imageSize:270 Topimg:image withColor:RandomColor];
        
        _outImageView.image = tempImage;
    }
}

#pragma mark-> 长按识别二维码
-(void)dealLongPress:(UIGestureRecognizer*)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        _timer.fireDate = [NSDate distantFuture];
        
        //1. 初始化扫描仪，设置设别类型和识别质量
        UIImageView *tempImageView = (UIImageView*)gesture.view;
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        //2. 扫描获取的特征组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:tempImageView.image.CGImage]];
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        if(tempImageView.image && features[0] != nil){
            //3. 获取扫描结果
            NSString *scannedResult = feature.messageString;
            
            /// 设置UIAlertController的提示框
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:scannedResult preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                /// 跳转webView展示网址内容
                ShufflingFigureViewController *shufflFVC = [[ShufflingFigureViewController alloc] init];
                UINavigationController *navS = [[UINavigationController alloc] initWithRootViewController:shufflFVC];
                shufflFVC.URLstring = scannedResult;
                [_session startRunning];
                [_timer invalidate];
                [self presentViewController:navS animated:YES completion:nil];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_session startRunning];
                [_timer invalidate];
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫描结果" message:@"您还没有生成二维码" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        
        
        _timer.fireDate = [NSDate distantPast];
    }
    
    
}

#pragma mark-> 布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _textField.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    _separatorView.frame = CGRectMake(0, _textField.frame.origin.y - 0.5, self.view.frame.size.width, 0.5);
    _outImageView.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, self.view.frame.size.height - 20 - _textField.frame.size.height);
    
    __weak __typeof(self)weakSelf  = self;
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(100);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(80);
        
    }];
    
    
    [_outImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(weakSelf.textField.mas_bottom).offset(10);
        make.bottom.mas_equalTo(-10);
        
        
    }];
}

- (void)closeButtonDidTap
{
    [_timer invalidate];
    [_session startRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark->textFiel delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self create];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _timer.fireDate=[NSDate distantFuture];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    _timer.fireDate=[NSDate distantPast];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
