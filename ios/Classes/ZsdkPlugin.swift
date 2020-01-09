import Flutter
import UIKit

/* ZsdkPlugin */
public class SwiftZsdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        _ = SwiftZsdkPlugin(registrar: registrar)
    }
    
    /** Channel */
    let _METHOD_CHANNEL = "zsdk";

    /** Methods */
    let _PRINT_PDF_OVER_TCP_IP = "printPdfOverTCPIP"
    let _PRINT_ZPL_OVER_TCP_IP = "printZplOverTCPIP"

    /** Properties */
    let _filePath = "filePath"
    let _address = "address"
    let _port = "port"
    let _cmWidth = "cmWidth"
    let _cmHeight = "cmHeight"
    let _orientation = "orientation"
    let _dpi = "dpi"
    
    let channel : FlutterMethodChannel
    
    init(registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: _METHOD_CHANNEL, binaryMessenger: registrar.messenger())
        super.init()
        registrar.addMethodCallDelegate(self, channel: channel)
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
        switch call.method {
            case _PRINT_PDF_OVER_TCP_IP:
                result("Print pdf over tcp ip ")
            case _PRINT_ZPL_OVER_TCP_IP:
                result("Print zpl over tcp ip ")
            default:
//                result("iOS " + UIDevice.current.systemVersion)
                result(FlutterMethodNotImplemented)
        }
    } catch {
        result(FlutterError(code: ErrorCode.EXCEPTION.rawValue, message: "Unknown error", details: nil))
    }
  }
}
