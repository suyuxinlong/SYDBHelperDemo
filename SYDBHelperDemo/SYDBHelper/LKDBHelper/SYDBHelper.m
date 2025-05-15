//
//  SYDBHelper.m
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import "SYDBHelper.h"

@interface SYDBHelper ()

@property (nonatomic, strong) LKDBHelper *dbHelper;

@end
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
            _sharedInstance.dbHelper = [[LKDBHelper getUsingLKDBHelper] initWithDBName:[NSString stringWithFormat:@"%@.db", [[NSBundle mainBundle] bundleIdentifier]]];
        }
    });
    return _sharedInstance;
}
- (void)initWithSecretKey:(NSString *)secretKey {
    [self.dbHelper setKey:secretKey];
}
- (NSString *)dbMessage {
    NSMutableString *message = [[NSMutableString alloc] init];
    [message appendString:@"\n**********************************"];
    [message appendString:@"\n本地数据库信息"];
    [message appendString:[NSString stringWithFormat:@"\n数据库地址：%@", [self dbPath]]];
    [message appendString:[NSString stringWithFormat:@"\n数据库版本：%ld", (long)[self dbVersion]]];
    [message appendString:[NSString stringWithFormat:@"\n所有表名：%@", [self tableNames]]];
    [message appendString:@"\n**********************************"];
    return message;
}
- (NSString *)dbPath {
    return [LKDBUtils getPathForDocuments:[NSString stringWithFormat:@"%@.db", [[NSBundle mainBundle] bundleIdentifier]] inDir:@"db"];
}
- (NSInteger)dbVersion {
    __block NSInteger version = 0;
    [self.dbHelper executeDB:^(FMDatabase * _Nonnull db) {
        FMResultSet *rs = [db executeQuery:@"PRAGMA user_version"];
        if ([rs next]) {
            version = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return version;
}
- (NSArray<NSString *> *)tableNames {
    __block NSMutableArray *tableNames = [NSMutableArray array];
    [self.dbHelper executeDB:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name != 'sqlite_sequence';"];
        while ([resultSet next]) {
            NSString *tableName = [resultSet stringForColumnIndex:0];
            [tableNames addObject:tableName];
        }
        [resultSet close];
    }];
    return tableNames;
}
#pragma mark - 插入
- (void)insert:(SYDBBaseModel *)model {
    [self inserts:@[model]];
}
- (void)inserts:(NSArray *)models {
    [LKDBHelper insertToDBWithArray:models filter:^(id  _Nonnull model, BOOL inserted, BOOL * _Nullable rollback) {
        if (inserted) {
            NSLog(@"【DB】%@已经存在", model);
        }
    } completed:^(BOOL allInserted) {
        NSLog(@"【DB】插入 %@", allInserted?@"success":@"failture");
    }];
}
#pragma mark - 删除
- (BOOL)remove:(SYDBBaseModel *)model {
    return [self removeModelClass:model.class primaryKeys:@[model.class.getPrimaryKey]];
}

- (BOOL)removeModelClass:(Class)modelClass where:(nonnull NSDictionary *)where {
    if ([where allKeys].count == 0 || where == nil) return NO;
    return [self.dbHelper deleteWithClass:modelClass where:where];
}

- (BOOL)removeModelClass:(Class)modelClass primaryKeys:(NSArray<NSString *> *)primaryKeys {
    NSString *placeholders = [self generatePlaceholdersForCount:primaryKeys.count];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ IN (%@)", NSStringFromClass(modelClass), modelClass.getPrimaryKey, placeholders];
    return [self.dbHelper executeSQL:sql arguments:primaryKeys];
}

#pragma mark - 更新
- (BOOL)update:(SYDBBaseModel *)model {
    return [model updateToDB];
}

- (BOOL)update:(SYDBBaseModel *)model where:(NSDictionary *)where {
    return [self.dbHelper updateToDB:model where:where];
}

- (BOOL)update:(Class)modelClass set:(NSDictionary *)sets where:(NSString *)where {
    NSString *setsString = [sets description];
    return [self.dbHelper updateToDB:modelClass set:setsString where:where];
    
}
#pragma mark - 查找
- (NSArray<SYDBBaseModel *> *)query:(Class)modelClass {
    return [modelClass searchWithWhere:nil];
}

- (NSArray *)query:(Class)modelClass where:(NSDictionary *)where {
    return [modelClass searchWithWhere:where];
}

- (NSArray *)query:(Class)modelClass where:(NSDictionary *)where limit:(NSString *)limit {
    return [self query:modelClass where:where limit:limit pageSize:0 pageIndex:0];
}

- (NSArray *)query:(Class)modelClass where:(NSDictionary *)where limit:(NSString *)limit pageSize:(NSInteger)pageSize pageIndex:(NSInteger)pageIndex {
    return [modelClass searchWithWhere:where orderBy:limit offset:MAX(0, pageIndex - 1) count:pageSize];
}
#pragma mark - func
// 生成占位符工具方法
- (NSString *)generatePlaceholdersForCount:(NSInteger)count {
    NSMutableArray *placeholders = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        [placeholders addObject:@"?"];
    }
    return [placeholders componentsJoinedByString:@","];
}

@end
