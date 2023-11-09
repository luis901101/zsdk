//
//  VirtualDeviceUtils.m
//  zsdk
//
//  Created by Luis on 11/7/23.
//

#import "VirtualDeviceUtils.h"

@implementation VirtualDeviceUtils

+ (bool) changeVirtualDevice:(id<ZebraPrinterConnection,NSObject>)connection virtualDevice:(NSString *)virtualDevice {
    NSError *error = nil;
    NSString *command = @"^XA^JUS^XZ";
    @try {
        if ([ObjectUtils isNull:virtualDevice]) return false;
        if(connection == nil) return false;
        if(![connection isConnected]) [connection open];
        
        const NSString *currentVirtualDevice = [SGD GET:SGDParams.KEY_VIRTUAL_DEVICE withPrinterConnection:connection error:&error];
        
        if (![ObjectUtils isNull:error])
            @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
        if([ObjectUtils isNull:currentVirtualDevice] || ![currentVirtualDevice isEqualToString:virtualDevice]){
            [SGD SET:SGDParams.KEY_VIRTUAL_DEVICE withValue:virtualDevice andWithPrinterConnection:connection error:&error];
            if (error != nil)
                @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
            return [PrinterUtils reboot:connection];
        }
    }
    @catch (NSException *e) {
        @throw e;
    }
    return false;
}

@end
