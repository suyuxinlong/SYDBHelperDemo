//
//  SYDBModel.m
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import "SYDBModel.h"
#import <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>
#import <LKDBHelper/NSObject+LKModel.h>

@interface SYDBModel ()

@property (nonatomic, copy) NSString *tableNameMD5String;

@end
@implementation SYDBModel

- (instancetype)init {
    if (self == [super init]) {
        self.tableNameMD5String = [self MD5String];
    }
    return self;
}

+ (NSString *)getTableName {
    // 默认表名就是类名，不想要的话，可以在自己需要存储model数据的.m文件中重写这个方法
    return NSStringFromClass(self.class);
}
+ (NSInteger)version {
    return 1;
}
#pragma mark - -----------------------------------------------------------------------------------------------
// 获取所有的key，加密成MD5，当MD5发生变化，也就是数据库需要更新，数据库版本自动+1，自动更新
- (NSString *)MD5String {
    NSArray *properties = [self getAllPropertiesOfClass:self.class];
    NSString *propertiesString = [properties componentsJoinedByString:@"/"];
    return [self md5WithString:propertiesString];
}
// 递归获取类及其父类的所有属性
- (NSArray<NSString *> *)getAllPropertiesOfClass:(Class)cls {
    NSMutableArray *properties = [NSMutableArray array];
    while (cls != [NSObject class]) {
        unsigned int count;
        objc_property_t *props = class_copyPropertyList(cls, &count);
        for (unsigned int i = 0; i < count; i++) {
            const char *name = property_getName(props[i]);
            [properties addObject:[NSString stringWithUTF8String:name]];
        }
        free(props);
        cls = class_getSuperclass(cls);
    }
    return [properties copy];
}
- (NSString *)md5WithString:(NSString *)string {
    const char *str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
@end
