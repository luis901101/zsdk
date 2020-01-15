//
//  CauseUtil.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import <Cause.h>

NS_ASSUME_NONNULL_BEGIN

@interface CauseUtils : NSObject

+ (Cause) getValueByName: (NSString *) name;
+ (NSString *) getNameByValue: (Cause) value;

@end

NS_ASSUME_NONNULL_END
