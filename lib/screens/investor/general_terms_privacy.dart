import 'dart:convert';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/signup_request_preferences.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/common/webview_container.dart';
import 'package:acc/screens/investor/dashboard/investor_dashboard.dart';
import 'package:acc/services/http_service.dart';
import 'package:acc/services/signup_service.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/app_progressbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/models/authentication/signup_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralTermsPrivacy extends StatefulWidget {
  @override
  _GeneralTermsPrivacyState createState() => _GeneralTermsPrivacyState();
}

class _GeneralTermsPrivacyState extends State<GeneralTermsPrivacy> {
  var progress;

  String tempUrl = "${ApiServices.baseUrlEndpoint}/terms_and_conditions";

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
              backgroundColor: Colors.white,
            ),
            bottomNavigationBar: BottomAppBar(),
            backgroundColor: Colors.white,
            body: AppProgressBar(
              child: Builder(
                  builder: (context) => SafeArea(
                          child: SingleChildScrollView(
                              child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  size: 30, color: backButtonColor),
                              onPressed: () => {Navigator.pop(context)},
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 25.0, right: 25.0),
                                child: Text(
                                  "Please accept our T&C, Privacy policy below",
                                  style: TextStyle(
                                      color: headingBlack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0,
                                      fontFamily: FontFamilyMontserrat.name),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                color: unselectedGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                margin: EdgeInsets.only(
                                    right: 25.0,
                                    top: 10.0,
                                    bottom: 10.0,
                                    left: 25.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20.0,
                                              left: 10.0,
                                              bottom: 20.0,
                                              right: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "General Terms and Conditions",
                                                style: setTextStyle(
                                                    headingBlack, 20.0),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              // // TERMS AND CONDITIONS
                                              RichText(
                                                text: TextSpan(
                                                    text: termsConditions,
                                                    style: setTextStyle(
                                                        textDarkGrey, 16.0),
                                                    children: [
                                                      TextSpan(
                                                          text: "... Read More",
                                                          style: setTextStyle(
                                                              Colors.blue,
                                                              16.0),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  openUrl(
                                                                      tempUrl);
                                                                }),
                                                    ]),
                                              ),
                                              SizedBox(
                                                height: 20.0,
                                              ),
                                              Text(
                                                "Privacy Policy",
                                                style: setTextStyle(
                                                    headingBlack, 20.0),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text: privacyPolicy,
                                                    style: setTextStyle(
                                                        textDarkGrey, 16.0),
                                                    children: [
                                                      TextSpan(
                                                          text: "... Read More",
                                                          style: setTextStyle(
                                                              Colors.blue,
                                                              16.0),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  openUrl(
                                                                      tempUrl);
                                                                }),
                                                    ]),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 25.0,
                                      bottom: 10,
                                      right: 25.0),
                                  child: Text(
                                      "By clicking on Submit, you agree to Amicorp Terms of Use and Privacy Policy",
                                      style: textBold14(Colors.black))),

                              //NEXT BUTTON
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 25.0,
                                      bottom: 20,
                                      right: 25.0),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(40),
                                      onTap: () async {
                                        // on click
                                        progress = AppProgressBar.of(context);
                                        progress?.showWithText(
                                            'Uploading Preferences...');
                                        final requestModelInstance =
                                            InvestorSignupPreferences.instance;

                                        User signedUpUser = await SignUpService
                                            .updateUserPreferences(
                                                requestModelInstance);
                                        progress.dismiss();
                                        if (signedUpUser.type == 'success') {
                                          requestModelInstance.clear();
                                          UserData userData = UserData(
                                            UserData.instance.userInfo.token,
                                            signedUpUser.data.firstName,
                                            "",
                                            signedUpUser.data.lastName,
                                            signedUpUser.data.mobileNo,
                                            signedUpUser.data.emailId,
                                            signedUpUser.data.userType,
                                            "",
                                            "",
                                            "",
                                            signedUpUser.data.address,
                                            signedUpUser.data.countryCode,
                                            signedUpUser.data.hearAboutUs,
                                            signedUpUser.data.referralName,
                                            signedUpUser.data.slotId,
                                            signedUpUser.data.productIds,
                                            signedUpUser.data.emailVerified,
                                          );
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final userJson = jsonEncode(userData);
                                          prefs.setString('UserInfo', userJson);
                                          UserData.instance.userInfo = userData;

                                          openDashboard();
                                        } else {
                                          showSnackBar(
                                              context, signedUpUser.message);
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 50.0, right: 50.0),
                                        height: 60,
                                        decoration: appColorButton(context),
                                        child: Center(
                                            child: Text(
                                          "Submit",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )),
                                      )))
                            ],
                          )
                        ],
                      )))),
            )));
  }

  TextStyle setTextStyle(colors, _fontSize) {
    return TextStyle(
        color: colors,
        fontSize: _fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: FontFamilyMontserrat.name);
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
      ],
    );
  }

  TextField inputTextField() {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 18.0,
          fontFamily: FontFamilyMontserrat.name),
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  void openUrl(String url) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return WebViewContainer(url);
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
