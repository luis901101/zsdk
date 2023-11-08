import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:zsdk/zsdk.dart' as Printer;
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

const String btnPrintPdfFileOverTCPIP = 'btnPrintPdfFileOverTCPIP';
const String btnPrintZplFileOverTCPIP = 'btnPrintZplFileOverTCPIP';
const String btnPrintZplDataOverTCPIP = 'btnPrintZplDataOverTCPIP';
const String btnCheckPrinterStatus = 'btnCheckPrinterStatus';
const String btnGetPrinterSettings = 'btnGetPrinterSettings';
const String btnSetPrinterSettings = 'btnSetPrinterSettings';
const String btnResetPrinterSettings = 'btnResetPrinterSettings';
const String btnDoManualCalibration = 'btnDoManualCalibration';
const String btnPrintConfigurationLabel = 'btnPrintConfigurationLabel';

class MyApp extends StatefulWidget {
  final Printer.ZSDK zsdk = Printer.ZSDK();

  MyApp({Key? key}) : super(key: key);

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
  final addressIpController = TextEditingController(text: "10.0.0.11");
  final addressPortController = TextEditingController();
  final pathController = TextEditingController();
  final zplDataController = TextEditingController(
      text: '^XA^FO17,16^GB379,371,8^FS^FT65,255^A0N,135,134^FDTEST^FS^XZ');
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final dpiController = TextEditingController();

  final darknessController = TextEditingController();
  final printSpeedController = TextEditingController();
  final tearOffController = TextEditingController();
  final printWidthController = TextEditingController();
  final labelLengthController = TextEditingController();
  final labelLengthMaxController = TextEditingController();
  final labelTopController = TextEditingController();
  final leftPositionController = TextEditingController();
  Printer.MediaType? selectedMediaType;
  Printer.PrintMethod? selectedPrintMethod;
  Printer.ZPLMode? selectedZPLMode;
  Printer.PowerUpAction? selectedPowerUpAction;
  Printer.HeadCloseAction? selectedHeadCloseAction;
  Printer.PrintMode? selectedPrintMode;
  Printer.ReprintMode? selectedReprintMode;
  Printer.VirtualDevice? selectedVirtualDevice;

  Printer.PrinterSettings? settings;

  Printer.Orientation printerOrientation = Printer.Orientation.LANDSCAPE;
  String? message;
  String? statusMessage;
  String? settingsMessage;
  String? calibrationMessage;
  PrintStatus printStatus = PrintStatus.NONE;
  CheckingStatus checkingStatus = CheckingStatus.NONE;
  SettingsStatus settingsStatus = SettingsStatus.NONE;
  CalibrationStatus calibrationStatus = CalibrationStatus.NONE;
  String? filePath;
  String? zplData;

  @override
  void initState() {
    super.initState();
  }

  String getName<T>(T value) {
    String name = 'Unknown';
    if (value is Printer.HeadCloseAction) name = value.name;
    if (value is Printer.MediaType) name = value.name;
    if (value is Printer.PowerUpAction) name = value.name;
    if (value is Printer.PrintMethod) name = value.name;
    if (value is Printer.PrintMode) name = value.name;
    if (value is Printer.ReprintMode) name = value.name;
    if (value is Printer.VirtualDevice) name = value.name;
    if (value is Printer.ZPLMode) name = value.name;
    return name;
  }

