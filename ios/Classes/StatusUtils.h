//
//  CauseUtil.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import <Status.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatusUtils : NSObject

+ (Status) getValueByName: (NSString *)name;
+ (NSString *) getNameByValue: (Status)value;

@end

NS_ASSUME_NONNULL_END
