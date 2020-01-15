//
//  CauseUtil.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "ErrorCodeUtils.h"

@implementation ErrorCodeUtils

+ (NSString *)getNameByValue:(ErrorCode)value {
    switch (value) {
        case SUCCESS: return @"SUCCESS";
        case EXCEPTION: return @"EXCEPTION";
        case PRINTER_ERROR: return @"PRINTER_ERROR";
        case UNKNOWN_ERROR:
        default: return @"UNKNOWN";
    }
    return @"UNKNOWN";
}

+ (ErrorCode)getValueByName:(NSString *)name {
    if([name  isEqual: @"SUCCESS"]) return SUCCESS;
    if([name  isEqual: @"EXCEPTION"]) return EXCEPTION;
    if([name  isEqual: @"PRINTER_ERROR"]) return PRINTER_ERROR;
    if([name  isEqual: @"UNKNOWN"]) return UNKNOWN_ERROR;
    return UNKNOWN_ERROR;
}

@end
