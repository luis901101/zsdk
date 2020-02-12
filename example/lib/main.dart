import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zsdk/zsdk.dart' as Printer;
import 'dart:io';

void main() => runApp(MyApp());

const String btnPrintPdfOverTCPIP = 'btnPrintPdfOverTCPIP';
const String btnPrintZplOverTCPIP = 'btnPrintZplOverTCPIP';
const String btnCheckPrinterStatus = 'btnCheckPrinterStatus';
const String btnGetPrinterSettings = 'btnGetPrinterSettings';
const String btnSetPrinterSettings = 'btnSetPrinterSettings';
const String btnDoManualCalibration = 'btnDoManualCalibration';

class MyApp extends StatefulWidget {
  Printer.ZSDK zsdk = Printer.ZSDK();

  @override
  _MyAppState createState() => _MyAppState();
}

enum PrintStatus {
  PRINTING,
  SUCCESS,
  ERROR,
  NONE,
}

enum CheckingStatus {
  CHECKING,
  SUCCESS,
  ERROR,
  NONE,
}

enum SettingsStatus {
  GETTING,
  SETTING,
  SUCCESS,
  ERROR,
  NONE,
}

enum CalibrationStatus {
  CALIBRATING,
  SUCCESS,
  ERROR,
  NONE,
}

class _MyAppState extends State<MyApp> {
  final addressIpController = TextEditingController();
  final addressPortController = TextEditingController();
  final pathController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final dpiController = TextEditingController();
  Printer.Orientation printerOrientation = Printer.Orientation.LANDSCAPE;
  String message;
  String statusMessage;
  String settingsMessage;
  String calibrationMessage;
  PrintStatus printStatus = PrintStatus.NONE;
  CheckingStatus checkingStatus = CheckingStatus.NONE;
  SettingsStatus settingsStatus = SettingsStatus.NONE;
  CalibrationStatus calibrationStatus = CalibrationStatus.NONE;
  String filePath;
  String zplData;

