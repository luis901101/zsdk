//
//  ObjectUtils.m
//  zsdk
//
//  Created by Luis on 1/15/20.
//

#import "ObjectUtils.h"

@implementation ObjectUtils

+ (bool) isNull:(id)value {
    return value == nil || [value isKindOfClass:[NSNull class]];
}

@end
