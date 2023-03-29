import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iqc_grn_final_project/app_colors.dart';
import 'package:iqc_grn_final_project/display_map.dart';

class DisplayReport extends StatefulWidget {
  final String he;
  final String ph;
  final String name;
  final String status;
  final String suppclass;
  final String riskLevel;
  final String heFrequency;
  final String phFrequency;
  final String testing;
  final String submitDate;
  final String partNumberControllerValue;
  final String batch;
  final String testingHE;
  final String testingPH;
  final String location;

  const DisplayReport({
    Key? key,
    required this.he,
    required this.ph,
    required this.name,
    required this.status,
    required this.suppclass,
    required this.riskLevel,
    required this.heFrequency,
    required this.phFrequency,
    required this.testing,
    required this.submitDate,
    required this.batch,
    required this.partNumberControllerValue,
    required this.testingHE,
    required this.testingPH,
    required this.location,
  }) : super(key: key);

  @override
  State<DisplayReport> createState() => _DisplayReportState();
}

class _DisplayReportState extends State<DisplayReport> {
  late DateTime? _submitDatePH;
  late String _formattedDatePH;
  late String _formattedDatePHLR;
  late int _phFrequency;
  late String _submissionStatusPH;
  late DateTime? _submitDateHE;
  late DateTime? _submitDateHELR;
  late String _formattedDateHE;
  late String _formattedDateHELR;
  late DateTime? _submitDatePHLR;
  late int _heFrequency;
  late String _submissionStatusHE;
  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();

    try {
      _submitDatePH = DateTime.parse(widget.submitDate);
      _submitDatePHLR = DateTime.parse(widget.submitDate);
      _phFrequency = int.tryParse(widget.phFrequency) ?? 0;
      _submitDatePH = _submitDatePH!.add(Duration(days: _phFrequency));
      _formattedDatePH = DateFormat('MM/dd/yyyy').format(_submitDatePH!);
      _formattedDatePHLR = DateFormat('MM/dd/yyyy').format(_submitDatePHLR!);
    } catch (e) {
      _submitDatePH = null;
      _formattedDatePH = '-';
    }
    _phFrequency = int.tryParse(widget.phFrequency) ?? 0;
    _submissionStatusPH = calculateSubmissionStatusPH();

    try {
      _submitDateHE = DateTime.parse(widget.submitDate);
      _submitDateHELR = DateTime.parse(widget.submitDate);
      _heFrequency = int.tryParse(widget.heFrequency) ?? 0;
      _submitDateHE = _submitDateHE!.add(Duration(days: _heFrequency));
      _formattedDateHE = DateFormat('MM/dd/yyyy').format(_submitDateHE!);
      _formattedDateHELR = DateFormat('MM/dd/yyyy').format(_submitDateHELR!);
    } catch (e) {
      _submitDateHE = null;
      _formattedDateHE = '-';
    }
    _heFrequency = int.tryParse(widget.heFrequency) ?? 0;
    _submissionStatusHE = calculateSubmissionStatusHE();

    Map<String, List<double>> locationMap = {
      "PTMI": [-6.29877736458542, 107.1544124124059],
      "PTMW": [-6.284083085158516, 107.14002153152384],
      "MIDC": [5.360289042990433, 100.39944388378983],
      "MOA": [26.834721529035555, -100.66035242936775]
    };

    String location = widget.location;
    List<double>? latLng = locationMap[location];
    if (latLng != null) {
      _latitude = latLng[0];
      _longitude = latLng[1];
      // Use latitude and longitude to display the location on the map
    } else {
      // Handle case where location is not found in the map
    }
  }

  String calculateSubmissionStatusPH() {
    if (_submitDatePH == null) {
      return '-';
    }
    DateTime dueDate = _submitDatePH!.add(Duration(days: _phFrequency));
    DateTime now = DateTime.now();

    if (dueDate.isBefore(now)) {
      return 'Submit';
    } else {
      return 'Refer to $_formattedDatePH';
    }
  }

  String calculateSubmissionStatusHE() {
    if (_submitDateHE == null) {
      return '-';
    }
    DateTime dueDate = _submitDateHE!.add(Duration(days: _heFrequency));
    DateTime now = DateTime.now();

    if (dueDate.isBefore(now)) {
      return 'Submit';
    } else {
      return 'Refer to $_formattedDateHE';
    }
  }

  String email = '';
  bool _isEmailValid = false;

