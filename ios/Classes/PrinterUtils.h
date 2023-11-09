//
//  PrinterUtils.h
//  zsdk
//
//  Created by Luis on 11/9/23.
//

#import <Foundation/Foundation.h>
#import "ZPrinter.h"
#import "ZebraPrinterFactory.h"
#import "ToolsUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterUtils : NSObject

//
//  Reboots the printer.
//  Returns true if successfully rebooted, false otherwise
//
+ (bool) reboot:(id<ZebraPrinterConnection,NSObject>)connection;

@end

NS_ASSUME_NONNULL_END
