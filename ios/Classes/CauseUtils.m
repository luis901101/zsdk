//
//  CauseUtil.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "CauseUtils.h"

@implementation CauseUtils 

+ (NSString *)getNameByValue:(Cause)value {
    switch (value) {
        case PARTIAL_FORMAT_IN_PROGRESS: return @"PARTIAL_FORMAT_IN_PROGRESS";
        case HEAD_COLD: return @"HEAD_COLD";
        case HEAD_OPEN: return @"HEAD_OPEN";
        case HEAD_TOOHOT: return @"HEAD_TOOHOT";
        case PAPER_OUT: return @"PAPER_OUT";
        case RIBBON_OUT: return @"RIBBON_OUT";
        case RECEIVE_BUFFER_FULL: return @"RECEIVE_BUFFER_FULL";
        case NO_CONNECTION: return @"NO_CONNECTION";
        case UNKNOWN_CAUSE:
        default: return @"UNKNOWN";
    }
    return @"UNKNOWN";
}

+ (Cause)getValueByName:(NSString *)name {
    if([name  isEqual: @"PARTIAL_FORMAT_IN_PROGRESS"]) return PARTIAL_FORMAT_IN_PROGRESS;
    if([name  isEqual: @"HEAD_COLD"]) return HEAD_COLD;
    if([name  isEqual: @"HEAD_OPEN"]) return HEAD_OPEN;
    if([name  isEqual: @"HEAD_TOOHOT"]) return HEAD_TOOHOT;
    if([name  isEqual: @"PAPER_OUT"]) return PAPER_OUT;
    if([name  isEqual: @"RIBBON_OUT"]) return RIBBON_OUT;
    if([name  isEqual: @"RECEIVE_BUFFER_FULL"]) return RECEIVE_BUFFER_FULL;
    if([name  isEqual: @"NO_CONNECTION"]) return NO_CONNECTION;
    if([name  isEqual: @"UNKNOWN"]) return UNKNOWN_CAUSE;
    return UNKNOWN_CAUSE;
}

@end