  @override
  void initState() {
    super.initState();
    addressIpController.text = "10.0.1.100";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text('Zebra SDK Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(8),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Print file over TCP/IP', style: TextStyle(fontSize: 18),),
                  Divider(color: Colors.transparent,),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text('File to print', style: TextStyle(fontSize: 16),),
                          TextField(
                            controller: pathController,
                            decoration: InputDecoration(
                                labelText: "File path"
                            ),
                          ),
                          Divider(color: Colors.transparent,),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Pick .zpl file".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    try{
                                      filePath = await FilePicker.getFilePath(type: FileType.ANY);
                                      setState(() {
                                        pathController.text = filePath;
                                      });
                                    } catch(e){
                                      Fluttertoast.showToast(msg: e.toString());
                                    }
                                  },
                                ),
                              ),
                              VerticalDivider(color: Colors.transparent,),
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Pick .pdf file".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.lightGreen,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    try{
                                      filePath = await FilePicker.getFilePath(type: FileType.ANY);
                                      setState(() {
                                        pathController.text = filePath;
                                      });
                                    } catch(e){
                                      Fluttertoast.showToast(msg: e.toString());
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text('Printer address', style: TextStyle(fontSize: 16),),
                          TextField(
                            controller: addressIpController,
                            decoration: InputDecoration(
                                labelText: "Printer IP address"
                            ),
                          ),
                          TextField(
                            controller: addressPortController,
                            decoration: InputDecoration(
                                labelText: "Printer port (defaults to 9100)"
                            ),
                          ),
                          Divider(color: Colors.transparent,),
                          Visibility(
                            child: Column(
                              children: <Widget>[
                                Text("$statusMessage",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getCheckStatusColor(checkingStatus)),
                                ),
                                Divider(color: Colors.transparent,),
                              ],
                            ),
                            visible: checkingStatus != CheckingStatus.NONE,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Check printer status".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  onPressed: checkingStatus == CheckingStatus.CHECKING ? null : () => onClick(btnCheckPrinterStatus),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text('Printer settings', style: TextStyle(fontSize: 16),),
                          TextField(
                            controller: addressIpController,
                            decoration: InputDecoration(
                                labelText: "Printer IP address"
                            ),
                          ),
                          TextField(
                            controller: addressPortController,
                            decoration: InputDecoration(
                                labelText: "Printer port (defaults to 9100)"
                            ),
                          ),
                          Divider(color: Colors.transparent,),
                          Visibility(
                            child: Column(
                              children: <Widget>[
                                Text("$settingsMessage",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getSettingsStatusColor(settingsStatus)),
                                ),
                                Divider(color: Colors.transparent,),
                              ],
                            ),
                            visible: settingsStatus != SettingsStatus.NONE,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Set settings".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.deepPurple,
                                  textColor: Colors.white,
                                  onPressed: settingsStatus == SettingsStatus.SETTING || settingsStatus == SettingsStatus.GETTING ? null : () => onClick(btnSetPrinterSettings),
                                ),
                              ),
                              VerticalDivider(color: Colors.transparent,),
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Get settings".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.purple,
                                  textColor: Colors.white,
                                  onPressed: settingsStatus == SettingsStatus.SETTING || settingsStatus == SettingsStatus.GETTING ? null : () => onClick(btnGetPrinterSettings),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text('Printer calibration', style: TextStyle(fontSize: 16),),
                          Divider(color: Colors.transparent,),
                          Visibility(
                            child: Column(
                              children: <Widget>[
                                Text("$calibrationMessage",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getCalibrationStatusColor(calibrationStatus)),
                                ),
                                Divider(color: Colors.transparent,),
                              ],
                            ),
                            visible: calibrationStatus != CalibrationStatus.NONE,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: RaisedButton(
                                  child: Text("DO MANUAL CALIBRATION".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.blueGrey,
                                  textColor: Colors.white,
                                  onPressed: calibrationStatus == CalibrationStatus.CALIBRATING ? null : () => onClick(btnDoManualCalibration),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          Text('PDF print configurations', style: TextStyle(fontSize: 16),),
                          TextField(
                            controller: widthController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                labelText: "Paper width in cm (defaults to 15.20 cm)"
                            ),
                          ),
                          TextField(
                            controller: heightController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                labelText: "Paper height in cm (defaults to 7.00 cm)"
                            ),
                          ),
                          TextField(
                            controller: dpiController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                labelText: "Printer density per inch (defaults to 203 dpi)"
                            ),
                          ),
                          DropdownButtonFormField<Printer.Orientation>(
                            items: [
                              DropdownMenuItem(child: Text("Portrait"), value: Printer.Orientation.PORTRAIT,),
                              DropdownMenuItem(child: Text("Landscape"), value: Printer.Orientation.LANDSCAPE,)
                            ],
                            value: printerOrientation,
                            onChanged: (value) => setState(() => printerOrientation = value),
                            decoration: InputDecoration(
                                labelText: "Print orientation"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.transparent,),
                  Visibility(
                    child: Column(
                      children: <Widget>[
                        Text("$message",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getPrintStatusColor(printStatus)),
                        ),
                        Divider(color: Colors.transparent,),
                      ],
                    ),
                    visible: printStatus != PrintStatus.NONE,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Print zpl".toUpperCase(), textAlign: TextAlign.center,),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: printStatus == PrintStatus.PRINTING ? null : () => onClick(btnPrintZplOverTCPIP),
                        ),
                      ),
                      VerticalDivider(color: Colors.transparent,),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Print pdf".toUpperCase(), textAlign: TextAlign.center,),
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          onPressed: printStatus == PrintStatus.PRINTING ? null : () => onClick(btnPrintPdfOverTCPIP),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.transparent, height: 100,),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  Color getPrintStatusColor(PrintStatus status){
    switch(status){
      case PrintStatus.PRINTING: return Colors.blue;
      case PrintStatus.SUCCESS: return Colors.green;
      case PrintStatus.ERROR: return Colors.red;
      default: return Colors.black;
    }
  }

  Color getCheckStatusColor(CheckingStatus status){
    switch(status){
      case CheckingStatus.CHECKING: return Colors.blue;
      case CheckingStatus.SUCCESS: return Colors.green;
      case CheckingStatus.ERROR: return Colors.red;
      default: return Colors.black;
    }
  }

  Color getSettingsStatusColor(SettingsStatus status){
    switch(status){
      case SettingsStatus.GETTING:
      case SettingsStatus.SETTING: return Colors.blue;
      case SettingsStatus.SUCCESS: return Colors.green;
      case SettingsStatus.ERROR: return Colors.red;
      default: return Colors.black;
    }
  }

  Color getCalibrationStatusColor(CalibrationStatus status){
    switch(status){
      case CalibrationStatus.CALIBRATING: return Colors.blue;
      case CalibrationStatus.SUCCESS: return Colors.green;
      case CalibrationStatus.ERROR: return Colors.red;
      default: return Colors.black;
    }
  }

  onClick(String id) async {
    try{
      switch(id){
        case btnDoManualCalibration:
          setState(() {
            calibrationMessage = "Getting printer settings...";
            calibrationStatus = CalibrationStatus.CALIBRATING;
          });
          widget.zsdk.doManualCalibrationOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          ).then((value){
            setState(() {
              calibrationStatus = CalibrationStatus.SUCCESS;
              calibrationMessage = "$value";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterResponse printerResponse;
              try{
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                calibrationMessage = "${printerResponse?.message} ${printerResponse?.errorCode} ${printerResponse?.statusInfo?.status} ${printerResponse?.statusInfo?.cause} \n"
                    "${printerResponse?.settings?.toString()}";
              }catch(e){
                print(e);
                calibrationMessage = "${e?.toString()}";
              }
            } on MissingPluginException catch(e) {
              calibrationMessage = "${e?.message}";
            } catch (e){
              calibrationMessage = "${e?.toString()}";
            }
            setState(() {
              calibrationStatus = CalibrationStatus.ERROR;
            });
          });
          break;
        case btnGetPrinterSettings:
          setState(() {
            settingsMessage = "Getting printer settings...";
            settingsStatus = SettingsStatus.GETTING;
          });
          widget.zsdk.getPrinterSettingsOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          ).then((value){
            setState(() {
              settingsStatus = SettingsStatus.SUCCESS;
              settingsMessage = "$value";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterResponse printerResponse;
              try{
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                settingsMessage = "${printerResponse?.message} ${printerResponse?.errorCode} ${printerResponse?.statusInfo?.status} ${printerResponse?.statusInfo?.cause} \n"
                    "${printerResponse?.settings?.toString()}";
              }catch(e){
                print(e);
                settingsMessage = "${e?.toString()}";
              }
            } on MissingPluginException catch(e) {
              settingsMessage = "${e?.message}";
            } catch (e){
              settingsMessage = "${e?.toString()}";
            }
            setState(() {
              settingsStatus = SettingsStatus.ERROR;
            });
          });
          break;
        case btnSetPrinterSettings:
          setState(() {
            settingsMessage = "Setting printer settings...";
            settingsStatus = SettingsStatus.SETTING;
          });
          widget.zsdk.setPrinterSettingsOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
            settings: Printer.PrinterSettings(
              darkness: 10, //10
              printSpeed: 6, //6
              tearOff: 0,//0
              mediaType: Printer.MediaType.MARK, //MARK
              printMethod: Printer.PrintMethod.DIRECT_THERMAL, //DIRECT_THERMAL
              printWidth: 568,//600
              labelLength: 1202,//1202
              labelLengthMax: 39,//39
              zplMode: Printer.ZPLMode.ZPL_II,//ZPL II
              powerUpAction: Printer.PowerUpAction.NO_MOTION,//NO MOTION
              headCloseAction: Printer.HeadCloseAction.FEED,//FEED
              labelTop: 0,//0
              leftPosition: 0,//0
              printMode: Printer.PrintMode.TEAR_OFF,//TEAR_OFF
              reprintMode: Printer.ReprintMode.OFF,//OFF
            )
//            settings: Printer.PrinterSettings(
//              darkness: 30, //10
//              printSpeed: 3, //6
//              tearOff: 100,//0
//              mediaType: Printer.MediaType.CONTINUOUS, //MARK
//              printMethod: Printer.PrintMethod.THERMAL_TRANS, //DIRECT_THERMAL
//              printWidth: 568,//600
//              labelLength: 1000,//1202
//              labelLengthMax: 30,//39
//              zplMode: Printer.ZPLMode.ZPL,//ZPL II
//              powerUpAction: Printer.PowerUpAction.FEED,//NO MOTION
//              headCloseAction: Printer.HeadCloseAction.NO_MOTION,//FEED
//              labelTop: 50,//0
//              leftPosition: 100,//0
//              printMode: Printer.PrintMode.CUTTER,//TEAR_OFF
//              reprintMode: Printer.ReprintMode.ON,//OFF
//            )
          ).then((value){
            setState(() {
              settingsStatus = SettingsStatus.SUCCESS;
              settingsMessage = "$value";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterResponse printerResponse;
              try{
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                settingsMessage = "${printerResponse?.message} ${printerResponse?.errorCode} ${printerResponse?.statusInfo?.status} ${printerResponse?.statusInfo?.cause} \n"
                    "${printerResponse?.settings?.toString()}";
              }catch(e){
                print(e);
                settingsMessage = "${e?.toString()}";
              }
            } on MissingPluginException catch(e) {
              settingsMessage = "${e?.message}";
            } catch (e){
              settingsMessage = "${e?.toString()}";
            }
            setState(() {
              settingsStatus = SettingsStatus.ERROR;
            });
          });
          break;
        case btnCheckPrinterStatus:
          setState(() {
            statusMessage = "Checking printer status...";
            checkingStatus = CheckingStatus.CHECKING;
          });
          widget.zsdk.checkPrinterStatusOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          ).then((value){
            setState(() {
              checkingStatus = CheckingStatus.SUCCESS;
              statusMessage = "$value";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterResponse printerResponse;
              try{
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                statusMessage = "${printerResponse?.message} ${printerResponse?.errorCode} ${printerResponse?.statusInfo?.status} ${printerResponse?.statusInfo?.cause}";
              }catch(e){
                print(e);
                statusMessage = "${e?.toString()}";
              }
            } on MissingPluginException catch(e) {
              statusMessage = "${e?.message}";
            } catch (e){
              statusMessage = "${e?.toString()}";
            }
            setState(() {
              checkingStatus = CheckingStatus.ERROR;
            });
          });
          break;
        case btnPrintPdfOverTCPIP:
          if(Platform.isIOS) throw Exception("Not implemented for iOS");
          if(pathController.text == null || !pathController.text.endsWith(".pdf"))
            throw Exception("Make sure you properly write the path or selected a proper pdf file");
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk.printPdfFileOverTCPIP(
            filePath: pathController.text,
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
            printerConf: Printer.PrinterConf(
              cmWidth: double.tryParse(widthController.text),
              cmHeight: double.tryParse(heightController.text),
              dpi: double.tryParse(dpiController.text),
              orientation: printerOrientation,
            )
          )
          .then((value){
            setState(() {
              printStatus = PrintStatus.SUCCESS;
              message = "$value";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterResponse printerResponse;
              try{
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                message = "${printerResponse?.message} ${printerResponse?.errorCode} ${printerResponse?.statusInfo?.status} ${printerResponse?.statusInfo?.cause}";
              }catch(e){
                print(e);
                message = "${e?.toString()}";
              }
            } on MissingPluginException catch(e) {
              message = "${e?.message}";
            } catch (e){
              message = "${e?.toString()}";
            }
            setState(() {
              printStatus = PrintStatus.ERROR;
            });
          });
          break;
        case btnPrintZplOverTCPIP:
          if(pathController.text == null || !pathController.text.endsWith(".zpl"))
            throw Exception("Make sure you properly write the path or selected a proper zpl file");
          File zplFile = File(filePath);
          if(await zplFile.exists()){
            zplData = await zplFile.readAsString();
          }
          if(zplData == null || zplData.isEmpty)
            throw Exception("Make sure you properly write the path or selected a proper zpl file");
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk.printZplDataOverTCPIP(
            data: zplData,
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
            printerConf: Printer.PrinterConf(
              cmWidth: double.tryParse(widthController.text),
              cmHeight: double.tryParse(heightController.text),
              dpi: double.tryParse(dpiController.text),
              orientation: printerOrientation,
            )
          )
          .then((value){
            setState(() {
              printStatus = PrintStatus.SUCCESS;
                message = "$value";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterResponse printerResponse;
              try{
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                message = "${printerResponse?.message} ${printerResponse?.errorCode} ${printerResponse?.statusInfo?.status} ${printerResponse?.statusInfo?.cause}";
              }catch(e){
                print(e);
                message = "${e?.toString()}";
              }
            } on MissingPluginException catch(e) {
              message = "${e?.message}";
            } catch (e){
              message = "${e?.toString()}";
            }
            setState(() {
              printStatus = PrintStatus.ERROR;
            });
          });
          break;
      }
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "${e?.toString()}");
    }
  }
}