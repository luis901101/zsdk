//
//  StatusInfo.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "StatusInfo.h"
#import "StatusUtils.h"
#import "CauseUtils.h"


@implementation StatusInfo

- (id) init:(Status)status cause:(Cause)cause {
    self = [super init];
    if(self){
        self.status = status;
        self.cause = cause;
    }
    return self;
}

- (NSDictionary *) toMap {
    id objects[] = {[StatusUtils getNameByValue:(self.status)], [CauseUtils getNameByValue:(self.cause)]};
    id keys[] = {@"status", @"cause"};
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSDictionary *map = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
    return map;
}

@end
