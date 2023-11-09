//
//  ZPrinter.m
//  zsdk
//
//  Created by Luis on 1/15/20.
//

#import "ZPrinter.h"
#import "ZebraPrinterFactory.h"
#import "TcpPrinterConnection.h"
#import "ErrorCodeUtils.h"
#import "PrinterResponse.h"
#import "SGDParams.h"
#import "SGD.h"
#import "ToolsUtil.h"
#import "PrinterSettings.h"
#import "VirtualDeviceUtils.h"
#import "PrinterUtils.h"
#import "api/FileUtil.h"

@implementation ZPrinter
const int DEFAULT_ZPL_TCP_PORT = 9100;
const int MAX_TIME_OUT_FOR_READ = 5000;
const int TIME_TO_WAIT_FOR_MORE_DATA = 0;

- (id)initWithMethodChannel:(FlutterMethodChannel *)channel result:(FlutterResult)result printerConf:(PrinterConf *)printerConf{
    self = [self init];
    if(self){
        self.channel = channel;
        self.result = result;
        self.printerConf = ![ObjectUtils isNull:printerConf] ? printerConf : [[PrinterConf alloc] initWithCmWidth:nil cmHeight:nil dpi:nil orientation:nil];
    }
    return self;
}

+ (TcpPrinterConnection *) initWithAddress:(NSString *)anAddress andWithPort:(NSInteger)aPort {
    return [[TcpPrinterConnection alloc] initWithAddress:anAddress withPort:aPort withMaxTimeoutForRead:MAX_TIME_OUT_FOR_READ andWithTimeToWaitForMoreData:TIME_TO_WAIT_FOR_MORE_DATA];
}

- (void)initValues:(id<ZebraPrinterConnection,NSObject>)connection{
    [self.printerConf initValues:connection];
}

- (void)onConnectionTimeOut {
    StatusInfo *statusInfo = [[StatusInfo alloc] init:UNKNOWN_STATUS cause:NO_CONNECTION];
    PrinterResponse *response = [[PrinterResponse alloc] init:EXCEPTION statusInfo:statusInfo message:@"Connection timeout."];
    self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
}

- (void)onPrinterRebooted:(NSString*) message {
    StatusInfo *statusInfo = [[StatusInfo alloc] init:UNKNOWN_STATUS cause:NO_CONNECTION];
    PrinterResponse *response = [[PrinterResponse alloc] init:PRINTER_REBOOTED statusInfo:statusInfo message:message];
    self.result([response toMap]);
}

- (void)onException:(nullable id<ZebraPrinter,NSObject>)printer exception:(NSException *)exception {
    NSLog(@"%@", exception.reason);
    StatusInfo *statusInfo = [self getStatusInfo:printer];
    PrinterResponse *response = [[PrinterResponse alloc] init:EXCEPTION statusInfo:statusInfo message:[NSString stringWithFormat:@"%@ %@ %@", @"Unknown exception.", exception.name, exception.reason]];
    self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
}

- (void)doManualCalibrationOverTCPIP:(NSString *)address port:(NSNumber *)port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                //                id<ToolsUtil,NSObject> toolsUtils = [printer getToolsUtil];
                //                [toolsUtils calibrate:&error];
                [SGD DO:SGDParams.KEY_MANUAL_CALIBRATION withValue:nil andWithPrinterConnection:connection error:&error];
                
                if (![ObjectUtils isNull:error])
                    @throw [NSException exceptionWithName:@"Printer error" reason:[error description] userInfo:nil];
                else {
                    StatusInfo *statusInfo = [self getStatusInfo:printer];
                    PrinterResponse *response = [[PrinterResponse alloc] init:SUCCESS statusInfo:statusInfo message:@"Printer status"];
                    self.result([response toMap]);
                }
            }
            @catch (NSException *e) {
                @throw e;
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            [self onException:printer exception:e];
        }
    });
}

- (void)printConfigurationLabelOverTCPIP:(NSString *)address port:(NSNumber *)port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                id<ToolsUtil,NSObject> toolsUtils = [printer getToolsUtil];
                [toolsUtils printConfigurationLabel:&error];
                
                if (![ObjectUtils isNull:error])
                    @throw [NSException exceptionWithName:@"Printer error" reason:[error description] userInfo:nil];
                else {
                    StatusInfo *statusInfo = [self getStatusInfo:printer];
                    PrinterResponse *response = [[PrinterResponse alloc] init:SUCCESS statusInfo:statusInfo message:@"Printer status"];
                    self.result([response toMap]);
                }
            }
            @catch (NSException *e) {
                @throw e;
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            [self onException:printer exception:e];
        }
    });
}

