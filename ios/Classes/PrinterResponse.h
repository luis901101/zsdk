//
//  PrinterErrorDetails.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "ErrorCodeUtils.h"
#import "StatusInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterResponse : NSObject
@property ErrorCode errorCode;
@property StatusInfo *statusInfo;
@property NSString *message;
- (id) init:(ErrorCode)errorCode statusInfo:(StatusInfo *)statusInfo message:(NSString *)message;
- (NSString *) getErrorCode;
- (NSDictionary *) toMap;
@end

NS_ASSUME_NONNULL_END
