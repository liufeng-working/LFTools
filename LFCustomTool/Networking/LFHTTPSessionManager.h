//
//  LFHTTPSessionManager.h
//  KTUAV
//
//  Created by 刘丰 on 2017/5/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import <AFNetworking.h>

@interface LFHTTPSessionManager : AFHTTPSessionManager

//单列
+ (instancetype)shareManager;

@end
