#import "ZsdkPlugin.h"
#import <zsdk/zsdk-Swift.h>

@implementation ZsdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZsdkPlugin registerWithRegistrar:registrar];
}
@end
