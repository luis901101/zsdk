//
//  PrinterConf.h
//  zsdk
//
//  Created by Luis on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "Orientation.h"
#import "ZebraPrinterConnection.h"
#import "SGD.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterConf : NSObject
@property double cmWidth, cmHeight;
@property double width, height;
@property double dpi;
@property Orientation orientation;

- (id) initWithCmWidth:(id)cmWidth cmHeight:(id)cmHeight dpi:(id)dpi orientation:(id)orientation;
- (void) initValues: (id<ZebraPrinterConnection, NSObject>)connection;
/**
 * cm the amount of centimeters to convert to pixels
 * @param cm The amount of centimeters to convert to pixels
 * @param dpi The pixel density or dots per inch to take into account in the conversion
 * @return The amount of pixels equivalent to the cm in the specified dpi
 * */
- (double) convertCmToPx:(double)cm dpi:(double)dpi;

@end

NS_ASSUME_NONNULL_END
