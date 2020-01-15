#import "ZsdkPlugin.h"
#import <ExternalAccessory/ExternalAccessory.h>
#import "MfiBtPrinterConnection.h"
#import "ZebraPrinter.h"
#import "ZebraPrinterFactory.h"
#import "ZebraPrinterConnection.h"
#import "TcpPrinterConnection.h"
#import "SGD.h"

#import "CauseUtils.h"
#import "ErrorCodeUtils.h"
#import "OrientationUtils.h"
#import "StatusInfo.h"
#import "PrinterResponse.h"
#import "PrinterConf.h"
#import "ZPrinter.h"

@implementation ZsdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"zsdk"
            binaryMessenger:[registrar messenger]];
  ZsdkPlugin* instance = [[ZsdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)discoverBluetoothDevices:(FlutterResult)result {
    @try {
        NSString *serialNumber = @"";
        NSString *name = @"";
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        EAAccessoryManager *sam = [EAAccessoryManager sharedAccessoryManager];
        NSArray * connectedAccessories = [sam connectedAccessories];
        for (EAAccessory *accessory in connectedAccessories) {
            if([accessory.protocolStrings indexOfObject:@"com.zebra.rawport"] != NSNotFound){
                serialNumber = accessory.serialNumber;
                name = accessory.name;
                
                [dict setObject:name forKey:serialNumber];
            }
        }
        result(dict);
    }
    @catch (NSException *exception) {
        result([FlutterError errorWithCode:@"Error"
                                       message: exception.reason
                                       details:nil]);
    }
}

- (void)getDeviceProperties:(NSString*) serial result:(FlutterResult)result {
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
     [dict setObject:@"Not Implemented" forKey:@"error"];
     result(dict);
}

- (void)getBatteryLevel:(NSString*) serial result:(FlutterResult)result {
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            id<ZebraPrinterConnection, NSObject> connection = [[MfiBtPrinterConnection alloc] initWithSerialNumber:serial];
            
            NSError *error = nil;
            
            [connection open];
            
            NSString *battery = [SGD GET:@"power.percent_full" withPrinterConnection:connection error:&error];
            
            [connection close];
            
            if (error != nil) {
                @throw [NSException exceptionWithName:@"Printer Error"
                                               reason:[error description]
                                               userInfo:nil];
            }
            
            result(battery);
        }
        @catch (NSException *e) {
            result([FlutterError errorWithCode:@"Error"
                                       message: e.reason
                                       details:nil]);
        }
    });
}

- (void)sendZplOverBluetooth:(NSString *)serial data:(NSString*)data result:(FlutterResult)result {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try {
            // Instantiate connection to Zebra Bluetooth accessory
            //EAAccessoryManager *sam = [EAAccessoryManager sharedAccessoryManager];
            
            id<ZebraPrinterConnection, NSObject> connection = [[MfiBtPrinterConnection alloc] initWithSerialNumber:serial];
            
            NSError *error = nil;
            //BOOL success =
             [connection open];
            
            /*
             id<ZebraPrinter,NSObject> printer = [ZebraPrinterFactory getInstance:connection error:&error];
            */
            NSData *dataBytes = [NSData dataWithBytes:[data UTF8String] length:[data length]];
            
            [connection write:dataBytes error:&error];
            
            /*
             success = success && [thePrinterConn write:[data dataUsingEncoding:NSUTF8StringEncoding] error:&error];
             */
            if (error != nil) {
                @throw [NSException exceptionWithName:@"Printer Error"
                                               reason:[error description]
                                               userInfo:nil];
            } else {
                result(@"Wrote. Are you happy?");
            }
        
            [connection close];
        }@catch (NSException *exception) {
                result([FlutterError errorWithCode:@"Error"
                                           message: exception.reason
                                           details:nil]);
         }
       // [connection release];
    });
    
}

- (void)test:(FlutterResult)result {
    @try {
        id<ZebraPrinterConnection,NSObject> connection = [[TcpPrinterConnection alloc] initWithAddress:@"10.0.1.100" andWithPort:9100];
        [connection open];
        PrinterConf *printerConf = [[PrinterConf alloc] initWithCmWidth:nil cmHeight:nil dpi:nil orientation:nil];
        
        [printerConf initValues:connection];
    }
    @catch (NSException *exception) {
        result([FlutterError errorWithCode:@"Error"
                                       message: exception.reason
                                       details:nil]);
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"Loooooog %@", [CauseUtils getNameByValue:(HEAD_TOOHOT)]);
    NSLog(@"Loooooog %@", [ErrorCodeUtils getNameByValue:(PRINTER_ERROR)]);
    NSLog(@"Loooooog %@", [OrientationUtils getNameByValue:(LANDSCAPE)]);
    
    StatusInfo *statusInfo = [[StatusInfo alloc] init:PAUSED cause:HEAD_TOOHOT];
    PrinterResponse *printerResponse = [[PrinterResponse alloc] init:EXCEPTION statusInfo:statusInfo message:@"Printer is not ready"];
    
    NSLog(@"Loooooog Status %lu", (unsigned long)[statusInfo status]);
    NSLog(@"Loooooog Cause %lu", (unsigned long)[statusInfo cause]);
    NSLog(@"Loooooog StatusInfo %@", [statusInfo toMap]);
    NSLog(@"Loooooog PrinterErrorDetails %@", [printerResponse toMap]);
    
//    result([FlutterError errorWithCode:@"asd" message: @"asd" details:nil]);
//    result([FlutterError errorWithCode:[ErrorCodeUtils getNameByValue:PRINTER_ERROR] message: @"Printer is not ready" details:nil]);
    
//    [self test:result];
    
    ZPrinter *printer = [[ZPrinter alloc] initWithMethodChannel:nil result:result printerConf:[[PrinterConf alloc] initWithCmWidth:nil cmHeight:nil dpi:nil orientation:nil]];
    
    [printer printZplDataOverTCPIP:@"^XA^FO17,16^GB379,371,8^FS^FT65,255^A0N,135,134^FDTEST^FS^XZ" address:@"10.0.1.100" port:@"9100"];
    if(true) return;
   
    NSLog(@"Handle method call");
    
   if ([@"discoverBluetoothDevices" isEqualToString:call.method]) {
       [self discoverBluetoothDevices:result];
   }
   else if ([@"getDeviceProperties" isEqualToString:call.method]) {
       NSDictionary *arguments = [call arguments];
       
       NSString* serial = arguments[@"mac"];
       
       [self getDeviceProperties:serial result:result];
   }
   else if ([@"getBatteryLevel" isEqualToString:call.method]) {
       NSDictionary *arguments = [call arguments];
       
       NSString* serial = arguments[@"mac"];
       
       [self getBatteryLevel:serial result:result];
   }
   else if ([@"sendZplOverBluetooth" isEqualToString:call.method]) {
       NSDictionary *arguments = [call arguments];
       
       NSString *serial = arguments[@"mac"];
       NSString *data = arguments[@"data"];
       
       [self sendZplOverBluetooth:serial data:data result:result];
   }
   else {
     result(FlutterMethodNotImplemented);
   }
}
       

@end
