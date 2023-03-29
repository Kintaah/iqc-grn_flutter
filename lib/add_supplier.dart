import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iqc_grn_final_project/supplier_menu.dart';

import 'constant.dart';

class CreateSupplierScreen extends StatefulWidget {
  @override
  _CreateSupplierScreenState createState() => _CreateSupplierScreenState();
}

class _CreateSupplierScreenState extends State<CreateSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  String _statusValue = ''; // new variable to hold selected value for status
  String _classValue = ''; // new variable to hold selected value for class

  // options for status dropdown
  final List<String> _statusOptions = [
    'SUPPLIER CERTIFIED',
    'SUBCONT CERTIFIED',
    'NON CERTIFIED',
  ];

  // options for class dropdown
  final List<String> _classOptions = [
    'A',
    'B',
    'C',
    '',
  ];

  Future<void> _createSupplier() async {
    final uri =
        Uri.http(Constants().ip, 'iqcgrn-flutter/create.php', {'q': 'http'});
    final response = await http.post(
      uri,
      body: {
        'name': _nameController.text,
        'status': _statusValue,
        'class': _classValue,
      },
    );
    final data = json.decode(response.body);
    if (data["status"] == 'success') {
      print(data);
      Fluttertoast.showToast(
        msg: 'Create Success!',
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
        msg: 'Create Failed',
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
        title: Text('Create Supplier'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _statusValue.isNotEmpty ? _statusValue : null,
                  items: _statusOptions
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _statusValue = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Status is required';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _classValue == 'NON CERTIFIED' ? null : _classValue,
                  items: _classOptions
                      .map((cls) => DropdownMenuItem<String>(
                            value: cls,
                            child: Text(cls),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _classValue = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createSupplier();
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
