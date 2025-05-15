//
//  SYDBHelper.h
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import <Foundation/Foundation.h>
#import <LKDBHelper/LKDBHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYDBHelper : NSObject

/// 单利初始化
+ (instancetype)sharedInstance;

#pragma mark - 插入
- (BOOL)insert:(id)model;
- (BOOL)inserts:(NSArray *)models;
- (BOOL)insert:(id)model withModelId:(NSString *)modelId;

#pragma mark - 删除
- (BOOL)remove:(id)model;
- (BOOL)removeModelId:(NSString *)modelId;
- (BOOL)removes:(NSArray *)models;
- (BOOL)removeModels:(Class)modelClass;

@end

NS_ASSUME_NONNULL_END
