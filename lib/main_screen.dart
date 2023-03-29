import 'package:flutter/material.dart';
import 'package:iqc_grn_final_project/maindashboard.dart';
import 'package:iqc_grn_final_project/supplier_menu.dart';

import 'app_colors.dart';

class MainMenu extends StatefulWidget {
  final String fullName;
  const MainMenu({Key? key, required this.fullName}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 110.0,
                  ),
                  const Image(
                    image: AssetImage('images/IQC1.png'),
                  ),
                  const SizedBox(
                    height: 24.0,
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
                  const Text(
                    'Please Scan The Menu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: AppColors.mainBlack,
                        fontFamily: 'DMSans',
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.38,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainDashboard(fullName: widget.fullName),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.qr_code,
                                color: Colors.white,
                                size: 40.0,
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                'Scan GRN',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.38,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplierMenu(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.mainGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.local_shipping_outlined,
                                color: Colors.white,
                                size: 40.0,
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                'Supplier \n Menu',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
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
      ),
    );
  }
}
