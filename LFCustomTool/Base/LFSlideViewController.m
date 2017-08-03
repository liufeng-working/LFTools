//
//  LFSlideViewController.m
//  test
//
//  Created by 刘丰 on 2016/12/28.
//  Copyright © 2016年 liufeng. All rights reserved.
//

#import "LFSlideViewController.h"

/****************************************/
/*如果已经有了view的分类 下面的私有分类可以删除*/
@interface UIView (LFCategory)

/** x坐标 */
@property (nonatomic, assign) CGFloat left;

/** 高度 */
@property (nonatomic, assign) CGFloat height;

@end

@implementation UIView (LFCategory)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

@end
/*如果已经有了view的分类 上面的私有分类可以删除*/
/****************************************/

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kMainWidth (kScreenWidth * 0.3) //主视图显示宽度
#define kLeftWidth (kScreenWidth - kMainWidth) //左视图显示宽度
#define kMainAlpha 0.4 //主视图遮罩层最大透明度
#define kMoving_ratio (self.moving_distance / kLeftWidth) //已经移动的比例
#define kLeftX 100 //左视图起始X坐标的绝对值（起始应该为负值）
#define kAnimationDuration 0.2 //动画总时间
@interface LFSlideViewController ()<UINavigationControllerDelegate>

/** 移动距离 */
@property(nonatomic,assign) CGFloat moving_distance;

/** 用来辅助判断是左滑还是右滑（大于0：右滑  小于0：左滑） */
@property(nonatomic,assign) CGFloat left_or_right;

/** 主视图遮罩层 */
@property(nonatomic,weak) UIView *mainShadow;

/** 左控制器的view */
@property(nonatomic,weak) UIView *leftView;

/** 主控制器的view */
@property(nonatomic,weak) UIView *mainView;

/** 拖动手势 */
@property(nonatomic,weak) UIPanGestureRecognizer *panGesture;

/** 单击手势 */
@property(nonatomic,weak) UITapGestureRecognizer *tapGesture;

/** 根控制器 */
@property(nonatomic,weak) UIViewController *rootVC;

/** 记录拖动时间 */
@property(nonatomic,assign) NSTimeInterval begin;
@property(nonatomic,assign) NSTimeInterval end;

@end

@implementation LFSlideViewController

#pragma mark -
#pragma mark - 懒加载
- (UIView *)mainShadow
{
    if (!_mainShadow) {
        UIView *main = [[UIView alloc] initWithFrame:self.mainView.bounds];
        main.backgroundColor = [UIColor blackColor];
        main.alpha = 0;
        [self.mainView addSubview:main];
        _mainShadow = main;
    }
    return _mainShadow;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture) {
        //拖动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.view addGestureRecognizer:pan];
        _panGesture = pan;
    }
    return _panGesture;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        //单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handeTap:)];
        [self.mainShadow addGestureRecognizer:tap];
        _tapGesture = tap;
    }
    return _tapGesture;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    NSAssert(NO, @"请使用\"initWithLeftViewController:\"mainViewController:初始化LFSlideViewController");
    return nil;
}

