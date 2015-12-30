//
//  PlazaMineTableController.m
//  PlazaTravel
//
//  Created by liuyichen on 15/12/19.
//  Copyright © 2015年 yichen. All rights reserved.
//

#import "PlazaMineTableController.h"
#import "ScrollingNavbarViewController.h"
#import "UINavigationBar+Hidden.h"
#import "UIImageView+WebCache.h"
#import "STPopupController.h"
#import "PopupViewController.h"
#import "UIViewController+STPopup.h"
#define NAVBAR_CHANGE_POINT 50
#define BACKGROUND_IMAGE 200
#define PHOTOHEIGHT 75


@interface PlazaMineTableController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIImageView *photoImageView;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PlazaMineTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    /**
     *  创建表视图
     */
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    /**
     *  设置代理
     */
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self designNavigationBarStyle];
    [self addHeaderView];
}

- (void)addHeaderView {
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, BACKGROUND_IMAGE)];
    /**
     *  设置背景图片
     *  将背景图片的fram设置为-64可以是背景图片可以顶着屏幕顶部
     */
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BACKGROUND_IMAGE)];
    backgroundImageView.userInteractionEnabled = YES;
    backgroundImageView.image = [UIImage imageNamed:@"pugongying"];
    //若将Image设置成颜色将会原尺寸填充，不自适应
    //    UIColor *color = [UIColor colorWithPatternImage:image];
    /**
     *  设置头像
     */
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PHOTOHEIGHT / 2, BACKGROUND_IMAGE - PHOTOHEIGHT / 1.5 - 64, PHOTOHEIGHT, PHOTOHEIGHT)];
    _photoImageView.layer.cornerRadius = PHOTOHEIGHT / 2;
    _photoImageView.userInteractionEnabled = YES;
    _photoImageView.image = [UIImage imageNamed:@"comment_profile_mars@2x"];
    /**
     *  设置头像更换照片手势
     */
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchAction:)];
    [_photoImageView addGestureRecognizer:tapG];
    _photoImageView.layer.masksToBounds = YES;
    _photoImageView.layer.cornerRadius = PHOTOHEIGHT / 2;
    [backgroundImageView addSubview:_photoImageView];
    
    [self.tableView.tableHeaderView addSubview:backgroundImageView];
}

- (void)handleTouchAction:(UITapGestureRecognizer *)sender
{
    UIImagePickerController *imageP = [[UIImagePickerController alloc] init];
    //设置资源类型
    imageP.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //设置当前图片是否允许编辑
    imageP.allowsEditing = YES;
    /**
     *  设置代理
     */
    imageP.delegate = self;
    //跳转到图片选择界面进行图片选择
    [self presentViewController:imageP animated:YES completion:nil];
}

#pragma mark UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //取出编辑之后的图片并且展示到对应的imageView上
    UIImage *editedImage = info[@"UIImagePickerControllerEditedImage"];
    //设置图片
    _photoImageView.image = editedImage;
    //返回上一个界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//区头将要被拖拽消失的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pugongying"]];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark Design NavigationBar Style
- (void)designNavigationBarStyle
{   /**
     *  设置导航条外观
     */
    self.navigationItem.title = @"我的";//设置标题文字
    self.navigationController.navigationBar.alpha = 0.0;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:23.0f]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 计算cacahe文件夹下缓存大小
