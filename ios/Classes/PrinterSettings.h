//
//  PrinterSettings.h
//  zsdk
//
//  Created by Luis on 2/12/20.
//

#import <Foundation/Foundation.h>
#import "ZebraPrinterConnection.h"
#import "ObjectUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterSettings : NSObject

/** Writable settings */
@property NSString *darkness;
@property NSString *printSpeed;
@property NSString *tearOff;
@property NSString *mediaType;
@property NSString *printMethod;
@property NSString *printWidth;
@property NSString *labelLength;
@property NSString *labelLengthMax;
@property NSString *zplMode;
@property NSString *powerUpAction;
@property NSString *headCloseAction;
@property NSString *labelTop;
@property NSString *leftPosition;
@property NSString *printMode;
@property NSString *reprintMode;

/** Read only settings */
@property NSString *printerModelName;
@property NSString *deviceFriendlyName;
@property NSString *firmware;
@property NSString *linkOSVersion;
@property NSString *printerDpi;
@property NSString *devicePrintHeadResolution;

- (id) initWithArguments:(NSDictionary*)arguments;
- (id) initWithValues:(NSString*)printerModelName deviceFriendlyName:(NSString*)deviceFriendlyName firmware:(NSString*)firmware linkOSVersion:(NSString*)linkOSVersion printerDpi:(NSString*)printerDpi devicePrintHeadResolution:(NSString*)devicePrintHeadResolution;

- (void) apply: (id<ZebraPrinterConnection, NSObject>)connection;
- (NSDictionary *) toMap;
+ (PrinterSettings*) get: (id<ZebraPrinterConnection, NSObject>)connection;

@end

NS_ASSUME_NONNULL_END