#pragma mark -
#pragma mark - 初始化
- (instancetype)initWithLeftViewController:(UIViewController *)leftVC
                        mainViewController:(UITabBarController *)mainVC
{
    NSAssert(![leftVC isKindOfClass:[UITabBarController class]], @"左视图不能为UITabBarController");
    NSAssert(![leftVC isKindOfClass:[UINavigationController class]], @"左视图不能为UINavigationController");
    
    UIViewController *rootVC = [[LFBaseViewController alloc] init];
    rootVC.edgesForExtendedLayout = UIRectEdgeNone;//解决偏移问题
    
    //这句不能放在大括号里赋值
    //因为[super initWithRootViewController:rootVC]方法执行后
    //就会执行重写的push方法
    //判断if (viewController == self.rootVC)时，self.rootVC为空
    //导致不能正常调用父类的push
    //放在这里赋值，能实现效果，但是不知道有没有隐藏的问题
    _rootVC = rootVC;
    
    self = [super initWithRootViewController:rootVC];
    if(self) {
        _leftVC = leftVC;
        _mainVC = mainVC;
        _leftView = leftVC.view;
        _mainView = mainVC.view;
        [rootVC.view addSubview:_leftView];
        [rootVC.view addSubview:_mainView];
        [rootVC addChildViewController:leftVC];
        [rootVC addChildViewController:mainVC];
        
        //修改左视图尺寸
        _leftView.frame = CGRectMake(-kLeftX, 0, kLeftWidth, _leftView.height);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //滑动手势可用
    self.panGesture.enabled = YES;
    //隐藏自己导航条
    self.navigationBarHidden = YES;
    //设置代理为自己
    self.delegate = self;
}

#pragma mark -
#pragma mark - 打开左视图
- (void)open;
{
    [self settingDuration:kAnimationDuration * (1 - kMoving_ratio)
                left_left:0
               right_left:kLeftWidth
                    alpha:kMainAlpha
                   moving:kLeftWidth
                tapEnable:YES];
}

#pragma mark -
#pragma mark - 关闭左视图
- (void)close
{
    [self settingDuration:kAnimationDuration * kMoving_ratio
                left_left:-kLeftX
               right_left:0
                    alpha:0
                   moving:0
                tapEnable:NO];
}

#pragma mark -
#pragma mark - 设置拖动手势是否可用
- (void)panGestureRecognizerEnable:(BOOL)enable
{
    [self.panGesture setEnabled:enable];
}

#pragma mark -
#pragma mark - 拖动手势
- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    NSLog(@"%ld", (long)pan.state);
    //记录开始拖动的事件
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.begin = CACurrentMediaTime();
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint point = [pan translationInView:self.view];
        self.moving_distance += point.x;
        self.left_or_right += point.x;
        
        if (self.moving_distance < 0) {//移动距离小于0时
            self.moving_distance = 0;
            self.left_or_right = 0;
            return;
        }else if (self.moving_distance > kLeftWidth) {//移动距离大于最大值时
            self.moving_distance = kLeftWidth;
            self.left_or_right = 0;
            return;
        }else {//移动距离变化时，左视图跟着动态变化
            
            [self settingLeft_left:kLeftX * (kMoving_ratio - 1)
                        right_left:self.moving_distance
                             alpha:kMainAlpha * kMoving_ratio];
            [pan setTranslation:CGPointZero inView:self.view];
        }
    }
    
    //手势结束后,根据移动距离做相应的操作
    if (pan.state == UIGestureRecognizerStateEnded) {
        //记录拖动结束的时间
        self.end = CACurrentMediaTime();
        
        //时间间隔
        NSTimeInterval duration = self.end - self.begin;
        if (duration < 0.3) {//小于0.3s，则认为是轻扫
            if (self.left_or_right > 0) {
                [self open];
            }else {
                [self close];
            }
        }else {
            if (self.moving_distance > kScreenWidth * 0.5) {
                [self open];
            }else {
                [self close];
            }
        }
    }
}

#pragma mark -
#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self close];
    }
}

#pragma mark -
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.panGesture.enabled = (viewController == navigationController.viewControllers.firstObject);
}

#pragma mark -
#pragma mark - 重写push pop方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //0 根视图控制器
    //1 第一次手动push时的控制器
    if (viewController == self.rootVC) {
        [super pushViewController:viewController animated:animated];
    }else {
        NSAssert([viewController isKindOfClass:[LFBackViewController class]], @"从侧边栏弹出的第一层视图控制器应该是LFBackViewController或其子类");
        //因为导航控制器不能push导航控制器
        //但是又想实现第一层没有导航条，后来的都有导航条
        //所以用UITabBarController包装了一个导航控制器
        //把UITabBarController的UITabbar隐藏
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        UITabBarController *tabbar = [[UITabBarController alloc] init];
        tabbar.tabBar.hidden = YES;
        tabbar.viewControllers = @[nav];
        [super pushViewController:tabbar animated:animated];
    }
}

/**
 设置各个属性
 */
- (void)settingLeft_left:(CGFloat)left_left right_left:(CGFloat)right_left alpha:(CGFloat)alpha
{
    self.leftView.left = left_left;
    self.mainView.left = right_left;
    self.mainShadow.alpha = alpha;
    [self.mainView bringSubviewToFront:self.mainShadow];
}

- (void)settingDuration:(CGFloat)duration left_left:(CGFloat)left_left right_left:(CGFloat)right_left alpha:(CGFloat)alpha moving:(CGFloat)moving tapEnable:(BOOL)tapEnable
{
    [UIView animateWithDuration:duration animations:^{
        [self settingLeft_left:left_left right_left:right_left alpha:alpha];
    }];
    
    self.moving_distance = moving;
    self.tapGesture.enabled = tapEnable;
    self.begin = 0;
    self.end = 0;
    self.left_or_right = 0;
}

@end

@implementation LFBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //解决偏移问题
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加这个的目的，怎么解释呢。。
    //嗯..是为了假装这个页面是push出来的
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 54, 44);
    [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:swipeGesture];
    
    //自定义导航控制器返回按钮
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBtn;
}

#pragma mark -
#pragma mark - 返回
- (void)back
{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - 处理轻扫手势
- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    [self back];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end