- (void)checkPrinterStatusOverTCPIP:(NSString *)address port:(NSNumber *)port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                StatusInfo *statusInfo = [self getStatusInfo:printer];
                PrinterResponse *response = [[PrinterResponse alloc] init:SUCCESS statusInfo:statusInfo message:@"Printer status"];
                self.result([response toMap]);
            }
            @catch (NSException *e) {
                @throw e;
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            [self onException:printer exception:e];
        }
    });
}

- (void)getPrinterSettingsOverTCPIP:(NSString *)address port:(NSNumber *)port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                PrinterSettings *settings = [PrinterSettings get:connection];
                StatusInfo *statusInfo = [self getStatusInfo:printer];
                PrinterResponse *response = [[PrinterResponse alloc] initWithSettings:SUCCESS statusInfo:statusInfo settings:settings message:@"Printer status"];
                self.result([response toMap]);
            }
            @catch (NSException *e) {
                @throw e;
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            [self onException:printer exception:e];
        }
    });
}

- (void)setPrinterSettingsOverTCPIP:(NSString *)address port:(NSNumber *)port settings:(PrinterSettings *)settings {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            
            if([ObjectUtils isNull:settings])
                @throw [NSException exceptionWithName:@"Printer Error" reason:@"Settings can't be null" userInfo:nil];
            
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                [settings apply:connection];
                if(![connection isConnected]) {
                    [self onPrinterRebooted:@"New settings required Printer to reboot"];
                    return;
                }
                PrinterSettings *settings = [PrinterSettings get:connection];
                StatusInfo *statusInfo = [self getStatusInfo:printer];
                PrinterResponse *response = [[PrinterResponse alloc] initWithSettings:SUCCESS statusInfo:statusInfo settings:settings message:@"Printer status"];
                self.result([response toMap]);
            }
            @catch (NSException *e) {
                @throw e;
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            [self onException:printer exception:e];
        }
    });
}

- (void)printPdfFileOverTCPIP:(NSString *)filePath address:(NSString *)address port:(NSNumber*)port {
    [self doPrintOverTCPIP:nil filePath:filePath address:address port:port isZPL:false];
}

- (void)printZplFileOverTCPIP:(NSString *)filePath address:(NSString *)address port:(NSNumber*)port {
    [self doPrintOverTCPIP:nil filePath:filePath address:address port:port isZPL:true];
}

- (void)printZplDataOverTCPIP:(NSString *)data address:(NSString *)address port:(NSNumber*)port {
    [self doPrintOverTCPIP:data filePath:nil address:address port:port isZPL:true];
}

- (void) doPrintOverTCPIP:(nullable NSString *)data filePath:(nullable NSString *)filePath address:(NSString *)address port:(NSNumber*)port isZPL:(Boolean)isZPL; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                if ([self isReadyToPrint:printer]) {
                    [self initValues:connection];
                    
                    if(isZPL) {
                        [self changePrinterLanguage:connection language:SGDParams.VALUE_ZPL_LANGUAGE];
                    } else {
                        // If enablePDFDirect was required, then abort printing as the Printer will be rebooted and the connection will be closed.
                        if ([self enablePDFDirect:connection enabled:true]) {
                            [self onPrinterRebooted:@"Printer was rebooted to be able to use PDF Direct feature."];
                            return;
                        }
                    }
                    
                    if(![ObjectUtils isNull:data]) {
                        [connection write:[data dataUsingEncoding:NSUTF8StringEncoding] error:&error];
                    } else if(![ObjectUtils isNull:filePath]) {
                        id<FileUtil,NSObject> fileUtil = [printer getFileUtil];
                        [fileUtil sendFileContents:filePath error:&error];
                    }
                    
                    if (![ObjectUtils isNull:error])
                        @throw [NSException exceptionWithName:@"Printer error" reason:[error description] userInfo:nil];
                    else {
                        StatusInfo *statusInfo = [self getStatusInfo:printer];
                        PrinterResponse *response = [[PrinterResponse alloc] init:SUCCESS statusInfo:statusInfo message:@"Successful print"];
                        self.result([response toMap]);
                    }
                } else {
                    StatusInfo *statusInfo = [self getStatusInfo:printer];
                    PrinterResponse *response = [[PrinterResponse alloc] init:PRINTER_ERROR statusInfo:statusInfo message:@"Printer is not ready"];
                    self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
                }
            }
            @catch (NSException *e) {
                @throw e;
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            [self onException:printer exception:e];
        }
    });
}


