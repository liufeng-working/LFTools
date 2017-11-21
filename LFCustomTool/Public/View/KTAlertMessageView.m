//
//  KTAlertMessageView.m
//  KTUAV
//
//  Created by 路恒 on 2017/6/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "KTAlertMessageView.h"
#import "KTAlertCollectionViewCell.h"
#import "KTFenceModel.h"


#define REUSECELLIDENTIFIER @"reuseCellIdentifier"

static KTAlertMessageView* alertView;

@interface KTAlertMessageView ()<UICollectionViewDelegate,UICollectionViewDataSource>


/****标题视图****/
@property (nonatomic,strong,nullable)UIView * titleView;

/****标题label****/
@property (nonatomic,strong,nullable)UILabel * titleLabel;

/****内容展示父控制器****/
@property (nonatomic,strong,nullable)UIView * contentSubView;
/**** 图标信息集 ****/
@property (nonatomic,strong,nullable)UICollectionView * collectionView;

/****设置提示框的的告诉****/
@property (nonatomic,assign) NSInteger alertContentViewHeight;

/****所有围栏类型个数****/
@property (nonatomic,assign) NSInteger allFencesTypeCount;

@end


@implementation KTAlertMessageView

-(instancetype)init{

    if (!alertView) {
        alertView = [super init];
        self = alertView;
        //添加子视图
        [self setUpChildrenView];
    }
    return alertView;
}
#pragma mark 子视图
-(void)setUpChildrenView{
    
    self.alertContentViewHeight = KTAlertContentViewHeight*2;
    
    self.backgroundColor = kBackColor;
    
    // 2、内容 View
    UIView* contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.mas_equalTo(KTAlertContentViewHeight);
    }];

    // 1、标题View
    UIView* titleView = [[UIView alloc]init];
    [self addSubview:titleView];
    titleView.backgroundColor = [UIColor whiteColor];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.bottom.mas_equalTo(contentView.mas_top).with.offset(-0.5);
        make.height.mas_equalTo(KTAlertTitleViewHeight);
    }];
    
    //3、取消按钮
    UIButton * cancelBtn = [[UIButton alloc]init];
    
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [titleView addSubview:cancelBtn];
    
    //添加事件
    [cancelBtn addTarget:self action:@selector(disappearCurrentView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView.mas_right).with.offset(-7);
        make.centerY.equalTo(titleView.mas_centerY);
        make.width.mas_equalTo(KTAlertTitleViewHeight);
    }];
    /*
//    //3、确认按钮
//    UIButton * surenBtn = [[UIButton alloc]init];
//    [surenBtn setBackgroundColor:[UIColor grayColor]];
//    surenBtn.layer.cornerRadius = 5;
//    surenBtn.layer.masksToBounds = YES;
//    [surenBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [surenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    [contentView addSubview:surenBtn];
//    [surenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(contentView.mas_centerX);
//        make.bottom.equalTo(contentView.mas_bottom).with.offset(-1);
//        make.width.mas_offset(@90);
//    }];
    */
//    //1.1标题label
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"预警提示:";
    titleLabel.font = [UIFont systemFontOfSize:13];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).with.offset(5);
        make.centerY.equalTo(titleView.mas_centerY);
//        make.right.equalTo(titleView.mas_right).with.offset(-5);
    }];
    //1.2 标题subLabel
    UILabel* subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.text = @"您的飞行半径存在电子围栏,请谨慎飞行!";
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    subTitleLabel.textColor = hexColor(@"ff5a00");
    
    [titleView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    
    //设置属性
    self.cancelBtn = cancelBtn;
    self.titleView = titleView;
    self.titleLabel = titleLabel;
    self.contentSubView = contentView;
    
    //设置collectionView
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
}
//视图消失
-(void)disappearCurrentView{
    self.alpha = 0;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //设置layout
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((KTScreenWidth-2)/3.0f, portraitValue(135));
        flowLayout.minimumLineSpacing = 0.001;
        flowLayout.minimumInteritemSpacing = 0.001;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        //添加一个collectionView
        UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, verticalMargin, KTScreenWidth, KTAlertContentViewHeight) collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.contentSubView addSubview:collectionView];
        
        //注册展示的cell
        [collectionView registerClass:[KTAlertCollectionViewCell class] forCellWithReuseIdentifier:REUSECELLIDENTIFIER];
        
        _collectionView = collectionView;
        return _collectionView;
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.allFencesTypeCount;
}

#pragma mark 获取自定义UICollectionViewCell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KTAlertCollectionViewCell *alertFenceCell = [collectionView dequeueReusableCellWithReuseIdentifier:REUSECELLIDENTIFIER forIndexPath:indexPath];
// 设置数据源 、、、、
    //设置数据源
    //获取所有的key
    NSArray* fenceAllKeyArr = self.fenceTypeMDic.allKeys;
    NSArray* fenceAllValueArr = self.fenceTypeMDic.allValues;
    NSDictionary* tmpDic = @{fenceAllKeyArr[indexPath.row]:
                                 fenceAllValueArr[indexPath.row]};
    alertFenceCell.fenceTypeAndNumberDic = tmpDic;
    
    return alertFenceCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //代理事件，传递 - 界面跳转
    [self.fenceDelegate ktFenceSelectOneWith:indexPath];
}

#pragma mark 处理 统计 电子围栏 数据源 ！！！！
-(void)setOverLoapFences:(NSArray *)overLoapFences{

    //数组个数为 0 不显示
    
    self.fenceTypeMDic = [NSMutableDictionary dictionary];
    //获取所有围栏
    for (KTFenceModel* fenceModel in overLoapFences) {
        //先取出某围栏类型的数量
        NSString* tmpStr = [self.fenceTypeMDic valueForKey:fenceModel.fenceTypeStr];
        [self.fenceTypeMDic setValue:[NSString stringWithFormat:@"%d",[tmpStr intValue]+1] forKey:fenceModel.fenceTypeStr];
    }
    self.allFencesTypeCount = self.fenceTypeMDic.allKeys.count;
    
// 目前没有做大于6个的判断
    //行数
    int lineNumber = self.allFencesTypeCount / 4 == 0 ? 1 : 2;
//    int lineNumber = overLoapFences.count % 3 == 0 ? 1:overLoapFences.count % 3;
    //计算提示框的高度
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KTAlertTitleViewHeight+KTAlertContentViewHeight*lineNumber+0.5+verticalMargin*2);
    }];
    
    [self.contentSubView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KTAlertContentViewHeight*lineNumber+verticalMargin*2);
    }];
    
    //collectionview的高度
    self.collectionView.frame = CGRectMake(0, verticalMargin, KTScreenWidth, KTAlertContentViewHeight*lineNumber);
    
    //collectionview 刷新
    [self.collectionView reloadData];

}
#pragma mark 设置数据源

@end
