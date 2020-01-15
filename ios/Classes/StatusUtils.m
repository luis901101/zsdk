//
//  CauseUtil.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "StatusUtils.h"

@implementation StatusUtils

+ (NSString *)getNameByValue:(Status)value {
    switch (value) {
        case PAUSED: return @"PAUSED";
        case READY_TO_PRINT: return @"READY_TO_PRINT";
        case UNKNOWN_STATUS:
        default: return @"UNKNOWN";
    }
    return @"UNKNOWN";
}

+ (Status)getValueByName:(NSString *)name {
    if([name  isEqual: @"PAUSED"]) return PAUSED;
    if([name  isEqual: @"READY_TO_PRINT"]) return READY_TO_PRINT;
    if([name  isEqual: @"UNKNOWN"]) return UNKNOWN_STATUS;
    return UNKNOWN_STATUS;
}

@end
