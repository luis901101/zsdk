//
//  ZPrinter.m
//  zsdk
//
//  Created by Luis on 1/15/20.
//

#import "ZPrinter.h"
#import "SGD.h"
#import "ZebraPrinterFactory.h"
#import "TcpPrinterConnection.h"
#import "ErrorCodeUtils.h"
#import "PrinterResponse.h"

@implementation ZPrinter
NSString *PRINTER_LANGUAGES_CONF_KEY = @"device.languages";
NSString *ZPL_LANGUAGE_VALUE = @"hybrid_xml_zpl";
const int DEFAULT_ZPL_TCP_PORT = 9100;


- (id)initWithMethodChannel:(FlutterMethodChannel *)channel result:(FlutterResult)result printerConf:(PrinterConf *)printerConf{
    self = [self init];
    if(self){
        self.channel = channel;
        self.result = result;
        self.printerConf = ![ObjectUtils isNull:printerConf] ? printerConf : [[PrinterConf alloc] initWithCmWidth:nil cmHeight:nil dpi:nil orientation:nil];
    }
    return self;
}

- (void)initValues:(id<ZebraPrinterConnection,NSObject>)connection{
    [self.printerConf initValues:connection];
}

- (void)checkPrinterStatusOverTCPIP:(NSString *)address port:(NSNumber *)port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [[TcpPrinterConnection alloc] initWithAddress:address andWithPort:tcpPort];
            if(![connection open]){
                StatusInfo *statusInfo = [self getStatusInfo:printer];
                statusInfo.cause = NO_CONNECTION;
                PrinterResponse *response = [[PrinterResponse alloc] init:PRINTER_ERROR statusInfo:statusInfo message:@"Printer error"];
                self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
                return;
            }
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                StatusInfo *statusInfo = [self getStatusInfo:printer];
                PrinterResponse *response = [[PrinterResponse alloc] init:SUCCESS statusInfo:statusInfo message:@"Successful print"];
                self.result([response toMap]);
            }
            @catch (NSException *e) {
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            StatusInfo *statusInfo = [self getStatusInfo:printer];
            PrinterResponse *response = [[PrinterResponse alloc] init:EXCEPTION statusInfo:statusInfo message:@"Printer error"];
            response.statusInfo.cause = UNKNOWN_CAUSE;
            self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
        }
    });
}

- (void)printZplFileOverTCPIP:(NSString *)filePath address:(NSString *)address port:(NSNumber*)port {
    //check if file exist.
    //Extract data from file
    //call printZplDataOverTCPIP passing the extracted data from file
    self.result(FlutterMethodNotImplemented);
}

- (void)printZplDataOverTCPIP:(NSString *)data address:(NSString *)address port:(NSNumber*)port {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        id<ZebraPrinter,NSObject> printer;
        id<ZebraPrinterConnection,NSObject> connection;
        @try {
            if([ObjectUtils isNull:data])
                @throw [NSException exceptionWithName:@"Printer Error" reason:@"ZPL data can not be empty" userInfo:nil];

            int tcpPort = ![ObjectUtils isNull:port] ? [port intValue] : DEFAULT_ZPL_TCP_PORT;
            
            connection = [[TcpPrinterConnection alloc] initWithAddress:address andWithPort:tcpPort];
            if(![connection open]){
                StatusInfo *statusInfo = [self getStatusInfo:printer];
                statusInfo.cause = NO_CONNECTION;
                PrinterResponse *response = [[PrinterResponse alloc] init:PRINTER_ERROR statusInfo:statusInfo message:@"Printer error"];
                self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
                return;
            }
            NSError *error = nil;
            @try {
                printer = [ZebraPrinterFactory getInstance:connection error:&error];
                if ([self isReadyToPrint:printer]) {
                    [self initValues:connection];
                    [self changePrinterLanguage:connection language:ZPL_LANGUAGE_VALUE];
                    NSData *dataBytes = [NSData dataWithBytes:[data UTF8String] length:[data length]];
                    
                    [connection write:dataBytes error:&error];
                    
                    if (![ObjectUtils isNull:error]) {
                        @throw [NSException exceptionWithName:@"Printer error"
                                                       reason:[error description]
                                                       userInfo:nil];
                    } else {
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
            } @finally {
                [connection close];
            }
        }
        @catch (NSException *e) {
            StatusInfo *statusInfo = [self getStatusInfo:printer];
            PrinterResponse *response = [[PrinterResponse alloc] init:EXCEPTION statusInfo:statusInfo message:@"Printer error"];
            response.statusInfo.cause = UNKNOWN_CAUSE;
            self.result([FlutterError errorWithCode:[response getErrorCode] message: response.message details:[response toMap]]);
        }
    });
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

- (StatusInfo *)getStatusInfo:(id<ZebraPrinter,NSObject>)printer{
    Status status = UNKNOWN_STATUS;
    Cause cause = UNKNOWN_CAUSE;
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
    return [[StatusInfo alloc] init:status cause:cause];
}

- (void)changePrinterLanguage:(id<ZebraPrinterConnection,NSObject>)connection language:(NSString *)language {
    if([ObjectUtils isNull:connection]) return;
    if(![connection isConnected]) [connection open];

    if([ObjectUtils isNull:language]) language = ZPL_LANGUAGE_VALUE;

    NSError *error = nil;
    const NSString *printerLanguage = [SGD GET:PRINTER_LANGUAGES_CONF_KEY withPrinterConnection:connection error:&error];
    if (![ObjectUtils isNull:error])
        @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
    if(![printerLanguage isEqualToString:language]){
        [SGD SET:PRINTER_LANGUAGES_CONF_KEY withValue:language andWithPrinterConnection:connection error:&error];
        if (error != nil)
            @throw [NSException exceptionWithName:@"Printer Error" reason:[error description] userInfo:nil];
    }
}

@end
