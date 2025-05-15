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

/// 获取数据库的信息
- (NSString *)dbMessage;

#pragma mark - 插入
/// 插入 单条数据 异步
/// - Parameter model: 数据
- (void)insert:(SYDBBaseModel *)model;

/// 插入 多条数据 异步
/// - Parameter models: 多条数据
- (void)inserts:(NSArray *)models;

#pragma mark - 删除
/// 删除 单条数据
/// - Parameter model: 数据
- (BOOL)remove:(SYDBBaseModel *)model;

/// 删除 数据 指定条件
/// - Parameters:
///   - modelClass: 数据类型，也是表名
///   - where: 条件，定义为字典   例如：@{@"userID":12345}    ⚠️注意：不可以为空/nil
- (BOOL)removeModelClass:(Class)modelClass where:(nonnull NSDictionary *)where;

/// 删除数据 根据主键
/// - Parameters:
///   - modelClass: 数据类型，也是表名
///   - primaryKeys: 主键数组
- (BOOL)removeModelClass:(Class)modelClass primaryKeys:(NSArray<NSString *> *)primaryKeys;

#pragma mark - 更新
/// 更新 数据（全字段更新）
/// - Parameter model: 数据
- (BOOL)update:(SYDBBaseModel *)model;

/// 更新 数据（全字段更新）
/// - Parameters:
///   - model: 数据
///   - where: 条件，定义为字典   例如：@{@"userID":12345}    ⚠️注意：可以为nil，当为nil的时候，根据主键去更新
- (BOOL)update:(SYDBBaseModel *)model where:(nullable NSDictionary *)where;

/// 更新数据（部分字段更新）
/// - Parameters:
///   - modelClass: 数据类型，也是表名
///   - sets: 需要更新的内容
///   - where: 条件，定义为字典   例如：@{@"userID":12345}    ⚠️注意：可以为nil，当为nil的时候，根据主键去更新
- (BOOL)update:(Class)modelClass set:(nonnull NSDictionary *)sets where:(nullable NSDictionary *)where;

#pragma mark - 查找
/// 查找所有数据
/// - Parameter modelClass: 类名，也是本地数据库表名
- (NSArray<SYDBBaseModel *> *)query:(Class)modelClass;

/// 查找数据
/// - Parameters:
///   - modelClass: 类名，也是本地数据库表名
///   - where: 条件，定义为字典   例如：@{@"userID":12345}    ⚠️注意：可以为nil，当为nil的时候，根据主键去更新
- (NSArray *)query:(Class)modelClass where:(nullable NSDictionary *)where;

/// 查找数据
/// - Parameters:
///   - modelClass: 类名，也是本地数据库表名
///   - where: 条件，定义为字典   例如：@{@"userID":12345}    ⚠️注意：可以为nil，当为nil的时候，根据主键去更新
///   - limit: 限制语句 例如  @"startTime < '%@' and endTime > '%@'"
- (NSArray *)query:(Class)modelClass where:(nullable NSDictionary *)where limit:(NSString * _Nullable)limit;

/// 查找数据
/// - Parameters:
///   - modelClass: 类名，也是本地数据库表名
///   - where: 条件，定义为字典   例如：@{@"userID":12345}    ⚠️注意：可以为nil，当为nil的时候，根据主键去更新
///   - limit: 限制语句 例如  @"startTime < '%@' and startTime > '%@'"
///   - pageSize: 一页多少数据
///   - pageIndex: 第几页，从1开始
- (NSArray *)query:(Class)modelClass where:(nullable NSDictionary *)where limit:(NSString *)limit pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex;

#pragma mark - 临时存一个参数的读取，采用plist
- (BOOL)sy_saveWithKey:(NSString *)key value:(id)value;
- (id)sy_getValueWithKey:(NSString *)key;
- (BOOL)sy_delete:(NSArray<NSString *> *)keys;
@end

NS_ASSUME_NONNULL_END
