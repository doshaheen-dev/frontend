import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';

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
      body: Container(
          margin: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
          alignment: Alignment.topLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Your Recommendations",
                style: TextStyle(
                  color: headingBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: 'Poppins-Light',
                )),
            SizedBox(
              height: 10.0,
            ),
            Text(
                "Here are investment products specially curated for you based on your preferences",
                style: TextStyle(
                  color: textGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-Light',
                )),
          ])),
    );
  }
}
