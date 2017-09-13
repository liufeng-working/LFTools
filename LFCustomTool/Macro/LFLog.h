//
//  LFLog.h
//
//  Created by 刘丰 on 2017/5/26.
//  Copyright © 2017年 liufeng. All rights reserved.
//

#ifndef LFLog_h
#define LFLog_h

#if DEBUG
#define NSLog(format, ...) do {                                             \
NSString *lf_dateString = ({ \
NSDateFormatter *lf_formatter = [[NSDateFormatter alloc] init]; \
lf_formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS"; \
[lf_formatter stringFromDate:[NSDate date]]; \
}); \
fprintf(stderr, "%s %s", [lf_dateString UTF8String], [[NSBundle mainBundle].infoDictionary[@"CFBundleName"] UTF8String]);\
fprintf(stderr, " <%s: %d>\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__);                                                        \
if (format.length) { \
fprintf(stderr, "%s\n", [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]); \
} \
fprintf(stderr, "-----------------------------------------\n"); \
} while (0)

#define kPrintFunction() do {                                             \
NSString *lf_dateString = ({ \
NSDateFormatter *lf_formatter = [[NSDateFormatter alloc] init]; \
lf_formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS"; \
[lf_formatter stringFromDate:[NSDate date]]; \
}); \
fprintf(stderr, "%s %s", [lf_dateString UTF8String], [[NSBundle mainBundle].infoDictionary[@"CFBundleName"] UTF8String]); \
fprintf(stderr, " <%s: %d>\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__);                                                        \
fprintf(stderr, "%s\n", __func__);                                                        \
fprintf(stderr, "-----------------------------------------\n"); \
} while (0);
#else
#define NSLog(format, ...)
#define kPrintFunction()
#endif

#endif /* LFLog_h */
