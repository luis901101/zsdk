//
//  SGDParams.h
//  zsdk
//
//  Created by Luis on 2/12/20.
//

#import <Foundation/Foundation.h>
#import "ZebraPrinterConnection.h"

NS_ASSUME_NONNULL_BEGIN

@interface SGDParams : NSObject
/** Settings */

/** Writable settings */
+ (NSString*)KEY_DARKNESS;
+ (NSString*)KEY_PRINT_SPEED;
+ (NSString*)KEY_TEAR_OFF;
+ (NSString*)KEY_MEDIA_TYPE;
+ (NSString*)KEY_PRINT_METHOD;
+ (NSString*)KEY_PRINT_WIDTH;
+ (NSString*)KEY_LABEL_LENGTH;
+ (NSString*)KEY_LABEL_LENGTH_MAX;
+ (NSString*)KEY_ZPL_MODE;
+ (NSString*)KEY_POWER_UP_ACTION;
+ (NSString*)KEY_HEAD_CLOSE_ACTION;
+ (NSString*)KEY_LABEL_TOP;
+ (NSString*)KEY_LEFT_POSITION;
+ (NSString*)KEY_PRINT_MODE;
+ (NSString*)KEY_REPRINT_MODE;
+ (NSString*)KEY_PRINTER_LANGUAGES;

/** Read only settings */
+ (NSString*)KEY_PRINTER_MODEL_NAME;
+ (NSString*)KEY_DEVICE_FRIENDLY_NAME;
+ (NSString*)KEY_FIRMWARE;
+ (NSString*)KEY_LINK_OS_VERSION;
+ (NSString*)KEY_PRINTER_DPI;
+ (NSString*)KEY_DEVICE_PRINT_HEAD_RESOLUTION;

/** Actions */
+ (NSString*)KEY_MANUAL_CALIBRATION;

/** Values */
+ (NSString*)VALUE_ZPL_LANGUAGE;
+ (double)VALUE_DPI_DEFAULT;
+ (NSString*)VALUE_GET_ALL;

@end


NS_ASSUME_NONNULL_END
