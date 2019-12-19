import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zsdk/zsdk.dart';

void main() => runApp(MyApp());

const String btnPrintFileOverTCPIP = 'btnPrintFileOverTCPIP';

class MyApp extends StatefulWidget {
  ZSDK zsdk = ZSDK();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final printFileOverTCPIPController = TextEditingController();

  @override
  void initState() {
    super.initState();
    printFileOverTCPIPController.text = "/sdcard/print2.pdf";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zebra SDK Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Print file over TCP/IP'),
            TextField(
              controller: printFileOverTCPIPController,
            ),
            Divider(color: Colors.transparent,),
            RaisedButton(
              child: Text("Print"),
              onPressed: () => onClick(btnPrintFileOverTCPIP),
            ),
          ],
        ),
      ),
    );
  }

  onClick(String id) async {
    try{
      switch(id){
        case btnPrintFileOverTCPIP:
          await widget.zsdk.printPdfOverTCPIP(filePath: printFileOverTCPIPController.text, address: "10.0.1.100");
          Fluttertoast.showToast(msg: "Successful print");
          break;
      }
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "${e?.toString()}");
    }
  }

}
