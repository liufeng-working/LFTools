//
//  UIViewController+LFCategory.m
//  test
//
//  Created by 刘丰 on 2017/5/8.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "UIViewController+LFCategory.h"
#import <objc/runtime.h>
#import <Photos/Photos.h>

//图片选择完成
static char imagePickerCompletion;

//交换系统方法
static inline void lf_exchangeInstanceMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    BOOL ok = class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if(ok) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@interface UIViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@interface UIViewController (private)

- (BOOL)isSystemViewController;

@end

@implementation UIViewController (exchangeMethod)

+ (void)load {
    lf_exchangeInstanceMethod(self.class, @selector(viewDidLoad), @selector(lf_viewDidLoad));
    lf_exchangeInstanceMethod(self.class, @selector(viewWillDisappear:), @selector(lf_viewWillDisappear:));
    lf_exchangeInstanceMethod(self.class, @selector(touchesBegan:withEvent:), @selector(lf_touchesBegan:withEvent:));
//    lf_exchangeInstanceMethod(self.class, NSSelectorFromString(@"dealloc"), @selector(lf_dealloc));
}

- (void)lf_viewDidLoad
{
    [self lf_viewDidLoad];
    
    if (self.isSystemViewController) { return; }
    
    self.view.backgroundColor = kBackColor;
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = back;
    
    if ([self respondsToSelector:@selector(tableView)]) {
        [self setValue:@200 forKeyPath:@"tableView.estimatedRowHeight"];
        [self setValue:@(UITableViewAutomaticDimension) forKeyPath:@"tableView.rowHeight"];
        [self setValue:@10 forKeyPath:@"tableView.sectionHeaderHeight"];
        //去除最后一根分割线
        [self setValue:@1 forKeyPath:@"tableView.sectionFooterHeight"];
        //去除多余的分割线
        [self setValue:UIView.new forKeyPath:@"tableView.tableFooterView"];
    }
}

- (void)lf_viewWillDisappear:(BOOL)animated
{
    [self lf_viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)lf_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)lf_dealloc
{
    if (self.isSystemViewController) {
        [self lf_dealloc];
        return;
    }
    
    NSLog(@"%@被销毁了", [self class]);
}

@end

@implementation UIViewController (refresh)
@dynamic refreshHeaderEnable;
@dynamic refreshFooterEnable;

- (void)setRefreshHeaderEnable:(BOOL)refreshHeaderEnable
{
    if (refreshHeaderEnable) {
        if ([self respondsToSelector:@selector(tableView)]) {
            [self setValue:[KTRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)] forKeyPath:@"tableView.mj_header"];
        }
    }else {
        if ([self respondsToSelector:@selector(tableView)]) {
            [self setValue:nil forKeyPath:@"tableView.mj_header"];
        }
    }
}

- (void)setRefreshFooterEnable:(BOOL)refreshFooterEnable
{
    if (refreshFooterEnable) {
        if ([self respondsToSelector:@selector(tableView)]) {
            [self setValue:[KTRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)] forKeyPath:@"tableView.mj_footer"];
        }
    }else {
        if ([self respondsToSelector:@selector(tableView)]) {
            [self setValue:nil forKeyPath:@"tableView.mj_footer"];
        }
    }
}

- (void)loadData
{
    
}

- (void)loadMoreData
{
}

@end

@implementation UIViewController (alert)

/**
 *  展示一个alertView(只有一个确定按钮)
 *
 *  @param title       标题
 *  @param message     详细信息
 *  @param sureTitle   确认按钮标题
 *  @param com         确认回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle withComplete:(void(^)())com
{
    [self showAlertViewWithTitle:title message:message cancelTitle:nil sureTitle:sureTitle withComplete:com];
}

/**
 *  展示一个alertView
 *
 *  @param title       标题
 *  @param message     详细信息
 *  @param cancelTitle 取消按钮标题
 *  @param sureTitle   确认按钮标题
 *  @param com         确认回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle withComplete:(void(^)())com
{
    [self showAlertViewWithTitle:title message:message cancelTitle:cancelTitle sureTitle:sureTitle withCancelComplete:nil withsureComplete:com];
}

/**
 展示一个alertView（有取消和确定按钮）
 
 @param title 标题
 @param message 详细信息
 @param cancelTitle 取消按钮标题
 @param sureTitle 确认按钮标题
 @param cancelAction 取消回调
 @param sureAction 确认回调
 */
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle withCancelComplete:(void(^)())cancelAction withsureComplete:(void(^)())sureAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelTitle) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                cancelAction();
            }
        }];
        [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        [alert addAction:cancel];
    }
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (sureAction) {
            sureAction();
        }
    }];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];}

/**
 *  展示一个alertSheet
 *
 *  @param title   标题
 *  @param nameArr 子标题数组
 *  @param com     确认回调
 */
- (void)showAlertSheetWithTitle:(NSString *)title nameArray:(NSArray <NSString *>*)nameArr withComplete:(void(^)(NSString *selectItem, NSInteger selectIndex))com
{
    [self showAlertSheetWithTitle:title nameArray:nameArr cancelBlock:nil withComplete:com];
}

/**
 展示一个alertSheet
 
 @param title 标题
 @param nameArr 子标题数组
 @param cancelBlock 取消回调
 @param com 确认回调
 */
- (void)showAlertSheetWithTitle:(NSString *)title nameArray:(NSArray <NSString *>*)nameArr cancelBlock:(void(^)())cancelBlock withComplete:(void(^)(NSString *selectItem, NSInteger selectIndex))com
{
    [self.view endEditing:YES];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alert addAction:cancel];
    
    [nameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIAlertAction *allAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (com) {
                com(obj, idx);
            }
        }];
        
        [allAction setValue:kNavColor forKey:@"titleTextColor"];
        [alert addAction:allAction];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

