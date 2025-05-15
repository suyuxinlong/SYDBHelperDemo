//
//  Model1.h
//  SYDBHelperDemo
//
//  Created by 苏余昕龙 on 2025/5/15.
//

#import "SYDBBaseModel.h"
#import "Model2.h"

NS_ASSUME_NONNULL_BEGIN

@interface Model1 : SYDBBaseModel

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *abc;
@property (nonatomic, strong) Model2 *model2;

@end

NS_ASSUME_NONNULL_END
