import 'package:acc/constants/font_family.dart';
import 'package:acc/screens/investor/dashboard/investor_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

class ThankYouInvestor extends StatefulWidget {
  @override
  _ThankYouInvestorState createState() => _ThankYouInvestorState();
}

class _ThankYouInvestorState extends State<ThankYouInvestor> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0.0,
              backgroundColor: Color(0xffffffff),
            ),
            bottomNavigationBar: BottomAppBar(),
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          top: 25.0, left: 15.0, right: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Hello Investor',
                            style: TextStyle(
                                color: headingBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0,
                                fontFamily: FontFamilyMontserrat.name),
                          )),
                          Image.asset(
                              'assets/images/investor/icon_investor.png'),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 80.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/investor/thankyou_smiley.png',
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text('Thank you for signing up.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: headingBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: FontFamilyMontserrat.name)),
                      )),
                  //NEXT BUTTON
                  Container(
                    margin: const EdgeInsets.only(
                        top: 30.0, left: 25.0, right: 25.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        // on click

                        openDashboard();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: appColorButton(context),
                        child: Center(
                            child: Text(
                          "Open Dashboard",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ])))));
  }

  void openDashboard() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return InvestorDashboard();
            },
            transitionDuration: Duration(milliseconds: 2000),
            transitionsBuilder: (context, animation, anotherAnimation, child) {
              animation = CurvedAnimation(
                  curve: Curves.fastLinearToSlowEaseIn, parent: animation);
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
                child: child,
              );
            }),
        (route) => false);
  }
}