//
// Returns true if the PDF Direct feature was not enabled and requires to be enabled which means the Printer is going to be rebooted, false otherwise.
//
- (bool) enablePDFDirect:(id<ZebraPrinterConnection,NSObject>)connection enabled:(Boolean)enabled; {
    if(connection == nil) return false;
    if(![connection isConnected]) [connection open];
    
    return [VirtualDeviceUtils changeVirtualDevice:connection virtualDevice: enabled ? SGDParams.VALUE_PDF : SGDParams.VALUE_NONE];
}

- (bool)isReadyToPrint:(id<ZebraPrinter,NSObject>)printer{
    @try {
        NSError *error = nil;
        bool value = [[printer getCurrentStatus:&error] isReadyToPrint];
        if (![ObjectUtils isNull:error])
            @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
        return value;
    } @catch (NSException *e) {
        NSLog(@"%@", e.reason);
    }
    return false;
}

- (StatusInfo *)getStatusInfo:(nullable id<ZebraPrinter,NSObject>)printer{
    Status status = UNKNOWN_STATUS;
    Cause cause = UNKNOWN_CAUSE;
    if(printer != nil) {
        @try {
            NSError *error = nil;
            PrinterStatus *printerStatus = [printer getCurrentStatus:&error];
            if (![ObjectUtils isNull:error])
                @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
            
            if([printerStatus isPaused]) status = PAUSED;
            if([printerStatus isReadyToPrint]) status = READY_TO_PRINT;

            if([printerStatus isPartialFormatInProgress]) cause = PARTIAL_FORMAT_IN_PROGRESS;
            if([printerStatus isHeadCold]) cause = HEAD_COLD;
            if([printerStatus isHeadOpen]) cause = HEAD_OPEN;
            if([printerStatus isHeadTooHot]) cause = HEAD_TOO_HOT;
            if([printerStatus isPaperOut]) cause = PAPER_OUT;
            if([printerStatus isRibbonOut]) cause = RIBBON_OUT;
            if([printerStatus isReceiveBufferFull]) cause = RECEIVE_BUFFER_FULL;

        } @catch (NSException *e) {
            NSLog(@"%@", e.reason);
        }
    }
    return [[StatusInfo alloc] init:status cause:cause];
}

- (void)changePrinterLanguage:(id<ZebraPrinterConnection,NSObject>)connection language:(NSString *)language {
    if([ObjectUtils isNull:connection]) return;
    if(![connection isConnected]) [connection open];

    if([ObjectUtils isNull:language]) language = SGDParams.VALUE_ZPL_LANGUAGE;

    NSError *error = nil;
    const NSString *printerLanguage = [SGD GET:SGDParams.KEY_PRINTER_LANGUAGES withPrinterConnection:connection error:&error];
    if (![ObjectUtils isNull:error])
        @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
    if(![printerLanguage isEqualToString:language]){
        [SGD SET:SGDParams.KEY_PRINTER_LANGUAGES withValue:language andWithPrinterConnection:connection error:&error];
        if (error != nil)
            @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
    }
}

- (void) rebootPrinter:(NSString *)address port:(NSNumber*) port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [ZPrinter initWithAddress:address andWithPort:tcpPort];
            if(![connection open]) return [self onConnectionTimeOut];
            
            if([PrinterUtils reboot:connection]) {
                [self onPrinterRebooted:@"Printer successfully rebooted"];
            } else {
                StatusInfo *statusInfo = [[StatusInfo alloc] init:UNKNOWN_STATUS cause:UNKNOWN_CAUSE];
                PrinterResponse *response = [[PrinterResponse alloc] init:EXCEPTION statusInfo:statusInfo message:@"Printer could not be rebooted."];
                self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
            }
        } @catch (NSException *e) {
            [self onException:nil exception:e];
        } @finally {
            if(connection != nil) [connection close];
        }
    });
}

@end
