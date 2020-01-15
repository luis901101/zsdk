//
//  ZPrinter.h
//  zsdk
//
//  Created by Luis on 1/15/20.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "PrinterConf.h"
#import "StatusInfo.h"
#import "ZebraPrinter.h"
#import "ZebraPrinterConnection.h"


NS_ASSUME_NONNULL_BEGIN

@interface ZPrinter : NSObject
@property FlutterMethodChannel *channel;
@property FlutterResult result;
@property PrinterConf *printerConf;
- (id) initWithMethodChannel:(FlutterMethodChannel *)channel result:(FlutterResult)result printerConf:(PrinterConf *)printerConf;
- (void) initValues:(id<ZebraPrinterConnection, NSObject>)connection;
- (void) printZplFileOverTCPIP:(NSString *)filePath address:(NSString *)address port:(id)port;
- (void) printZplDataOverTCPIP:(NSString *)data address:(NSString *)address port:(id)port;
- (bool) isReadyToPrint:(id<ZebraPrinter, NSObject>)printer;
- (StatusInfo *) getStatusInfo:(id<ZebraPrinter, NSObject>)printer;
- (void) changePrinterLanguage:(id<ZebraPrinterConnection, NSObject>)connection language:(NSString *)language;
@end

NS_ASSUME_NONNULL_END
