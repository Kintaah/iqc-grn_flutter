import 'package:flutter/material.dart';
import 'landingpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  title: 'Text',
                )));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Image(
                image: AssetImage('images/IQC1.png'),
                height: 198.0,
                width: 198.0,
              ),
              // SizedBox(
              //   height: 20.0,
              // ),
              // Text(
              //   'GRN Scanner',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 54,
              //       fontFamily: 'DMSans',
              //       fontWeight: FontWeight.bold,
              //       color: Colors.lightBlue),
              // ),
              // SizedBox(
              //   height: 10.0,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
