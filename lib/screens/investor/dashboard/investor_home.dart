import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

class InvestorHome extends StatefulWidget {
  InvestorHome({Key key}) : super(key: key);

  @override
  _InvestorHomeState createState() => _InvestorHomeState();
}

class _InvestorHomeState extends State<InvestorHome> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20.0, left: 15.0, right: 25.0),
              child: Column(children: [
                Text("Your Recommendations",
                    style: TextStyle(
                      color: headingBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      fontFamily: 'Poppins-Light',
                    )),
                Text(
                    "Here are investment products specially curated for you based on your preferences",
                    style: TextStyle(
                      color: textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      fontFamily: 'Poppins-Light',
                    )),
              ])),
        ],
      ),
    );
  }
}
