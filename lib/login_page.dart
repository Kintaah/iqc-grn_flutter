import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:iqc_grn_final_project/app_colors.dart';
import 'package:iqc_grn_final_project/landingpage.dart';
import 'package:iqc_grn_final_project/main_screen.dart';
import 'package:iqc_grn_final_project/maindashboard.dart';
import 'package:iqc_grn_final_project/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController kpkController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  String _fullName = '';
  bool _isKPKValid = true;
  bool _isPasswordValid = true;

  void _validatelogin() {
    setState(() {
      _isKPKValid = kpkController.text.isNotEmpty;
      _isPasswordValid = passwordController.text.isNotEmpty;
    });

    if (_isKPKValid && _isPasswordValid) {
      login();
    }
  }

  //Login Function
  Future login() async {
    var url =
        Uri.http(Constants().ip, 'iqcgrn-flutter/login.php', {'q': 'http'});
    var response = await http.post(url, body: {
      'kpk': kpkController.text,
      'pass': passwordController.text,
    });

    var data = json.decode(response.body);
    if (data['status'] == 'Error') {
      Fluttertoast.showToast(
        msg: 'Invalid KPK or Password!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      setState(() {
        _fullName = data['fullname'];
      });
      Fluttertoast.showToast(
        msg: 'Login Success!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainMenu(fullName: _fullName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 110.0,
                ),
                const Text(
                  'Login Screen',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainBlue),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const Image(
                  image: AssetImage('images/IQC1.png'),
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
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: kpkController,
                    decoration: InputDecoration(
                      errorText:
                          _isKPKValid ? null : 'Please enter a KPK Number!',
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
                    controller: passwordController,
                    obscureText: _isObscure,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter KPK';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      errorText:
                          _isPasswordValid ? null : 'Please enter a Password!',
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        color: AppColors.mainBlack,
                        icon: Icon(_isObscure
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
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
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text('Didn\'t have an account?'),
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
                  child: TextButton(
                    onPressed: () {
                      _validatelogin();
                    },
                    child: const Text(
                      'Login',
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
