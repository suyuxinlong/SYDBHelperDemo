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
- (void)initWithSecretKey:(NSString *)secretKey {
}
#pragma mark - 插入
- (void)insert:(SYDBBaseModel *)model {
    [self inserts:@[model]];
}
- (void)inserts:(NSArray *)models {
    [LKDBHelper insertToDBWithArray:models filter:^(id  _Nonnull model, BOOL inserted, BOOL * _Nullable rollback) {
        
    } completed:^(BOOL allInserted) {
        NSLog(@"【DB】insert %@", allInserted?@"success":@"failture");
    }];
}
#pragma mark - 删除
- (void)remove:(SYDBBaseModel *)model {
    [LKDBHelper deleteToDB:model];
}
#pragma mark - 查找

@end
