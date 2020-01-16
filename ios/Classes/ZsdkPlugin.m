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
    [[ZsdkPlugin alloc] init:registrar];
}

/* Channel */
NSString* _METHOD_CHANNEL = @"zsdk";

/* Methods */
NSString* _PRINT_PDF_FILE_OVER_TCP_IP = @"printPdfFileOverTCPIP";
NSString* _PRINT_PDF_DATA_OVER_TCP_IP = @"printPdfDataOverTCPIP";
NSString* _PRINT_ZPL_FILE_OVER_TCP_IP = @"printZplFileOverTCPIP";
NSString* _PRINT_ZPL_DATA_OVER_TCP_IP = @"printZplDataOverTCPIP";

/* Properties */
NSString* _filePath = @"filePath";
NSString* _data = @"data";
NSString* _address = @"address";
NSString* _port = @"port";
NSString* _cmWidth = @"cmWidth";
NSString* _cmHeight = @"cmHeight";
NSString* _orientation = @"orientation";
NSString* _dpi = @"dpi";

- (id)init:(id<FlutterPluginRegistrar,NSObject>)registrar {
    self = [self init];
    if(self){
        self.channel =[FlutterMethodChannel
        methodChannelWithName:_METHOD_CHANNEL binaryMessenger:[registrar messenger]];
        [registrar addMethodCallDelegate:self channel:self.channel];
    }
    return self;
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
    NSDictionary *arguments = [call arguments];
    ZPrinter *printer = [[ZPrinter alloc]
                         initWithMethodChannel:self.channel
                         result:result
                         printerConf:[[PrinterConf alloc]
                                      initWithCmWidth:arguments[_cmWidth]
                                      cmHeight:arguments[_cmHeight]
                                      dpi:arguments[_dpi]
                                      orientation:arguments[_orientation]
                                      ]
                         ];
   
    if ([_PRINT_ZPL_FILE_OVER_TCP_IP isEqualToString:call.method])
       [printer printZplFileOverTCPIP:arguments[_filePath] address:arguments[_address] port:arguments[_port]];
    else if ([_PRINT_ZPL_DATA_OVER_TCP_IP isEqualToString:call.method])
        [printer printZplDataOverTCPIP:arguments[_data] address:arguments[_address] port:arguments[_port]];
    else result(FlutterMethodNotImplemented);
}
       

@end
