//
//  CauseUtil.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import <Orientation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrientationUtils : NSObject

+ (Orientation) getValueByName: (NSString *) name;
+ (NSString *) getNameByValue: (Orientation) value;

@end

NS_ASSUME_NONNULL_END
