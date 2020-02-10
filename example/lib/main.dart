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
  PrintStatus printStatus = PrintStatus.NONE;
  CheckingStatus checkingStatus = CheckingStatus.NONE;
  SettingsStatus settingsStatus = SettingsStatus.NONE;
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
                                      File zplFile = File(filePath);
                                      if(await zplFile.exists()){
                                        zplData = await zplFile.readAsString();
                                      }
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
                                  child: Text("Check printer status".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  onPressed: printStatus == PrintStatus.PRINTING ? null : () => onClick(btnCheckPrinterStatus),
                                ),
                              ),
                              VerticalDivider(color: Colors.transparent,),
                              Expanded(
                                child: RaisedButton(
                                  child: Text("Get printer settings".toUpperCase(), textAlign: TextAlign.center,),
                                  color: Colors.orange,
                                  textColor: Colors.white,
                                  onPressed: printStatus == PrintStatus.PRINTING ? null : () => onClick(btnGetPrinterSettings),
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
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          onPressed: printStatus == PrintStatus.PRINTING ? null : () => onClick(btnPrintZplOverTCPIP),
                        ),
                      ),
                      VerticalDivider(color: Colors.transparent,),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Print pdf".toUpperCase(), textAlign: TextAlign.center,),
                          color: Theme.of(context).accentColor,
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
      case SettingsStatus.GETTING: return Colors.blue;
      case SettingsStatus.SUCCESS: return Colors.green;
      case SettingsStatus.ERROR: return Colors.red;
      default: return Colors.black;
    }
  }

  onClick(String id) {
    try{
      switch(id){
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
