//
//  StatusInfo.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "Status.h"
#import "Cause.h"

NS_ASSUME_NONNULL_BEGIN

@interface StatusInfo : NSObject
@property Status status;
@property Cause cause;
- (id) init:(Status)status cause:(Cause)cause;
- (NSDictionary *) toMap;
@end

NS_ASSUME_NONNULL_END
