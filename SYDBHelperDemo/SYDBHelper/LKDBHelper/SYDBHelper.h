//
//  SYDBHelper.h
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import <Foundation/Foundation.h>
#import "SYDBBaseModel.h"
#import <LKDBHelper/LKDBHelper.h>

NS_ASSUME_NONNULL_BEGIN

#define kDBHelper [SYDBHelper sharedInstance]

/// 数据库的操作，异步处理
@interface SYDBHelper : NSObject

/// 数据库加解密的密钥
@property (nonatomic, copy, readonly) NSString *secretKey;

/// 单利初始化
+ (instancetype)sharedInstance;

/// 初始化数据库加解密的密钥
/// - Parameter secretKey: 密钥
- (void)initWithSecretKey:(NSString *)secretKey;

#pragma mark - 插入
/// 插入单条数据 异步
/// - Parameter model: 数据
- (void)insert:(SYDBBaseModel *)model;
/// 插入多条数据 异步
/// - Parameter models: 多条数据
- (void)inserts:(NSArray *)models;

#pragma mark - 删除
- (void)remove:(SYDBBaseModel *)model;
- (BOOL)removeModelId:(NSString *)modelId;
- (void)removes:(NSArray *)models;
- (BOOL)removeModels:(Class)modelClass;

#pragma mark - 更新
- (BOOL)update:(SYDBBaseModel *)model;
- (BOOL)update:(Class)modelClass where:(NSString *)where message:(NSString *)message;
#pragma mark - 查找
/// 查找所有数据
/// - Parameter modelClass: 类名，也是本地数据库表名
- (NSArray<SYDBBaseModel *> *)query:(Class)modelClass;
/// 查找数据
/// - Parameters:
///   - modelClass: 类名，也是本地数据库表名
///   - where: 查找语句 例如： @"userName = '%@'" 或者 @"userName = '%@' and age = '18'"
- (NSArray<SYDBBaseModel *> *)query:(Class)modelClass where:(NSString *)where;
/// 查找数据
/// - Parameters:
///   - modelClass: 类名，也是本地数据库表名
///   - where: 查找语句 例如： @"userName = '%@'"
///   - limit: 限制语句 例如  @"startTime < '%@' and endTime > '%@'"
- (NSArray<SYDBBaseModel *> *)query:(Class)modelClass where:(NSString *)where limit:(NSString * _Nullable)limit;
/// 查找数据
/// - Parameters:
///   - modelClass: 类名，也是本地数据库表名
///   - where: 查找语句 例如： @"userName = '%@'"
///   - limit: 限制语句 例如  @"startTime < '%@' and endTime > '%@'"
///   - pageSize: 页码
///   - pageIndex: 页码
- (NSArray<SYDBBaseModel *> *)query:(Class)modelClass where:(NSString *)where limit:(NSString *)limit pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 临时存一个参数的读取
- (BOOL)sy_saveWithKey:(NSString *)key value:(id)value;
- (id)sy_getValueWithKey:(NSString *)key;
- (BOOL)sy_delete:(NSArray<NSString *> *)keys;
@end

NS_ASSUME_NONNULL_END
