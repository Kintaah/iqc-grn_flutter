import 'package:flutter/material.dart';
import 'package:iqc_grn_final_project/app_colors.dart';
import 'package:iqc_grn_final_project/login_page.dart';
import 'package:iqc_grn_final_project/register_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final buttonWidth = mediaQuery.size.width *
        0.8; // set the desired width as a fraction of the screen width
    final buttonHeight = mediaQuery.size.height *
        0.1; // set the desired height as a fraction of the screen height
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100.0),
                const Image(
                  image: AssetImage('images/IQC1.png'),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'GRN Scanner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 54.0,
                      color: AppColors.mainBlue,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  'Testing Frequency Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 80.0),
                SizedBox(
                  height: 58.0,
                  width: 305.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  height: 58.0,
                  width: 305.0,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(buttonWidth, buttonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.lightBlue,
                          fontFamily: 'DMSans',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
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
