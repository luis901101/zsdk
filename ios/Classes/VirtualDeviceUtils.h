//
//  VirtualDeviceUtils.h
//  zsdk
//
//  Created by Luis on 11/7/23.
//

#import <Foundation/Foundation.h>
#import "ZPrinter.h"
#import "ZebraPrinterFactory.h"
#import "SGD.h"
#import "SGDParams.h"
#import "ToolsUtil.h"
#import "PrinterUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface VirtualDeviceUtils : NSObject

//
//  This changes the printer Virtual Device only if the current Virtual Device on the printer is different that the one to be changed to and reboots the printer for the changes to take effect.
//  Returns true if the change was necessary and applied, false otherwise.
//

+ (bool) changeVirtualDevice:(id<ZebraPrinterConnection,NSObject>)connection virtualDevice:(NSString *)virtualDevice;

@end

NS_ASSUME_NONNULL_END

