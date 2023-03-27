import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:iqc_grn_final_project/report.dart';
import 'constant.dart';
import 'app_colors.dart';

class MainDashboard extends StatefulWidget {
  final String fullName;
  const MainDashboard({Key? key, required this.fullName}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  String _scanBarcode = 'Unknown';
  String initialValue = '';
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes.trim();
      resultController.text = _scanBarcode;
      List<String> values = _scanBarcode.split(',');
      if (values.length >= 2) {
        String partNumber = values[2];
        partNumberController.text = partNumber.trim();
      }
      if (values.length >= 3) {
        String supplierCode = values[1];
        supplierCodeController.text = supplierCode.trim();
      }
    });
  }

  bool isVisible = false;
  TextEditingController partNumberController = TextEditingController();
  TextEditingController supplierCodeController = TextEditingController();
  TextEditingController resultController = TextEditingController();

  bool _isPartNumValid = false;
  bool _isSuppCodeValid = false;

  void _validateField() {
    setState(() {
      _isPartNumValid = partNumberController.text.isEmpty;
      _isSuppCodeValid = supplierCodeController.text.length < 4;
    });
  }

  void display() async {
    _validateField();
    if (!_isPartNumValid && !_isSuppCodeValid) {
      await displayReport();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayReport(
              he: _he,
              ph: _ph,
              name: _name,
              status: _status,
              suppclass: _class,
              riskLevel: _riskLevel,
              heFrequency: _heFrequency,
              phFrequency: _phFrequency,
              testing: _testing,
              submitDate: _submitDate,
              partNumberControllerValue: partNumberController.text,
              batch: _batch,
              testingHE: _testingHE,
              testingPH: _testingPH,
              location: _location),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Scan First / Input Manual',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  String _he = '';
  String _ph = '';
  String _name = '';
  String _status = '';
  String _class = '';
  String _riskLevel = '';
  String _heFrequency = '';
  String _phFrequency = '';
  String _testing = '';
  String _submitDate = '';
  String _batch = '';
  String _testingHE = '';
  String _testingPH = '';
  String _location = '';

  Future displayReport() async {
    var url =
        Uri.http(Constants().ip, 'iqcgrn-flutter/check.php', {'q': 'http'});
    var response = await http.post(url, body: {
      'partnumber': partNumberController.text,
      'suppcode': supplierCodeController.text,
    });
    var data = json.decode(response.body);
    print(data);
    // 1. Check if part number exist or not, if exist grab he and ph
    if (data['status1'] == 'Success') {
      setState(() {
        _he = data['he'];
        _ph = data['PH'];
        _location = data['location'];
      });
    } else {
      _he = '-';
      _ph = '-';
      _location = '-';
    }
    // Query 2: Check if supplier code exists and get name, status, class, and risk level
    if (data['status2'] == 'Success') {
      setState(() {
        _name = data['name'];
        _status = data['status_supp'];
        _class = data['class'];
        _riskLevel = data['risklevel'];
      });
    } else {
      _name = '-';
      _status = '-';
      _class = '-';
      _riskLevel = '-';
    }
    if (data['status3'] == 'Success') {
      setState(() {
        _heFrequency = data['hefrequency'];
      });
    } else {
      _heFrequency = 'N/A';
    }
    if (data['status4'] == 'Success') {
      setState(() {
        _phFrequency = data['phfrequency'];
      });
    } else {
      _phFrequency = 'N/A';
    }

    if (data['status5'] == 'Success' &&
        data['testingHE'] == 'Yes' &&
        data['testingPH'] == 'Yes') {
      setState(() {
        _testing = data['testing'];
        _submitDate = data['submitdatehe'];
        _batch = data['batch'];
        _testingHE = data['testingHE'];
        _testingPH = data['testingPH'];
      });
    } else if (data['status5'] == 'Success' &&
        data['testingHE'] == 'Yes' &&
        data['testingPH'] == 'No') {
      setState(() {
        _testing = data['testing'];
        _submitDate = data['submitdatehe'];
        _batch = data['batch'];
        _testingHE = data['testingHE'];
        _testingPH = '-';
      });
    } else if (data['status5'] == 'Success' &&
        data['testingHE'] == 'No' &&
        data['testingPH'] == 'Yes') {
      setState(() {
        _testing = data['testing'];
        _submitDate = data['submitdatehe'];
        _batch = data['batch'];
        _testingHE = '-';
        _testingPH = data['testingPH'];
      });
    } else {
      _testing = '-';
      _submitDate = '-';
      _batch = '-';
      _testingHE = '-';
      _testingPH = '-';
    }
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      if (!isVisible) {
        partNumberController.clear();
        supplierCodeController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 68.0,
                  ),
                  const Text(
                    'GRN Scanner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 48.0,
                        color: AppColors.mainBlue,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Testing Frequency Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.mainBlack,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    'Hi, ${widget.fullName}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: AppColors.mainBlack,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Please Scan The Barcode',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.mainBlack,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.mainBlue),
                    child: TextButton(
                      onPressed: () {
                        scanQR();
                      },
                      child: const Text(
                        'Scan',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.center,
                      controller: resultController,
                      decoration: InputDecoration(
                        hintText: 'Result',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          borderSide:
                              BorderSide(width: 1.0, color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.mainGreen),
                    child: TextButton(
                      onPressed: () {
                        display();
                      },
                      child: Text(
                        'Show Report',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppColors.mainRed),
                    child: TextButton(
                      onPressed: () {
                        print('Clicked');
                        setState(() {
                          isVisible = true;
                        });
                      },
                      child: Text(
                        'Input Manual',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: partNumberController,
                              decoration: InputDecoration(
                                errorText: _isPartNumValid
                                    ? 'Part Number Cannot be Empty!'
                                    : null,
                                labelText: 'Part Number',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: supplierCodeController,
                              decoration: InputDecoration(
                                errorText: _isSuppCodeValid
                                    ? 'Supplier Code Must be Equal or More than 4 character'
                                    : null,
                                labelText: 'Supplier Code',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
