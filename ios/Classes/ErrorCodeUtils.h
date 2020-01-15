//
//  CauseUtil.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import <ErrorCode.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorCodeUtils : NSObject

+ (ErrorCode) getValueByName: (NSString *) name;
+ (NSString *) getNameByValue: (ErrorCode) value;

@end

NS_ASSUME_NONNULL_END
