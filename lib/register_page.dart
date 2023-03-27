import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iqc_grn_final_project/login_page.dart';
import 'package:iqc_grn_final_project/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iqc_grn_final_project/constant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name1Controller = TextEditingController();
  TextEditingController kpk1Controller = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController confirmpw1Controller = TextEditingController();
  bool _kpkError = false;
  bool _nameError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;

  void _validateFields() {
    setState(() {
      _kpkError = kpk1Controller.text.length != 6;
      _nameError = name1Controller.text.isEmpty;
      _passwordError = password1Controller.text.isEmpty;
      _confirmPasswordError =
          confirmpw1Controller.text != password1Controller.text;
    });
  }

  void _register() {
    _validateFields();

    if (!_kpkError &&
        !_nameError &&
        !_passwordError &&
        !_confirmPasswordError) {
      signup();
    }
  }

  Future signup() async {
    var url =
        Uri.http(Constants().ip, 'iqcgrn-flutter/register.php', {'q': 'http'});
    var response = await http.post(url, body: {
      'kpk': kpk1Controller.text,
      'name': name1Controller.text,
      'pass': password1Controller.text,
    });

    var data = json.decode(response.body);
    if (data == 'Error') {
      Fluttertoast.showToast(
        msg: 'This User Already Exists!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Registration Success, Please Login',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80.0,
                ),
                const Text(
                  'Sign Up Page',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainBlue),
                ),
                const SizedBox(
                  height: 80.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 60,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: name1Controller,
                    decoration: InputDecoration(
                      errorText: _nameError ? 'Name cannot be empty' : null,
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 60,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: kpk1Controller,
                    decoration: InputDecoration(
                      errorText: _kpkError
                          ? 'KPK should consist of 6 characters'
                          : null,
                      hintText: 'KPK',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.badge),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 60,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: password1Controller,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      errorText:
                          _passwordError ? 'Password cannot be empty' : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 60,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: confirmpw1Controller,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      errorText: _confirmPasswordError
                          ? 'Passwords do not match'
                          : null,
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text('Already have an account? Click here!'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: AppColors.mainBlue),
                  child: ElevatedButton(
                    onPressed: () {
                      _register();
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