  List<DropdownMenuItem<T>> generateDropdownItems<T>(List<T> values) {
    List<DropdownMenuItem<T>> items = [];
    for (var value in values) {
      items.add(DropdownMenuItem<T>(
        child: Text(getName(value)),
        value: value,
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Zebra SDK Plugin example app'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Scrollbar(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Print file over TCP/IP',
                style: TextStyle(fontSize: 18),
              ),
              const Divider(
                color: Colors.transparent,
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'File to print',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        controller: pathController,
                        decoration:
                            const InputDecoration(labelText: "File path"),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "Pick .zpl file".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: () async {
                                try {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.any);
                                  if (result != null) {
                                    filePath = result.files.single.path;
                                    if (filePath != null) {
                                      setState(() {
                                        pathController.text = filePath ?? '';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  showSnackBar(e.toString());
                                }
                              },
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.transparent,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "Pick .pdf file".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.lightGreen),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: () async {
                                try {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.any);
                                  if (result != null) {
                                    filePath = result.files.single.path;
                                    if (filePath != null) {
                                      setState(() {
                                        pathController.text = filePath ?? '';
                                      });
                                    }
                                  }
                                } catch (e) {
                                  showSnackBar(e.toString());
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
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'ZPL data to print',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        controller: zplDataController,
                        decoration:
                            const InputDecoration(labelText: "ZPL data"),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Printer address',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        controller: addressIpController,
                        decoration: const InputDecoration(
                            labelText: "Printer IP address"),
                      ),
                      TextField(
                        controller: addressPortController,
                        decoration: const InputDecoration(
                            labelText: "Printer port (defaults to 9100)"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "$statusMessage",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: getCheckStatusColor(checkingStatus)),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        visible: checkingStatus != CheckingStatus.NONE,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "Check printer status".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed:
                                  checkingStatus == CheckingStatus.CHECKING
                                      ? null
                                      : () => onClick(btnCheckPrinterStatus),
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
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          'Printer settings',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            children: [
                              const TextSpan(
                                  text: "Brand and model: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      settings?.printerModelName ?? "Unknown"),
                            ]),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 4,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            children: [
                              const TextSpan(
                                  text: "Device friendly name: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: settings?.deviceFriendlyName ??
                                      "Unknown"),
                            ]),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 4,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            children: [
                              const TextSpan(
                                  text: "Firmware: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: settings?.firmware ?? "Unknown"),
                            ]),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 4,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            children: [
                              const TextSpan(
                                  text: "Link-OS Version: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: settings?.linkOSVersion ?? "Unknown"),
                            ]),
                      ),
                      const Divider(
                        color: Colors.transparent,
                        height: 4,
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            children: [
                              const TextSpan(
                                  text: "Printer DPI: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: settings?.printerDpi ?? "Unknown"),
                            ]),
                      ),
                      RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color),
                            children: [
                              const TextSpan(
                                  text:
                                      "Resolution in dots per millimeter (dpmm): ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: settings?.devicePrintHeadResolution !=
                                          null
                                      ? "${double.tryParse(settings?.devicePrintHeadResolution ?? '')?.truncate()}dpmm"
                                      : "Unknown"),
                            ]),
                      ),
                      TextField(
                        controller: darknessController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Darkness"),
                      ),
                      TextField(
                        controller: printSpeedController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Print speed"),
                      ),
                      TextField(
                        controller: tearOffController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Tear off"),
                      ),
                      DropdownButtonFormField<Printer.MediaType>(
                        items: generateDropdownItems(Printer.MediaType.values),
                        value: selectedMediaType,
                        onChanged: (value) =>
                            setState(() => selectedMediaType = value),
                        decoration:
                            const InputDecoration(labelText: "Media type"),
                      ),
                      DropdownButtonFormField<Printer.PrintMethod>(
                        items:
                            generateDropdownItems(Printer.PrintMethod.values),
                        value: selectedPrintMethod,
                        onChanged: (value) =>
                            setState(() => selectedPrintMethod = value),
                        decoration:
                            const InputDecoration(labelText: "Print method"),
                      ),
                      TextField(
                        controller: printWidthController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Print width"),
                      ),
                      TextField(
                        controller: labelLengthController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: false),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Label length"),
                      ),
                      TextField(
                        controller: labelLengthMaxController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            labelText: "Label length max"),
                      ),
                      DropdownButtonFormField<Printer.ZPLMode>(
                        items: generateDropdownItems(Printer.ZPLMode.values),
                        value: selectedZPLMode,
                        onChanged: (value) =>
                            setState(() => selectedZPLMode = value),
                        decoration:
                            const InputDecoration(labelText: "ZPL mode"),
                      ),
                      DropdownButtonFormField<Printer.PowerUpAction>(
                        items:
                            generateDropdownItems(Printer.PowerUpAction.values),
                        value: selectedPowerUpAction,
                        onChanged: (value) =>
                            setState(() => selectedPowerUpAction = value),
                        decoration:
                            const InputDecoration(labelText: "Power up action"),
                      ),
                      DropdownButtonFormField<Printer.HeadCloseAction>(
                        items: generateDropdownItems(
                            Printer.HeadCloseAction.values),
                        value: selectedHeadCloseAction,
                        onChanged: (value) =>
                            setState(() => selectedHeadCloseAction = value),
                        decoration: const InputDecoration(
                            labelText: "Head close action"),
                      ),
                      TextField(
                        controller: labelTopController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Label top"),
                      ),
                      TextField(
                        controller: leftPositionController,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: false),
                        textInputAction: TextInputAction.done,
                        decoration:
                            const InputDecoration(labelText: "Left position"),
                      ),
                      DropdownButtonFormField<Printer.PrintMode>(
                        items: generateDropdownItems(Printer.PrintMode.values),
                        value: selectedPrintMode,
                        onChanged: (value) =>
                            setState(() => selectedPrintMode = value),
                        decoration:
                            const InputDecoration(labelText: "Print mode"),
                      ),
                      DropdownButtonFormField<Printer.ReprintMode>(
                        items:
                            generateDropdownItems(Printer.ReprintMode.values),
                        value: selectedReprintMode,
                        onChanged: (value) =>
                            setState(() => selectedReprintMode = value),
                        decoration:
                            const InputDecoration(labelText: "Reprint mode"),
                      ),
                      DropdownButtonFormField<Printer.VirtualDevice>(
                        items:
                            generateDropdownItems(Printer.VirtualDevice.values),
                        value: selectedVirtualDevice,
                        onChanged: (value) =>
                            setState(() => selectedVirtualDevice = value),
                        decoration:
                            const InputDecoration(labelText: "Virtual device"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "$settingsMessage",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      getSettingsStatusColor(settingsStatus)),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        visible: settingsStatus != SettingsStatus.NONE,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "Set settings".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepPurple),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: settingsStatus ==
                                          SettingsStatus.SETTING ||
                                      settingsStatus == SettingsStatus.GETTING
                                  ? null
                                  : () => onClick(btnSetPrinterSettings),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.transparent,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "Get settings".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.purple),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: settingsStatus ==
                                          SettingsStatus.SETTING ||
                                      settingsStatus == SettingsStatus.GETTING
                                  ? null
                                  : () => onClick(btnGetPrinterSettings),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "Reset settings".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.pink),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: settingsStatus ==
                                          SettingsStatus.SETTING ||
                                      settingsStatus == SettingsStatus.GETTING
                                  ? null
                                  : () => onClick(btnResetPrinterSettings),
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
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Printer calibration',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Visibility(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "$calibrationMessage",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: getCalibrationStatusColor(
                                      calibrationStatus)),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                        visible: calibrationStatus != CalibrationStatus.NONE,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                "DO MANUAL CALIBRATION".toUpperCase(),
                                textAlign: TextAlign.center,
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueGrey),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(color: Colors.white))),
                              onPressed: calibrationStatus ==
                                      CalibrationStatus.CALIBRATING
                                  ? null
                                  : () => onClick(btnDoManualCalibration),
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
                margin: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'PDF print configurations',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextField(
                        controller: widthController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText:
                                "Paper width in cm (defaults to 15.20 cm)"),
                      ),
                      TextField(
                        controller: heightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText:
                                "Paper height in cm (defaults to 7.00 cm)"),
                      ),
                      TextField(
                        controller: dpiController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText:
                                "Printer density per inch (defaults to 203 dpi)"),
                      ),
                      DropdownButtonFormField<Printer.Orientation>(
                        items: const [
                          DropdownMenuItem(
                            child: Text("Portrait"),
                            value: Printer.Orientation.PORTRAIT,
                          ),
                          DropdownMenuItem(
                            child: Text("Landscape"),
                            value: Printer.Orientation.LANDSCAPE,
                          )
                        ],
                        value: printerOrientation,
                        onChanged: (value) => setState(() =>
                            printerOrientation =
                                value ?? Printer.Orientation.LANDSCAPE),
                        decoration: const InputDecoration(
                            labelText: "Print orientation"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Visibility(
                child: Column(
                  children: <Widget>[
                    Text(
                      "$message",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: getPrintStatusColor(printStatus)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                visible: printStatus != PrintStatus.NONE,
              ),
              ElevatedButton(
                child: Text(
                  "Test Print".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white))),
                onPressed: printStatus == PrintStatus.PRINTING
                    ? null
                    : () => onClick(btnPrintConfigurationLabel),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        "Print zpl from file".toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(color: Colors.white))),
                      onPressed: printStatus == PrintStatus.PRINTING
                          ? null
                          : () => onClick(btnPrintZplFileOverTCPIP),
                    ),
                  ),
                  const VerticalDivider(
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        "Print pdf from file".toUpperCase(),
                        textAlign: TextAlign.center,
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightBlue),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(color: Colors.white))),
                      onPressed: printStatus == PrintStatus.PRINTING
                          ? null
                          : () => onClick(btnPrintPdfFileOverTCPIP),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                child: Text(
                  "Print zpl data".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.white))),
                onPressed: printStatus == PrintStatus.PRINTING
                    ? null
                    : () => onClick(btnPrintZplDataOverTCPIP),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        )),
      ),
    );
  }

  Color getPrintStatusColor(PrintStatus status) {
    switch (status) {
      case PrintStatus.PRINTING:
        return Colors.blue;
      case PrintStatus.SUCCESS:
        return Colors.green;
      case PrintStatus.ERROR:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Color getCheckStatusColor(CheckingStatus status) {
    switch (status) {
      case CheckingStatus.CHECKING:
        return Colors.blue;
      case CheckingStatus.SUCCESS:
        return Colors.green;
      case CheckingStatus.ERROR:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Color getSettingsStatusColor(SettingsStatus status) {
    switch (status) {
      case SettingsStatus.GETTING:
      case SettingsStatus.SETTING:
        return Colors.blue;
      case SettingsStatus.SUCCESS:
        return Colors.green;
      case SettingsStatus.ERROR:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Color getCalibrationStatusColor(CalibrationStatus status) {
    switch (status) {
      case CalibrationStatus.CALIBRATING:
        return Colors.blue;
      case CalibrationStatus.SUCCESS:
        return Colors.green;
      case CalibrationStatus.ERROR:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void updateSettings(Printer.PrinterSettings? newSettings) {
    settings = newSettings;

    darknessController.text = "${settings?.darkness ?? ""}";
    printSpeedController.text = "${settings?.printSpeed ?? ""}";
    tearOffController.text = "${settings?.tearOff ?? ""}";
    printWidthController.text = "${settings?.printWidth ?? ""}";
    labelLengthController.text = "${settings?.labelLength ?? ""}";
    labelLengthMaxController.text = "${settings?.labelLengthMax ?? ""}";
    labelTopController.text = "${settings?.labelTop ?? ""}";
    leftPositionController.text = "${settings?.leftPosition ?? ""}";
    selectedMediaType = settings?.mediaType;
    selectedPrintMethod = settings?.printMethod;
    selectedZPLMode = settings?.zplMode;
    selectedPowerUpAction = settings?.powerUpAction;
    selectedHeadCloseAction = settings?.headCloseAction;
    selectedPrintMode = settings?.printMode;
    selectedReprintMode = settings?.reprintMode;
    selectedVirtualDevice = settings?.virtualDevice;
  }

  onClick(String id) async {
    try {
      switch (id) {
        case btnDoManualCalibration:
          setState(() {
            calibrationMessage = "Starting manual callibration...";
            calibrationStatus = CalibrationStatus.CALIBRATING;
          });
          widget.zsdk
              .doManualCalibrationOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          )
              .then((value) {
            setState(() {
              calibrationStatus = CalibrationStatus.SUCCESS;
              calibrationMessage = "$value";
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                calibrationMessage =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n"
                    "${printerResponse.settings?.toString()}";
              } catch (e) {
                print(e);
                calibrationMessage = e.toString();
              }
            } on MissingPluginException catch (e) {
              calibrationMessage = "${e.message}";
            } catch (e) {
              calibrationMessage = e.toString();
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
          widget.zsdk
              .getPrinterSettingsOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          )
              .then((value) {
            setState(() {
              settingsStatus = SettingsStatus.SUCCESS;
              settingsMessage = "$value";
              updateSettings((Printer.PrinterResponse.fromMap(value)).settings);
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                settingsMessage =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n"
                    "${printerResponse.settings?.toString()}";
              } catch (e) {
                print(e);
                settingsMessage = e.toString();
              }
            } on MissingPluginException catch (e) {
              settingsMessage = "${e.message}";
            } catch (e) {
              settingsMessage = e.toString();
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
          widget.zsdk
              .setPrinterSettingsOverTCPIP(
                  address: addressIpController.text,
                  port: int.tryParse(addressPortController.text),
                  settings: Printer.PrinterSettings(
                    darkness: double.tryParse(darknessController.text),
                    printSpeed: double.tryParse(printSpeedController.text),
                    tearOff: int.tryParse(tearOffController.text),
                    mediaType: selectedMediaType,
                    printMethod: selectedPrintMethod,
                    printWidth: int.tryParse(printWidthController.text),
                    labelLength: int.tryParse(labelLengthController.text),
                    labelLengthMax:
                        double.tryParse(labelLengthMaxController.text),
                    zplMode: selectedZPLMode,
                    powerUpAction: selectedPowerUpAction,
                    headCloseAction: selectedHeadCloseAction,
                    labelTop: int.tryParse(labelTopController.text),
                    leftPosition: int.tryParse(leftPositionController.text),
                    printMode: selectedPrintMode,
                    reprintMode: selectedReprintMode,
                    virtualDevice: selectedVirtualDevice,
                  )
//            settings: Printer.PrinterSettings(
//              darkness: 10, //10
//              printSpeed: 6, //6
//              tearOff: 0,//0
//              mediaType: Printer.MediaType.MARK, //MARK
//              printMethod: Printer.PrintMethod.DIRECT_THERMAL, //DIRECT_THERMAL
//              printWidth: 568,//600
//              labelLength: 1202,//1202
//              labelLengthMax: 39,//39
//              zplMode: Printer.ZPLMode.ZPL_II,//ZPL II
//              powerUpAction: Printer.PowerUpAction.NO_MOTION,//NO MOTION
//              headCloseAction: Printer.HeadCloseAction.FEED,//FEED
//              labelTop: 0,//0
//              leftPosition: 0,//0
//              printMode: Printer.PrintMode.TEAR_OFF,//TEAR_OFF
//              reprintMode: Printer.ReprintMode.OFF,//OFF
//              virtualDevice: selectedVirtualDevice,
//            )
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
//              virtualDevice: selectedVirtualDevice,
//            )
                  )
              .then((value) {
            setState(() {
              settingsStatus = SettingsStatus.SUCCESS;
              settingsMessage = "$value";
              updateSettings((Printer.PrinterResponse.fromMap(value)).settings);
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                settingsMessage =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n"
                    "${printerResponse.settings?.toString()}";
              } catch (e) {
                print(e);
                settingsMessage = e.toString();
              }
            } on MissingPluginException catch (e) {
              settingsMessage = "${e.message}";
            } catch (e) {
              settingsMessage = e.toString();
            }
            setState(() {
              settingsStatus = SettingsStatus.ERROR;
            });
          });
          break;
        case btnResetPrinterSettings:
          setState(() {
            settingsMessage = "Setting default settings...";
            settingsStatus = SettingsStatus.SETTING;
          });
          widget.zsdk
              .setPrinterSettingsOverTCPIP(
                  address: addressIpController.text,
                  port: int.tryParse(addressPortController.text),
                  settings: Printer.PrinterSettings.defaultSettings())
              .then((value) {
            setState(() {
              settingsStatus = SettingsStatus.SUCCESS;
              settingsMessage = "$value";
              updateSettings((Printer.PrinterResponse.fromMap(value)).settings);
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                settingsMessage =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n"
                    "${printerResponse.settings?.toString()}";
              } catch (e) {
                print(e);
                settingsMessage = e.toString();
              }
            } on MissingPluginException catch (e) {
              settingsMessage = "${e.message}";
            } catch (e) {
              settingsMessage = e.toString();
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
          widget.zsdk
              .checkPrinterStatusOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          )
              .then((value) {
            setState(() {
              checkingStatus = CheckingStatus.SUCCESS;
              Printer.PrinterResponse? printerResponse;
              if (value != null) {
                printerResponse = Printer.PrinterResponse.fromMap(value);
              }
              statusMessage =
                  "${printerResponse != null ? printerResponse.toMap() : value}";
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                statusMessage =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}";
              } catch (e) {
                print(e);
                statusMessage = e.toString();
              }
            } on MissingPluginException catch (e) {
              statusMessage = "${e.message}";
            } catch (e) {
              statusMessage = e.toString();
            }
            setState(() {
              checkingStatus = CheckingStatus.ERROR;
            });
          });
          break;
        case btnPrintConfigurationLabel:
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk
              .printConfigurationLabelOverTCPIP(
            address: addressIpController.text,
            port: int.tryParse(addressPortController.text),
          )
              .then((value) {
            setState(() {
              printStatus = PrintStatus.SUCCESS;
              message = "$value";
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                message =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}";
              } catch (e) {
                print(e);
                message = e.toString();
              }
            } on MissingPluginException catch (e) {
              message = "${e.message}";
            } catch (e) {
              message = e.toString();
            }
            setState(() {
              printStatus = PrintStatus.ERROR;
            });
          });
          break;
        case btnPrintPdfFileOverTCPIP:
          if (!pathController.text.endsWith(".pdf")) {
            throw Exception(
                "Make sure you properly write the path or selected a proper pdf file");
          }
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk
              .printPdfFileOverTCPIP(
                  filePath: pathController.text,
                  address: addressIpController.text,
                  port: int.tryParse(addressPortController.text),
                  printerConf: Printer.PrinterConf(
                    cmWidth: double.tryParse(widthController.text),
                    cmHeight: double.tryParse(heightController.text),
                    dpi: double.tryParse(dpiController.text),
                    orientation: printerOrientation,
                  ))
              .then((value) {
            setState(() {
              printStatus = PrintStatus.SUCCESS;
              message = "$value";
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                message =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}";
              } catch (e) {
                print(e);
                message = e.toString();
              }
            } on MissingPluginException catch (e) {
              message = "${e.message}";
            } catch (e) {
              message = e.toString();
            }
            setState(() {
              printStatus = PrintStatus.ERROR;
            });
          });
          break;
        case btnPrintZplFileOverTCPIP:
          if (filePath == null && !pathController.text.endsWith(".zpl")) {
            throw Exception(
                "Make sure you properly write the path or selected a proper zpl file");
          }
          File zplFile = File(filePath!);
          if (await zplFile.exists()) {
            zplData = await zplFile.readAsString();
          }
          if (zplData == null || zplData!.isEmpty) {
            throw Exception(
                "Make sure you properly write the path or selected a proper zpl file");
          }
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk
              .printZplDataOverTCPIP(
                  data: zplData!,
                  address: addressIpController.text,
                  port: int.tryParse(addressPortController.text),
                  printerConf: Printer.PrinterConf(
                    cmWidth: double.tryParse(widthController.text),
                    cmHeight: double.tryParse(heightController.text),
                    dpi: double.tryParse(dpiController.text),
                    orientation: printerOrientation,
                  ))
              .then((value) {
            setState(() {
              printStatus = PrintStatus.SUCCESS;
              message = "$value";
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                message =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}";
              } catch (e) {
                print(e);
                message = e.toString();
              }
            } on MissingPluginException catch (e) {
              message = "${e.message}";
            } catch (e) {
              message = e.toString();
            }
            setState(() {
              printStatus = PrintStatus.ERROR;
            });
          });
          break;
        case btnPrintZplDataOverTCPIP:
          zplData = zplDataController.text;
          if (zplData == null || zplData!.isEmpty) {
            throw Exception("ZPL data can't be empty");
          }
          setState(() {
            message = "Print job started...";
            printStatus = PrintStatus.PRINTING;
          });
          widget.zsdk
              .printZplDataOverTCPIP(
                  data: zplData!,
                  address: addressIpController.text,
                  port: int.tryParse(addressPortController.text),
                  printerConf: Printer.PrinterConf(
                    cmWidth: double.tryParse(widthController.text),
                    cmHeight: double.tryParse(heightController.text),
                    dpi: double.tryParse(dpiController.text),
                    orientation: printerOrientation,
                  ))
              .then((value) {
            setState(() {
              printStatus = PrintStatus.SUCCESS;
              message = "$value";
            });
          }, onError: (error, stacktrace) {
            try {
              throw error;
            } on PlatformException catch (e) {
              Printer.PrinterResponse printerResponse;
              try {
                printerResponse = Printer.PrinterResponse.fromMap(e.details);
                message =
                    "${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}";
              } catch (e) {
                print(e);
                message = e.toString();
              }
            } on MissingPluginException catch (e) {
              message = "${e.message}";
            } catch (e) {
              message = e.toString();
            }
            setState(() {
              printStatus = PrintStatus.ERROR;
            });
          });
          break;
      }
    } catch (e) {
      print(e);
      showSnackBar(e.toString());
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
