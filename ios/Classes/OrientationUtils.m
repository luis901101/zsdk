//
//  CauseUtil.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "OrientationUtils.h"

@implementation OrientationUtils

+ (NSString *)getNameByValue:(Orientation)value {
    switch (value) {
        case PORTRAIT: return @"PORTRAIT";
        case LANDSCAPE: return @"LANDSCAPE";
        default: return @"UNKNOWN";
    }
    return @"LANDSCAPE";
}

+ (Orientation)getValueByName:(NSString *)name {
    if([name  isEqual: @"PORTRAIT"]) return PORTRAIT;
    if([name  isEqual: @"LANDSCAPE"]) return LANDSCAPE;
    return LANDSCAPE;
}

@end
