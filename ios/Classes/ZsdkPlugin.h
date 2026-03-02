#import <Flutter/Flutter.h>
#import "ZebraPrinterConnection.h"

@interface ZsdkPlugin : NSObject<FlutterPlugin>
@property FlutterMethodChannel* channel;
- (id) init:(id<FlutterPluginRegistrar, NSObject>) registrar;
@end
