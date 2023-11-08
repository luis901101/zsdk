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

NS_ASSUME_NONNULL_BEGIN

@interface VirtualDeviceUtils : NSObject

+ (void) changeVirtualDevice:(id<ZebraPrinterConnection,NSObject>)connection virtualDevice:(NSString *)virtualDevice;
+ (void) reboot:(id<ZebraPrinterConnection,NSObject>)connection;

@end

NS_ASSUME_NONNULL_END

