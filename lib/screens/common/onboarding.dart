import 'dart:io';

import 'package:acc/models/country/country.dart';
import 'package:acc/services/country_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:acc/screens/common/authentication/signin_otp.dart';
import 'package:acc/screens/common/user_type.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/models/local_countries.dart' as localCountry;
import 'package:flutter/services.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  //Color statusBarColor;
  List<localCountry.Countries> countryList = [];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }

    getAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    // statusBarColor = Colors.black.withOpacity(0.99);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.black.withOpacity(0.99),
    // ));
    // SystemChrome.setEnabledSystemUIOverlays([
    //   SystemUiOverlay.top, //This line is used for showing the bottom bar
    // ]);
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
        ),
        home: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Scaffold(
              bottomNavigationBar: BottomAppBar(),
              body: Stack(
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/onboarding/acc_home.png'),
                            fit: BoxFit.fill),
                      ),
                      child: new Column(children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          child: AddLogoWidget(),
                        ),
                        new Expanded(
                          flex: 5,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    child: Image.asset(
                                        "assets/images/onboarding/acc_home1.png")),
                                SizedBox(height: 20),
                                Container(
                                    child: Image.asset(
                                        "assets/images/onboarding/acc_home2.png")),
                                SizedBox(height: 20),
                                Container(
                                    child: Image.asset(
                                        "assets/images/onboarding/acc_home3.png")),
                                SizedBox(height: 30),
                              ]),
                        ),
                        new Expanded(
                            flex: 2,
                            child: Column(children: [
                              Divider(
                                color: Colors.white,
                                thickness: 3.0,
                              ),
                              SizedBox(height: 15),
                              Container(
                                  // color: kDarkGrey,
                                  // height: 200,
                                  child: Column(children: [
                                InkWell(
                                    borderRadius: BorderRadius.circular(40),
                                    onTap: () {
                                      // Open  view
                                      Navigator.of(context).push(
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  anotherAnimation) {
                                                return UserType();
                                              },
                                              transitionDuration:
                                                  Duration(milliseconds: 2000),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  anotherAnimation,
                                                  child) {
                                                animation = CurvedAnimation(
                                                    curve: Curves
                                                        .fastLinearToSlowEaseIn,
                                                    parent: animation);
                                                return SlideTransition(
                                                  position: Tween(
                                                          begin:
                                                              Offset(1.0, 0.0),
                                                          end: Offset(0.0, 0.0))
                                                      .animate(animation),
                                                  child: child,
                                                );
                                              }));
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 50.0, right: 50.0),
                                        height: 50,
                                        decoration: appColorButton(context),
                                        child: Center(
                                            child: Text(
                                          "Join Our Community",
                                          style: textWhiteBold18(),
                                        )))),
                                Container(
                                    margin: const EdgeInsets.only(top: 15.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Already a member? ",
                                      style: textNormal18(Colors.white),
                                    )),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0, bottom: 10.0),
                                  child: InkWell(
                                    onTap: () {
                                      openSignIn(context);
                                    },
                                    child: Text(
                                      'Sign-In',
                                      style: textBold18(Colors.white),
                                    ),
                                  ),
                                )
                              ]))
                            ]))
                      ]))
                ],
              ),
            )));
  }

  void openSignIn(BuildContext context) {
    // print("size onboarding countryList:-${countryList.length}");
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignInOTP(countriesList: countryList);
        },
        transitionDuration: Duration(milliseconds: 1000),
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

  Future<void> getAllCountries() async {
    final Country extractedData = await CountryService.fetchCountries();
    if (extractedData.type == "success") {
      if (extractedData.data.options.length != 0) {
        countryList.clear();
        for (int i = 0; i < extractedData.data.options.length; i++) {
          var value = extractedData.data.options[i];
          countryList.add(localCountry.Countries(
              value.countryName,
              value.countryAbbr,
              int.parse(
                  value.countryPhCode.replaceAll(new RegExp(r'[^0-9]'), '')),
              value.maxLength));
        }
      }
    }
  }
}

class AddLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.0),
      child: Image.asset(
        'assets/images/acc_logo_white.png',
        width: MediaQuery.of(context).size.width / 2,
        height: 100,
      ),
    );
  }
}
