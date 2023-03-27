import 'package:flutter/material.dart';
import 'package:iqc_grn_final_project/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void main() => runApp(const SplashScreen());

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