//Pop Up Dialog
  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Receiver E-mail'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            decoration: InputDecoration(
                hintText: 'Enter your E-mail',
                errorText:
                    _isEmailValid ? null : 'Please enter a valid e-mail'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                _isEmailValid = emailRegex.hasMatch(email);

                if (_isEmailValid && email.isNotEmpty) {
                  sendEmail(
                      email: email,
                      heStatus:
                          widget.testingHE == '-' ? '-' : _submissionStatusHE,
                      phStatus:
                          widget.testingPH == '-' ? '-' : _submissionStatusPH,
                      partNum: widget.partNumberControllerValue);

                  Navigator.pop(context);
                } else {
                  setState(() {
                    _isEmailValid = false;
                  });
                }
              },
              child: const Text('Send E-Mail'),
            ),
          ],
        ),
      );

  Future sendEmail({
    required String email,
    required String heStatus,
    required String phStatus,
    required String partNum,
  }) async {
    const serviceID = 'service_wqbr5ge';
    const templateID = 'template_z2jbpdt';
    const userID = 'eMYYUupRNIvZAslrC';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'Application/json',
        },
        body: json.encode({
          'service_id': serviceID,
          'template_id': templateID,
          'user_id': userID,
          'template_params': {
            'email': email,
            'partnum': partNum,
            'phstatus': phStatus,
            'hestatus': heStatus,
          }
        }));

    if (response.statusCode == 200) {
      print('Email sent successfully!');
    } else {
      print('Failed to send email: ${response.reasonPhrase}');
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
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
                  'Display Report',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: AppColors.mainBlack,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.90, // Use 80% of the screen width
                            height: MediaQuery.of(context).size.height *
                                0.56, // Use 40% of the screen height
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: AppColors.mainBlue),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 32.0,
                                ),
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DMSans'),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.partNumberControllerValue,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'DMSans'),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                                Text(
                                  "=${widget.status} ${widget.suppclass}=",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'DMSans'),
                                  textAlign: TextAlign.center,
                                ),
                                // PH(Phthalate)
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingPH == '-'
                                            ? 'PH - N/A'
                                            : "PH - ${widget.phFrequency}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingPH == '-'
                                            ? '-'
                                            : _submissionStatusPH,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingPH == '-'
                                            ? 'Batch: -'
                                            : 'Batch:${widget.batch}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingPH == '-'
                                            ? 'Latest Report: -'
                                            : 'Latest Report: $_formattedDatePHLR',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                // HE(Heavy Element)
                                const SizedBox(
                                  height: 28.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingHE == '-'
                                            ? 'HE - N/A'
                                            : "HE - ${widget.heFrequency}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingHE == '-'
                                            ? '-'
                                            : _submissionStatusHE,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingHE == '-'
                                            ? 'Batch: -'
                                            : 'Batch:${widget.batch}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.testingHE == '-'
                                            ? 'Latest Report: -'
                                            : 'Latest Report: $_formattedDateHELR',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'DMSans'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.72,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.mainGreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          openDialog();
                          setState(() {});
                        },
                        child: const Text(
                          'Send Reminder',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'DMSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 24.0,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.mainRed,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            print(_latitude);
                            print(_longitude);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(
                                  latitude: _latitude,
                                  longitude: _longitude,
                                  location: widget.location,
                                ),
                              ),
                            );
                          });
                        },
                        child: const Text(
                          'Show Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
