//
//  LFPath.h
//
//  Created by 刘丰 on 2017/6/6.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef LFPath_h
#define LFPath_h

#define kHomePath NSHomeDirectory()
#define kDocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject
#define kLibraryPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()
#define kCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

#endif /* LFPath_h */
