import 'package:acc/models/investor/hearaboutus.dart';
import 'package:acc/services/InvestmentInfoService.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/found_us.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

class WelcomeInvestor extends StatefulWidget {
  @override
  _WelcomeInvestorState createState() => _WelcomeInvestorState();
}

class _WelcomeInvestorState extends State<WelcomeInvestor> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MediaQuery(
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
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: backButtonColor,
                        ),
                        onPressed: () => {_onBackPressed()},
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            margin:
                                const EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              "Welcome to\nAmicorp\nCapital Connect"
                                  .toUpperCase(),
                              textAlign: TextAlign.center,
                              style: textBold26(headingBlack),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Image.asset(
                                'assets/images/investor/success_investor.png'),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 25.0, right: 25.0),
                            child: Text(
                                "To give you the best possible\nexperience we need to find out a bit\nmore about you.This will take less than a minute.",
                                textAlign: TextAlign.center,
                                style: textNormal16(textGrey)),
                          ),

                          SizedBox(height: 40),

                          //NEXT BUTTON
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 80.0,
                                  bottom: 20,
                                  right: 80.0),
                              child: InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {
                                    // on click
                                    openInvestorSearchInfo();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    decoration: appColorButton(context),
                                    child: Center(
                                        child: Text("Continue",
                                            style: textWhiteBold18())),
                                  )))
                        ])
                  ])))),
        ));
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            color: Colors.grey[200],
          )
        ]);
  }

  TextField inputTextField(text) {
    return TextField(
        style: textBlackNormal16(),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: text,
            labelStyle: new TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  Future<void> openInvestorSearchInfo() async {
    HearAboutUs hearAboutUs = await InvestmentInfoService.hearAboutUsInfo();

    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return InvestorSearchInfo(data: hearAboutUs);
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
        }));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?', style: textNormal16(headingBlack)),
            content: new Text('You want to cancel preferences setup',
                style: textNormal14(headingBlack)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigation.openOnBoarding(context);
                  },
                  child: Text(
                    "Yes",
                    style: textNormal14(Theme.of(context).primaryColor),
                  )),
              SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: textNormal14(Theme.of(context).primaryColor),
                  )),
            ],
          ),
        ) ??
        false;
  }
}
