//
//  LFNetWorking.m
//  KTUAV
//
//  Created by 刘丰 on 2017/5/23.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#import "LFNetWorking.h"
#import "LFHTTPSessionManager.h"

@interface LFNetWorking ()

@end

@implementation LFNetWorking

/**
 *  POST请求获取数据
 *
 *  @param parameters 参数列表
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)POSTWithParameters:(NSDictionary *)parameters
                   success:(void (^)(id result))success
                   failure:(void (^)(NSError *error))failure
{
    /*
     {
     body =     {
     password = 123456;
     userName = yczxxs1;
     };
     header =     {
     deviceMac = "02:00:00:00:00:00";
     deviceOS = "iOS10.2.1";
     deviceType = iPhone;
     methodName = appLogin;
     remark = "";
     remark1 = "";
     remark2 = "";
     retCode = "-1";
     retMsg = "\U7528\U6237\U540d\U6216\U5bc6\U7801\U4e0d\U6b63\U786e!";
     version = "";
     };
     }
     */
    
    [KTHTTPSessionManager.shareManager POST:kBaseUrl parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *header = object[@"header"];
        NSInteger code = [header[@"retCode"] integerValue];
//        NSString *tokenId = header[@"tokenId"];
        
        id result;
        if (code != 0) {//展示错误
            [LFNotification autoHideWithText:header[@"retMsg"]];
            result = nil;
        }else {
            result = object[@"body"];
            
//            if (tokenId) {
//                [KTAccount account].tokenId = tokenId;
//            }
        }
        
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }else {
            [LFNotification autoHideWithText:@"服务器异常，请稍后再试"];
        }
    }];
}

/**
 *  POST请求上传图片
 *
 *  @param parameters 参数列表
 *  @param images     上传的图片
 *  @param success    成功回调
 *  @param failure    失败回调
 */
+ (void)uploadWithParameters:(NSDictionary *)parameters
                      images:(NSArray<UIImage *> *)images
                     success:(void (^)(id result))success
                     failure:(void (^)(NSError *error))failure
{
    [KTHTTPSessionManager.shareManager POST:kBaseUrlUpload parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *param = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        [formData appendPartWithFormData:param name:@"jsonStr"];
        
        //根据当前系统时间生成图片名称（如果用户修改了系统时间，就可能会出现相同的名字）
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
        NSString *dateString = [formatter stringFromDate:date];
        
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@_%ld.jpg", dateString, (unsigned long)idx];
            NSData *imgData = UIImageJPEGRepresentation(obj, 0.7);
            [formData appendPartWithFileData:imgData
                                        name:@"fileUpload"
                                    fileName:fileName
                                    mimeType:@"image/jpg"];
        }];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *header = object[@"header"];
        NSInteger code = [header[@"retCode"] integerValue];
        
        id result;
        if (code != 0) {
            [LFNotification autoHideWithText:header[@"retMsg"]];
            result = nil;
        }else {
            result = object[@"body"];
        }
        
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }else {
            [LFNotification autoHideWithText:@"服务器异常，请稍后再试"];
        }
    }];
}

@end
