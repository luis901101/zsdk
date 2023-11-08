//
//  VirtualDeviceUtils.m
//  zsdk
//
//  Created by Luis on 11/7/23.
//

#import "VirtualDeviceUtils.h"

@implementation VirtualDeviceUtils

+ (void)changeVirtualDevice:(id<ZebraPrinterConnection,NSObject>)connection virtualDevice:(NSString *)virtualDevice {
    NSError *error = nil;
    NSString *command = @"^XA^JUS^XZ";
    @try {
        if ([ObjectUtils isNull:virtualDevice]) return;
        if(connection == nil) return;
        if(![connection isConnected]) [connection open];
        
        const NSString *currentVirtualDevice = [SGD GET:SGDParams.KEY_VIRTUAL_DEVICE withPrinterConnection:connection error:&error];
        
        if (![ObjectUtils isNull:error])
            @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
        if([ObjectUtils isNull:currentVirtualDevice] || ![currentVirtualDevice isEqualToString:virtualDevice]){
            [SGD SET:SGDParams.KEY_VIRTUAL_DEVICE withValue:virtualDevice andWithPrinterConnection:connection error:&error];
            if (error != nil)
                @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
            [self reboot:connection];
        }
    }
    @catch (NSException *e) {
        @throw e;
    }
}

+ (void)reboot:(id<ZebraPrinterConnection,NSObject>)connection; {
    NSError *error = nil;
    @try {
        if(![connection isConnected]) [connection open];
//         Another way would be using the following ZPL command:
//        [connection write:[@"^XA^JUS^XZ" dataUsingEncoding:NSUTF8StringEncoding] error:&error];
        
        id<ZebraPrinter,NSObject> printer = [ZebraPrinterFactory getInstance:connection error:&error];
        id<ToolsUtil,NSObject> toolsUtils = [printer getToolsUtil];
        [toolsUtils reset:&error];
    }
    @catch (NSException *e) {
        @throw e;
    } @finally {
        [connection close];
    }
}

@end
