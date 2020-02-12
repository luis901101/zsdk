//
//  PrinterSettings.m
//  zsdk
//
//  Created by Luis on 2/12/20.
//

#import "PrinterSettings.h"
#import "SGDParams.h"
#import "SGD.h"

@implementation PrinterSettings

/** Fields name */
const NSString *FIELD_DARKNESS = @"darkness";
const NSString *FIELD_PRINT_SPEED = @"printSpeed";
const NSString *FIELD_TEAR_OFF = @"tearOff";
const NSString *FIELD_MEDIA_TYPE = @"mediaType";
const NSString *FIELD_PRINT_METHOD = @"printMethod";
const NSString *FIELD_PRINT_WIDTH = @"printWidth";
const NSString *FIELD_LABEL_LENGTH = @"labelLength";
const NSString *FIELD_LABEL_LENGTH_MAX = @"labelLengthMax";
const NSString *FIELD_ZPL_MODE = @"zplMode";
const NSString *FIELD_POWER_UP_ACTION = @"powerUpAction";
const NSString *FIELD_HEAD_CLOSE_ACTION = @"headCloseAction";
const NSString *FIELD_LABEL_TOP = @"labelTop";
const NSString *FIELD_LEFT_POSITION = @"leftPosition";
const NSString *FIELD_PRINT_MODE = @"printMode";
const NSString *FIELD_REPRINT_MODE = @"reprintMode";
const NSString *FIELD_PRINTER_MODEL_NAME = @"printerModelName";
const NSString *FIELD_DEVICE_FRIENDLY_NAME = @"deviceFriendlyName";
const NSString *FIELD_FIRMWARE = @"firmware";
const NSString *FIELD_LINK_OS_VERSION = @"linkOSVersion";
const NSString *FIELD_PRINTER_DPI = @"printerDpi";

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if(self){
        self.darkness = arguments[FIELD_DARKNESS];
        self.printSpeed = arguments[FIELD_PRINT_SPEED];
        self.tearOff = arguments[FIELD_TEAR_OFF];
        self.mediaType = arguments[FIELD_MEDIA_TYPE];
        self.printMethod = arguments[FIELD_PRINT_METHOD];
        self.printWidth = arguments[FIELD_PRINT_WIDTH];
        self.labelLength = arguments[FIELD_LABEL_LENGTH];
        self.labelLengthMax = arguments[FIELD_LABEL_LENGTH_MAX];
        self.zplMode = arguments[FIELD_ZPL_MODE];
        self.powerUpAction = arguments[FIELD_POWER_UP_ACTION];
        self.headCloseAction = arguments[FIELD_HEAD_CLOSE_ACTION];
        self.labelTop = arguments[FIELD_LABEL_TOP];
        self.leftPosition = arguments[FIELD_LEFT_POSITION];
        self.printMode = arguments[FIELD_PRINT_MODE];
        self.reprintMode = arguments[FIELD_REPRINT_MODE];
        self.printerModelName = arguments[FIELD_PRINTER_MODEL_NAME];
        self.deviceFriendlyName = arguments[FIELD_DEVICE_FRIENDLY_NAME];
        self.firmware = arguments[FIELD_FIRMWARE];
        self.linkOSVersion = arguments[FIELD_LINK_OS_VERSION];
        self.printerDpi = arguments[FIELD_PRINTER_DPI];
    }
    return self;
}

- (id)initWithValues:(NSString *)printerModelName deviceFriendlyName:(NSString *)deviceFriendlyName firmware:(NSString *)firmware linkOSVersion:(NSString *)linkOSVersion printerDpi:(NSString *)printerDpi {
    self = [super init];
    if(self){
        self.printerModelName = printerModelName;
        self.deviceFriendlyName = deviceFriendlyName;
        self.firmware = firmware;
        self.linkOSVersion = linkOSVersion;
        self.printerDpi = printerDpi;
    }
    return self;
}

- (void)apply:(id<ZebraPrinterConnection,NSObject>)connection {
    if(![ObjectUtils isNull:connection]) {
        @try {
            if(![connection isConnected]) [connection open];
            NSError *error = nil;
            
            if(![ObjectUtils isNull:_darkness]) [SGD SET:SGDParams.KEY_DARKNESS withValue:_darkness andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_printSpeed]) [SGD SET:SGDParams.KEY_PRINT_SPEED withValue:_printSpeed andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_tearOff]) [SGD SET:SGDParams.KEY_TEAR_OFF withValue:_tearOff andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_mediaType]) [SGD SET:SGDParams.KEY_MEDIA_TYPE withValue:_mediaType andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_printMethod]) [SGD SET:SGDParams.KEY_PRINT_METHOD withValue:_printMethod andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_printWidth]) [SGD SET:SGDParams.KEY_PRINT_WIDTH withValue:_printWidth andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_labelLength]) [SGD SET:SGDParams.KEY_LABEL_LENGTH withValue:_labelLength andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_labelLengthMax]) [SGD SET:SGDParams.KEY_LABEL_LENGTH_MAX withValue:_labelLengthMax andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_zplMode]) [SGD SET:SGDParams.KEY_ZPL_MODE withValue:_zplMode andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_powerUpAction]) [SGD SET:SGDParams.KEY_POWER_UP_ACTION withValue:_powerUpAction andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_headCloseAction]) [SGD SET:SGDParams.KEY_HEAD_CLOSE_ACTION withValue:_headCloseAction andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_labelTop]) [SGD SET:SGDParams.KEY_LABEL_TOP withValue:_labelTop andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_leftPosition]) [SGD SET:SGDParams.KEY_LEFT_POSITION withValue:_leftPosition andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_printMode]) [SGD SET:SGDParams.KEY_PRINT_MODE withValue:_printMode andWithPrinterConnection:connection error:&error];
            if(![ObjectUtils isNull:_reprintMode]) [SGD SET:SGDParams.KEY_REPRINT_MODE withValue:_reprintMode andWithPrinterConnection:connection error:&error];
        }
        @catch(NSException *e) {
    //            Do nothing
            NSLog(@"%@", e.reason);
        }
    }
}

