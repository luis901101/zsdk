import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zsdk/zsdk.dart' as Printer;
import 'dart:io';

void main() => runApp(MyApp());

const String btnPrintPdfOverTCPIP = 'btnPrintPdfOverTCPIP';
const String btnPrintZplOverTCPIP = 'btnPrintZplOverTCPIP';

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

class _MyAppState extends State<MyApp> {
  final addressIpController = TextEditingController();
  final addressPortController = TextEditingController();
  final pathController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final dpiController = TextEditingController();
  Printer.Orientation printerOrientation = Printer.Orientation.LANDSCAPE;
  String message;
  PrintStatus printStatus = PrintStatus.NONE;

  @override
  void initState() {
    super.initState();
    pathController.text = "/sdcard/ticket.pdf";
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
                          Text('Print configurations', style: TextStyle(fontSize: 16),),
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
                          child: Text("Print zpl".toUpperCase()),
                          color: Theme.of(context).accentColor,
                          textColor: Colors.white,
                          onPressed: printStatus == PrintStatus.PRINTING ? null : () => onClick(btnPrintZplOverTCPIP),
                        ),
                      ),
                      VerticalDivider(color: Colors.transparent,),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Print pdf".toUpperCase()),
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

  Color getPrintStatusColor(PrintStatus printStatus){
    switch(printStatus){
      case PrintStatus.PRINTING: return Colors.blue;
      case PrintStatus.SUCCESS: return Colors.green;
      case PrintStatus.ERROR: return Colors.red;
      default: return Colors.black;
    }
  }

  onClick(String id) {
    try{
      switch(id){
        case btnPrintPdfOverTCPIP:
          if(pathController.text == null || !pathController.text.endsWith(".pdf"))
            throw Exception("Make sure you write the path of a proper pdf file");
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk.printPdfOverTCPIP(
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
              if(Platform.isIOS){
                message = "$value";
              } else
              message = "Successful print";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterErrorDetails printerErrorDetails;
              try{
                printerErrorDetails = Printer.PrinterErrorDetails.fromMap(e.details);
                message = "${printerErrorDetails?.message} ${printerErrorDetails?.statusInfo?.status} ${printerErrorDetails?.statusInfo?.cause}";
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
            throw Exception("Make sure you write the path of a proper zpl file");
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk.printZplOverTCPIP(
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
              if(Platform.isIOS){
                message = "$value";
              } else
                message = "Successful print";
            });
          }, onError: (error, stacktrace){
            try{
              throw error;
            } on PlatformException catch(e) {
              Printer.PrinterErrorDetails printerErrorDetails;
              try{
                printerErrorDetails = Printer.PrinterErrorDetails.fromMap(e.details);
                message = "${printerErrorDetails?.message} ${printerErrorDetails?.statusInfo?.status} ${printerErrorDetails?.statusInfo?.cause}";
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
