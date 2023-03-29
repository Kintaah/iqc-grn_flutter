import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iqc_grn_final_project/supplier_menu.dart';
import 'dart:convert';

import 'app_colors.dart';
import 'constant.dart';

class UpdateData extends StatefulWidget {
  final String code;
  final String name;
  final String status;
  final String class1;

  UpdateData(
      {required this.code,
      required this.name,
      required this.status,
      required this.class1});

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _code = '';
  String _name = '';
  String _status = '';
  String _class = '';

  @override
  void initState() {
    super.initState();
    _code = widget.code;
    _name = widget.name;
    _status = widget.status;
    _class = widget.class1;
  }

  Future<void> updateData() async {
    final uri =
        Uri.http(Constants().ip, 'iqcgrn-flutter/update.php', {'q': 'http'});
    final response = await http.post(uri, body: {
      "code": _code,
      "name": _name,
      "status": _status,
      "class": _class
    });
    final data = json.decode(response.body);
    if (data["status"] == "success") {
      Fluttertoast.showToast(
        msg: 'Update Success!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SupplierMenu(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Update Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> deleteData() async {
    final uri =
        Uri.http(Constants().ip, 'iqcgrn-flutter/delete.php', {'q': 'http'});
    final response = await http.post(uri, body: {
      "code": _code,
    });
    final data = json.decode(response.body);
    if (data["status"] == "success") {
      Fluttertoast.showToast(
        msg: 'Delete Success!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SupplierMenu(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Update Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Supplier Data"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: _code,
                  decoration: InputDecoration(
                    labelText: "Supplier Code",
                  ),
                  enabled: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter supplier code";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _code = value!;
                  },
                ),
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: "Supplier Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter supplier name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _status,
                  decoration: InputDecoration(
                    labelText: "Supplier Status",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter supplier status";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _status = value!;
                  },
                ),
                TextFormField(
                  initialValue: _class,
                  decoration: InputDecoration(
                    labelText: "Supplier Class",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter supplier class";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _class = value!;
                  },
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            updateData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.mainGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.32,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text(
                                  'Are you sure you want to delete this data?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                ),
                              ],
                            ),
                          ).then((confirmed) {
                            if (confirmed != null && confirmed) {
                              deleteData();
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.mainRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
