//
//  SYDBBaseModel.h
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYDBBaseModel : NSObject

/// 表名，默认类名，可以重写此方法来实现指定表名
- (NSString *)tableName;

@end

NS_ASSUME_NONNULL_END
