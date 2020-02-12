//
//  PrinterErrorDetails.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "PrinterResponse.h"

@implementation PrinterResponse

- (id) init:(ErrorCode)errorCode statusInfo:(StatusInfo *)statusInfo message:(NSString *)message {
    self = [super init];
    if(self){
        self.errorCode = errorCode;
        self.statusInfo = statusInfo;
        self.message = message;
    }
    return self;
}

- (id) initWithSettings:(ErrorCode)errorCode statusInfo:(StatusInfo *)statusInfo settings:(PrinterSettings *)settings message:(NSString *)message {
    self = [super init];
    if(self){
        self.errorCode = errorCode;
        self.statusInfo = statusInfo;
        self.settings = settings;
        self.message = message;
    }
    return self;
}

- (NSString *)getErrorCode {
    return [ErrorCodeUtils getNameByValue:self.errorCode];
}

- (NSDictionary *) toMap {
    id objects[] = {
        [ErrorCodeUtils getNameByValue:self.errorCode],
        [self.statusInfo toMap],
        ![ObjectUtils isNull:self.settings] ? [self.settings toMap] : @"",
        self.message
    };
    id keys[] = {
        @"errorCode",
        @"statusInfo",
        @"settings",
        @"message"
    };
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSDictionary *map = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
    return map;
}

@end
