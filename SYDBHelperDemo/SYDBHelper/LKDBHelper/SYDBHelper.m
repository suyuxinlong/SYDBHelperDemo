//
//  SYDBHelper.m
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import "SYDBHelper.h"

@implementation SYDBHelper

static SYDBHelper *_sharedInstance;
+ (instancetype)sharedInstance {
    return [self allocWithZone:NULL];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[super allocWithZone:zone] init];
        }
    });
    return _sharedInstance;
}

#pragma mark - 插入
- (BOOL)insert:(SYDBBaseModel *)model {
    if (model == nil) return NO;
    return [LKDBHelper insertToDB:model];
}
@end
