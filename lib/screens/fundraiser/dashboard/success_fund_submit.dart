import 'package:acc/screens/fundraiser/dashboard/fundraiser_dashboard.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

class SuccesssFundSubmitted extends StatefulWidget {
  @override
  _SuccesssFundSubmittedState createState() => _SuccesssFundSubmittedState();
}

class _SuccesssFundSubmittedState extends State<SuccesssFundSubmitted> {
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
                      Expanded(
                          child: Text(
                        'Hello Fundraiser',
                        style: textBold26(headingBlack),
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
                    child: Column(
                      children: [
                        Text('Thank you for submitting your details.',
                            textAlign: TextAlign.center,
                            style: textBold(headingBlack, 18)),
                        Text('Our team will review\nand revert soon.',
                            textAlign: TextAlign.center,
                            style: textBold(headingBlack, 18))
                      ],
                    ),
                  )),
              //NEXT BUTTON
              Container(
                margin:
                    const EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    // on click
                    Navigator.of(context).pushAndRemoveUntil(
                        PageRouteBuilder(
                            pageBuilder:
                                (context, animation, anotherAnimation) {
                              return FundraiserDashboard();
                            },
                            transitionDuration: Duration(milliseconds: 2000),
                            transitionsBuilder:
                                (context, animation, anotherAnimation, child) {
                              animation = CurvedAnimation(
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  parent: animation);
                              return SlideTransition(
                                position: Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset(0.0, 0.0))
                                    .animate(animation),
                                child: child,
                              );
                            }),
                        (Route<dynamic> route) => false);
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
}
