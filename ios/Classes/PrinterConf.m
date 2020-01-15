//
//  PrinterConf.m
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import "PrinterConf.h"
#import "OrientationUtils.h"

@implementation PrinterConf
NSString *PRINTER_DPI_CONF_KEY = @"head.resolution.in_dpi";
const double DEFAULT_DPI = 203;

- (id)initWithCmWidth:(id)cmWidth cmHeight:(id)cmHeight dpi:(id)dpi orientation:(id)orientation {
    self = [super init];
    if(self){
        self.cmWidth = cmWidth != nil ? [cmWidth doubleValue] : 15.20;
        self.cmHeight = cmHeight != nil ? [cmWidth doubleValue] : 7.00;
        self.dpi = dpi != nil ? [dpi doubleValue] : 0;
        self.orientation = orientation != nil ? [OrientationUtils getValueByName:[orientation stringValue]] : LANDSCAPE;
    }
    return self;
}

- (void)initValues:(id<ZebraPrinterConnection,NSObject>)connection {
    if(self.dpi == 0 && connection != nil) {
        @try {
            if(![connection isConnected]) [connection open];
            NSError *error = nil;
            const NSString *dpiAsString = [SGD GET:PRINTER_DPI_CONF_KEY withPrinterConnection:connection error:&error];
            if(dpiAsString != nil)
                self.dpi = [dpiAsString doubleValue];
        }
        @catch(NSException *e) {
//            Do nothing
            NSLog(@"%@", e.reason);
        }
    }
    if(self.dpi == 0) self.dpi = DEFAULT_DPI;
    self.width = [self convertCmToPx:self.cmWidth dpi:self.dpi];
    self.height = [self convertCmToPx:self.cmHeight dpi:self.dpi];
}

- (double)convertCmToPx:(double)cm dpi:(double)dpi{
    const double inchCm = 2.54; //One inch in centimeters
    const double pixels = (dpi / inchCm) * cm;
    return pixels;
}

@end
