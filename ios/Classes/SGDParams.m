//
//  SGDParams.m
//  zsdk
//
//  Created by Luis on 2/12/20.
//

#import "SGDParams.h"
#import "SGD.h"

@implementation SGDParams
/** Settings */

/** Writable settings */
+ (NSString*)KEY_DARKNESS {return @"print.tone";}
+ (NSString*)KEY_PRINT_SPEED {return @"media.speed";}
+ (NSString*)KEY_TEAR_OFF {return @"ezpl.tear_off";}
+ (NSString*)KEY_MEDIA_TYPE {return @"ezpl.media_type";}
+ (NSString*)KEY_PRINT_METHOD {return @"ezpl.print_method";}
+ (NSString*)KEY_PRINT_WIDTH {return @"ezpl.print_width";}
+ (NSString*)KEY_LABEL_LENGTH {return @"zpl.label_length";}
+ (NSString*)KEY_LABEL_LENGTH_MAX {return @"ezpl.label_length_max";}
+ (NSString*)KEY_ZPL_MODE {return @"zpl.zpl_mode";}
+ (NSString*)KEY_POWER_UP_ACTION {return @"ezpl.power_up_action";}
+ (NSString*)KEY_HEAD_CLOSE_ACTION {return @"ezpl.head_close_action";}
+ (NSString*)KEY_LABEL_TOP {return @"zpl.label_top";}
+ (NSString*)KEY_LEFT_POSITION {return @"zpl.left_position";}
+ (NSString*)KEY_PRINT_MODE {return @"ezpl.print_mode";}
+ (NSString*)KEY_REPRINT_MODE {return @"ezpl.reprint_mode";}
+ (NSString*)KEY_PRINTER_LANGUAGES {return @"device.languages";}

/** Read only settings */
+ (NSString*)KEY_PRINTER_MODEL_NAME {return @"ip.dhcp.vendor_class_id";}
+ (NSString*)KEY_DEVICE_FRIENDLY_NAME {return @"device.friendly_name";}
+ (NSString*)KEY_FIRMWARE {return @"appl.name";}
+ (NSString*)KEY_LINK_OS_VERSION {return @"appl.link_os_version";}
+ (NSString*)KEY_PRINTER_DPI {return @"head.resolution.in_dpi";}
+ (NSString*)KEY_DEVICE_PRINT_HEAD_RESOLUTION {return @"device.printhead.resolution";}

/** Actions */
+ (NSString*)KEY_MANUAL_CALIBRATION {return @"ezpl.manual_calibration";}
+ (NSString*)KEY_VIRTUAL_DEVICE {return @"apl.enable";}

/** Values */
+ (NSString*)VALUE_ZPL_LANGUAGE {return @"hybrid_xml_zpl";}
+ (double)VALUE_DPI_DEFAULT {return 203;}
+ (NSString*)VALUE_GET_ALL {return @"allcv";}
+ (NSString*)VALUE_PDF {return @"pdf";}
+ (NSString*)VALUE_NONE {return @"none";}

@end