- (NSDictionary *) toMap {
    id objects[] = {
        _darkness,
        _printSpeed,
        _tearOff,
        _mediaType,
        _printMethod,
        _printWidth,
        _labelLength,
        _labelLengthMax,
        _zplMode,
        _powerUpAction,
        _headCloseAction,
        _labelTop,
        _leftPosition,
        _printMode,
        _reprintMode,
        _printerModelName,
        _deviceFriendlyName,
        _firmware,
        _linkOSVersion,
        _printerDpi,
    };
    id keys[] = {
        FIELD_DARKNESS,
        FIELD_PRINT_SPEED,
        FIELD_TEAR_OFF,
        FIELD_MEDIA_TYPE,
        FIELD_PRINT_METHOD,
        FIELD_PRINT_WIDTH,
        FIELD_LABEL_LENGTH,
        FIELD_LABEL_LENGTH_MAX,
        FIELD_ZPL_MODE,
        FIELD_POWER_UP_ACTION,
        FIELD_HEAD_CLOSE_ACTION,
        FIELD_LABEL_TOP,
        FIELD_LEFT_POSITION,
        FIELD_PRINT_MODE,
        FIELD_REPRINT_MODE,
        FIELD_PRINTER_MODEL_NAME,
        FIELD_DEVICE_FRIENDLY_NAME,
        FIELD_FIRMWARE,
        FIELD_LINK_OS_VERSION,
        FIELD_PRINTER_DPI,
    };
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSDictionary *map = [NSDictionary dictionaryWithObjects:objects forKeys:keys count:count];
    return map;
}

+ (PrinterSettings *)get:(id<ZebraPrinterConnection,NSObject>)connection {
    if(![ObjectUtils isNull:connection]) {
        @try {
            if(![connection isConnected]) [connection open];
            NSError *error = nil;
            
            PrinterSettings *settings = [[PrinterSettings alloc]
               initWithValues:[SGD GET:SGDParams.KEY_PRINTER_MODEL_NAME withPrinterConnection:connection error:&error]
               deviceFriendlyName:[SGD GET:SGDParams.KEY_DEVICE_FRIENDLY_NAME withPrinterConnection:connection error:&error]
               firmware:[SGD GET:SGDParams.KEY_FIRMWARE withPrinterConnection:connection error:&error]
               linkOSVersion:[SGD GET:SGDParams.KEY_LINK_OS_VERSION withPrinterConnection:connection error:&error]
               printerDpi:[SGD GET:SGDParams.KEY_PRINTER_DPI withPrinterConnection:connection error:&error]
            ];
            
            settings.darkness = [SGD GET:SGDParams.KEY_DARKNESS withPrinterConnection:connection error:&error];
            settings.printSpeed = [SGD GET:SGDParams.KEY_PRINT_SPEED withPrinterConnection:connection error:&error];
            settings.tearOff = [SGD GET:SGDParams.KEY_TEAR_OFF withPrinterConnection:connection error:&error];
            settings.mediaType = [SGD GET:SGDParams.KEY_MEDIA_TYPE withPrinterConnection:connection error:&error];
            settings.printMethod = [SGD GET:SGDParams.KEY_PRINT_METHOD withPrinterConnection:connection error:&error];
            settings.printWidth = [SGD GET:SGDParams.KEY_PRINT_WIDTH withPrinterConnection:connection error:&error];
            settings.labelLength = [SGD GET:SGDParams.KEY_LABEL_LENGTH withPrinterConnection:connection error:&error];
            settings.labelLengthMax = [SGD GET:SGDParams.KEY_LABEL_LENGTH_MAX withPrinterConnection:connection error:&error];
            settings.zplMode = [SGD GET:SGDParams.KEY_ZPL_MODE withPrinterConnection:connection error:&error];
            settings.powerUpAction = [SGD GET:SGDParams.KEY_POWER_UP_ACTION withPrinterConnection:connection error:&error];
            settings.headCloseAction = [SGD GET:SGDParams.KEY_HEAD_CLOSE_ACTION withPrinterConnection:connection error:&error];
            settings.labelTop = [SGD GET:SGDParams.KEY_LABEL_TOP withPrinterConnection:connection error:&error];
            settings.leftPosition = [SGD GET:SGDParams.KEY_LEFT_POSITION withPrinterConnection:connection error:&error];
            settings.printMode = [SGD GET:SGDParams.KEY_PRINT_MODE withPrinterConnection:connection error:&error];
            settings.reprintMode = [SGD GET:SGDParams.KEY_REPRINT_MODE withPrinterConnection:connection error:&error];
            
            return settings;
        }
        @catch(NSException *e) {
    //            Do nothing
            NSLog(@"%@", e.reason);
        }
    }
    return nil;
}


@end