/**
 弹出窗，输入框
 
 @param title 标题
 @param texts text数组
 @param placeholds 占位符数组
 @param sureTitle 确定按钮标题
 @param com 点击“确定”后的回调
 */
- (void)showTextFieldWithTitle:(NSString *)title texts:(NSArray<NSString *> *)texts placeholds:(NSArray<NSString *> *)placeholds sureTitle:(NSString *)sureTitle withComplete:(void(^)(NSArray<UITextField *> *tfs))com
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [placeholds enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = idx < texts.count ? texts[idx] : nil;
            textField.placeholder = obj;
            textField.returnKeyType = UIReturnKeyDone;
            textField.borderStyle = UITextBorderStyleNone;
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (com) {
            com(alert.textFields);
        }
    }];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

@implementation UIViewController (imagePicker)

/**
 展示图片选择器，相册／相机
 */
- (void)showImagePickerWithCompletion:(KTImagePickerCompletion)com
{
    objc_setAssociatedObject(self, &imagePickerCompletion, com, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self showAlertSheetWithTitle:@"选择图片" nameArray:@[@"相册", @"相机"] withComplete:^(NSString *selectItem, NSInteger selectIndex) {
        if ([selectItem isEqualToString:@"相册"]) {
            if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
                [LFNotification autoHideWithText:@"请先设置相册访问权限"];
            }else {
                UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
                pickerC.delegate = self;
                pickerC.allowsEditing = YES;
                pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:pickerC animated:YES completion:nil];
            }
        }
        
        if ([selectItem isEqualToString:@"相机"]) {
            if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
                [LFNotification autoHideWithText:@"请先设置相机访问权限"];
            }else {
                UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
                pickerC.delegate = self;
                pickerC.allowsEditing = YES;
                pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:pickerC animated:YES completion:nil];
            }
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        KTImagePickerCompletion com = objc_getAssociatedObject(self, &imagePickerCompletion);
        if (com) {
            UIImage *edited = info[UIImagePickerControllerEditedImage];
            UIImage *original = info[UIImagePickerControllerOriginalImage];
            com(original, edited);
        }
        objc_removeAssociatedObjects(self);
    }];
}

@end

@implementation UIViewController (datePicker)

/**
 展示一个时间选择器
 
 @param sureBlock 确定回调
 */
- (LFDatePickerViewController *)showDatePickerWithSureBlock:(void(^)(NSString *dateStr, NSDate *date))sureBlock
{
    return [self showDatePickerWithDateFormat:nil datePickerMode:UIDatePickerModeDate sureBlock:sureBlock];
}

/**
 展示一个时间选择器
 
 @param dateFormat 返回的时间字符串的格式
 @param datePickerMode 时间选择器的样式
 @param sureBlock 确定回调
 */
- (LFDatePickerViewController *)showDatePickerWithDateFormat:(NSString *)dateFormat datePickerMode:(UIDatePickerMode)datePickerMode sureBlock:(void(^)(NSString *dateStr, NSDate *date))sureBlock
{
    return [self showDatePickerWithCancelTitle:nil cancelColor:nil sureTitle:nil sureColor:nil dateFormat:nil datePickerMode:datePickerMode cancelBlock:nil sureBlock:sureBlock];
}

/**
 展示一个时间选择器
 
 @param cancelTitle 取消按钮标题
 @param cancelColor 取消按钮颜色
 @param sureTitle 确定按钮
 @param sureColor 确定按钮颜色
 @param dateFormat 返回的时间字符串的格式
 @param datePickerMode 时间选择器的样式
 @param cancelBlock 取消回调
 @param sureBlock 确定回调
 */
- (LFDatePickerViewController *)showDatePickerWithCancelTitle:(NSString *)cancelTitle cancelColor:(UIColor *)cancelColor sureTitle:(NSString *)sureTitle sureColor:(UIColor *)sureColor dateFormat:(NSString *)dateFormat datePickerMode:(UIDatePickerMode)datePickerMode cancelBlock:(void(^)())cancelBlock sureBlock:(void(^)(NSString *dateStr, NSDate *date))sureBlock
{
    LFDatePickerViewController *datePickerVC = [[LFDatePickerViewController alloc] init];
    if (cancelTitle) {
        datePickerVC.cancelTitle = cancelTitle;
    }
    
    if (cancelColor) {
        datePickerVC.cancelTitleColor = cancelColor;
    }
    
    if (sureTitle) {
        datePickerVC.sureTitle = sureTitle;
    }
    
    if (sureColor) {
        datePickerVC.sureTitleColor = sureColor;
    }
    
    if (dateFormat) {
        datePickerVC.dateFormat = dateFormat;
    }
    
    if (cancelBlock) {
        datePickerVC.cancel = ^{
            cancelBlock();
        };
    }
    
    if (sureBlock) {
        datePickerVC.sure = ^(NSString *dateStr, NSDate *date) {
            sureBlock(dateStr, date);
        };
    }
    
    [self presentViewController:datePickerVC animated:YES completion:nil];
    return datePickerVC;
}

@end

@implementation UIViewController (private)

- (BOOL)isSystemViewController
{
    if ([self isKindOfClass:NSClassFromString(@"UICompatibilityInputViewController")] ||
        [self isKindOfClass:NSClassFromString(@"UIInputWindowController")] ||
        [self isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingControllerNoTouches")] ||
        [self isKindOfClass:NSClassFromString(@"_UIAlertControllerTextFieldViewController")] ||
        [self isKindOfClass:[UIAlertController class]] ||
        [self isKindOfClass:NSClassFromString(@"PUUIAlbumListViewController")] ||
        [self isKindOfClass:[UIImagePickerController class]]) {
        return YES;
    }
    return NO;
}

@end