- (CGFloat)getSizeOfCache {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    long long  size = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerPath = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerPath) {
            NSString *absolutPath = [path stringByAppendingPathComponent:fileName];
            ///计算子文件夹下单个文件大小
            size += [fileManager attributesOfItemAtPath:absolutPath error:nil].fileSize;
        }
        ///SDWebImage自带框架计算缓存
        size += [[SDImageCache sharedImageCache] getSize];
    }
    ///计算多少MB并返回
    return size / 1024.0 / 1024.0;
}
#pragma mark - 清除缓存
///清除缓存
- (void)clearCache {
    /**
     *  获取沙盒文件路径
     */
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *childPathArray = [manager subpathsAtPath:path];
        for (NSString *childPath in childPathArray) {
            NSString *absolutPath = [path stringByAppendingPathComponent:childPath];
            ///清除文件
            [manager removeItemAtPath:absolutPath error:nil];
        }
        ///SDWebImage清除缓存
        [[SDImageCache sharedImageCache] cleanDisk];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.section != 2) {
        cell.accessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
        cell.accessoryView.frame = CGRectMake(0, 0, 23, 23);
        UIColor *accessoryColor = [UIColor colorWithPatternImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"night_back@2x"].CGImage]];
        cell.accessoryView.backgroundColor = accessoryColor;
    }
    if (indexPath.section == 2) {
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TouchAction:)];
        [cell.accessoryView addGestureRecognizer:tapG];
    }
    if (indexPath.section == 2) {
        UISwitch *switch0 = [[UISwitch alloc] init];
        [switch0 addTarget:self action:@selector(handleSwitchAction:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switch0;
    }
    /**
     *  取消选中显示
     */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"我的收藏";
            cell.textLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:143 / 255.0 blue:97 / 255.0 alpha:1.0];
            break;
        case 1:
            cell.textLabel.text = @"清理足迹";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", [self getSizeOfCache]];
            cell.textLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:143 / 255.0 blue:97 / 255.0 alpha:1.0];
            break;
        case 2:
            cell.textLabel.text = @"开启夜间模式";
            cell.textLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:143 / 255.0 blue:97 / 255.0 alpha:1.0];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)handleSwitchAction:(UISwitch *)switch0
{
    UITableViewCell *cell = (UITableViewCell *)switch0.superview;
    if (switch0.selected == YES) {
        [UIApplication sharedApplication].keyWindow.alpha = 1.0;
        cell.textLabel.text = @"开启夜间模式";
    }
    else
    {
        [UIApplication sharedApplication].keyWindow.alpha = 0.5;
        cell.textLabel.text = @"关闭夜间模式";
    }
    /// 执行功能之后改变 switch 的选中状态值
    switch0.selected = !switch0.selected;
}

- (void)TouchAction:(UITapGestureRecognizer *)sender
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"HELLO,Walker!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    /**
     *  替换block块内的self
     */
    __weak PlazaMineTableController *pMineVC = self;
    ///由于拥有action事件的控件放在cell的辅助视图上，要获取到cell，可以通过获取到action事件的视图的父视图来获取cell
    UITableViewCell *cell = (UITableViewCell *)sender.view.superview;
    if (![cell.detailTextLabel.text isEqualToString:@"0.00M"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"^~^亲爱的行者,清理记忆的痕迹？"];
        [message addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0, message.length)];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:123/255.0 blue:211/255.0 alpha:0.5] range:NSMakeRange(0, message.length)];
        [alertC setValue:message forKey:@"attributedMessage"];
        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"^~^清理" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [pMineVC clearCache];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", [pMineVC getSizeOfCache]];
        }];
        [alertC addAction:clearAction];
    } else {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"亲爱的行者,还没有足迹哦^~^"];
        [message addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0, message.length)];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:123/255.0 blue:211/255.0 alpha:0.5] range:NSMakeRange(0, message.length)];
        [alertC setValue:message forKey:@"attributedMessage"];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不。。" style:UIAlertActionStyleDestructive handler:nil];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30 * [UIScreen mainScreen].bounds.size.height / 375;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"HELLO,Walker!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak PlazaMineTableController *pMineVC = self;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell.detailTextLabel.text isEqualToString:@"0.00M"] && indexPath.section == 1) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"^~^亲爱的行者,清理记忆的痕迹？"];
        [message addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0, message.length)];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:123/255.0 blue:211/255.0 alpha:0.5] range:NSMakeRange(0, message.length)];
        [alertC setValue:message forKey:@"attributedMessage"];
        UIAlertAction *clearAction = [UIAlertAction actionWithTitle:@"清理^~^" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [pMineVC clearCache];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", [pMineVC getSizeOfCache]];
        }];
        [alertC addAction:clearAction];
    } else if (indexPath.section == 1) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"亲爱的行者,还没有足迹哦^~^"];
        [message addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0f] range:NSMakeRange(0, message.length)];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:123/255.0 blue:211/255.0 alpha:0.5] range:NSMakeRange(0, message.length)];
        [alertC setValue:message forKey:@"attributedMessage"];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不。。" style:UIAlertActionStyleDestructive handler:nil];
    switch (indexPath.section) {
        case 0:
        {
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[PopupViewController new]];
            popupController.cornerRadius = 4;
            popupController.transitionStyle = STPopupTransitionStyleFade;
            [popupController presentInViewController:self];
        }
            break;
        case 1:
            [alertC addAction:cancelAction];
            [self presentViewController:alertC animated:YES completion:nil];
            break;
        default:
            break;
    }
}

/**
 *  因为在创建表视图的时候style类型设置为UITableViewStyleGrouped,默认带有区头区尾,所以根据所需将返回高度设为零点几可以令所设置的区头或区尾像素为极小,将其在视觉上消除
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 3){
        return 0.001;
    }else
    {
        return 15;
    }
}

@end
