//
//  PrinterErrorDetails.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "ErrorCodeUtils.h"
#import "StatusInfo.h"
#import "PrinterSettings.h"
#import "ObjectUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterResponse : NSObject
@property ErrorCode errorCode;
@property StatusInfo *statusInfo;
@property PrinterSettings *settings;
@property NSString *message;
- (id) init:(ErrorCode)errorCode statusInfo:(StatusInfo *)statusInfo message:(NSString *)message;
- (id) initWithSettings:(ErrorCode)errorCode statusInfo:(StatusInfo *)statusInfo settings:(PrinterSettings *)settings message:(NSString *)message;
- (NSString *) getErrorCode;
- (NSDictionary *) toMap;
@end

NS_ASSUME_NONNULL_END
