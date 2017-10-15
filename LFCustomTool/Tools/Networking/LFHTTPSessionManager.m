//
//  LFHTTPSessionManager.m
//  KTUAV
//
//  Created by 刘丰 on 2017/5/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFHTTPSessionManager.h"

static LFHTTPSessionManager *_manager = nil;
@implementation LFHTTPSessionManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] initWithBaseURL:nil];
    });
    return _manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url
{

    self = [super initWithBaseURL:url];
    if (self) {
        self.securityPolicy.allowInvalidCertificates = YES;
        
        //https相关
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        
        //请求相关
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = 10;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        //结果相关
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    }
    return self;
}

@end
