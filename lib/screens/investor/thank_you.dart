import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/common/onboarding.dart';
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

    return Scaffold(
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
                  margin:
                      const EdgeInsets.only(top: 25.0, left: 15.0, right: 25.0),
                  child: Row(
                    children: [
                      Image.asset('assets/images/investor/icon_menu.png'),
                      SizedBox(width: 10.0),
                      Expanded(
                          child: Text(
                        'Hello Investor',
                        style: TextStyle(
                            color: headingBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            fontFamily: 'Poppins-Light'),
                      )),
                      Image.asset('assets/images/investor/icon_investor.png'),
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
                    child: Text(
                        'Thank you for signing up.\n\n Our team will review \nand revert soon.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: headingBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Poppins-Light')),
                  )),
              //NEXT BUTTON
              Container(
                margin:
                    const EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    // on click

                    openOnBoarding();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: appColorButton(),
                    child: Center(
                        child: Text(
                      "Back to Home",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ),
              )
            ]))));
  }

  void openOnBoarding() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return OnBoarding();
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
