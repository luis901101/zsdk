#import <Flutter/Flutter.h>

@interface ZsdkPlugin : NSObject<FlutterPlugin>

- (void)discoverBluetoothDevices:(FlutterResult)result;

- (void)getDeviceProperties:(NSString*) serial result:(FlutterResult)result;

- (void)sendZplOverBluetooth:(NSString *)serial data:(NSString*)data result:(FlutterResult)result;

@end
