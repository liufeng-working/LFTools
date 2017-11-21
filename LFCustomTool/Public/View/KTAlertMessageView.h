//
//  KTAlertMessageView.h
//  KTUAV
//
//  Created by 路恒 on 2017/6/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTFenceSelectOneDelegate <NSObject>

-(void)ktFenceSelectOneWith:(NSIndexPath *_Nullable)indexPath;

@end


@interface KTAlertMessageView : UIView

//设置数据m模型


/****标题信息*(假的模型)***/
@property (nonatomic,copy,nullable)NSString * titleStr;


/****取消按钮****/
@property (nonatomic,strong,nullable)UIButton * cancelBtn;

/*****从locationViewController传递过来的***********/
/****附近电子围栏的数据源****/
@property (nonatomic,copy,nullable)NSArray * overLoapFences;

/****所有电子围栏 类型 he 数量的数组 ****/
@property (nonatomic,strong,nullable)NSMutableDictionary * fenceTypeMDic;

/******代理事件********/
@property (nonatomic,weak,nullable) id<KTFenceSelectOneDelegate> fenceDelegate;

@end
