import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/ui_widgets.dart';
import 'package:readmore/readmore.dart';

class GeneralTermsPrivacy extends StatefulWidget {
  @override
  _GeneralTermsPrivacyState createState() => _GeneralTermsPrivacyState();
}

class _GeneralTermsPrivacyState extends State<GeneralTermsPrivacy> {
  String termsConditions =
      "AmiCorp (“we” or “us” or “our”) respects the privacy of our users (“user” or “you”). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our mobile application (the “Application”). Please read this Privacy Policy carefully. IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION.";
  String _privacy =
      "AmiCorp (“we” or “us” or “our”) respects the privacy of our users (“user” or “you”). This Privacy Policy explains how we collect, use, disclose IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION.";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 30),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0),
                    child: Text(
                      "Please accept our T&C, Privacy policy below",
                      style: TextStyle(
                          color: headingBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          fontFamily: 'Poppins-Light'),
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
                        right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  left: 10.0,
                                  bottom: 20.0,
                                  right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "General Terms and Conditions",
                                    style: setTextStyle(headingBlack, 20.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  ReadMoreText(
                                    termsConditions,
                                    style: setTextStyle(textDarkGrey, 16.0),
                                    trimLines: 5,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Read More',
                                    trimExpandedText: 'Read Less',
                                    moreStyle: setTextStyle(Colors.blue, 16.0),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    "Privacy Policy",
                                    style: setTextStyle(headingBlack, 20.0),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  ReadMoreText(
                                    _privacy,
                                    style: setTextStyle(textDarkGrey, 16.0),
                                    trimLines: 4,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Read More',
                                    trimExpandedText: 'Read Less',
                                    moreStyle: setTextStyle(Colors.blue, 16.0),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //NEXT BUTTON
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        // on click
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: appColorButton(),
                        child: Center(
                            child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle setTextStyle(colors, _fontSize) {
    return TextStyle(
        color: colors,
        fontSize: _fontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins-Regular');
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
}
