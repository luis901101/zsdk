//
//  PrinterUtils.m
//  zsdk
//
//  Created by Luis on 11/9/23.
//

#import "PrinterUtils.h"

@implementation PrinterUtils

+ (bool) reboot:(id<ZebraPrinterConnection,NSObject>)connection; {
    NSError *error = nil;
    @try {
        if(![connection isConnected]) [connection open];
//         Another way would be using the following ZPL command:
//        [connection write:[@"^XA^JUS^XZ" dataUsingEncoding:NSUTF8StringEncoding] error:&error];
        
        id<ZebraPrinter,NSObject> printer = [ZebraPrinterFactory getInstance:connection error:&error];
        id<ToolsUtil,NSObject> toolsUtils = [printer getToolsUtil];
        [toolsUtils reset:&error];
        [connection close];
        return true;
    }
    @catch (NSException *e) {
        @throw e;
    }
    return false;
}

@end

