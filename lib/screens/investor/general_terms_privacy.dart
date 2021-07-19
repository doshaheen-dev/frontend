import 'dart:convert';

import 'package:acc/constants/font_family.dart';
import 'package:acc/services/signup_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:acc/screens/investor/thank_you.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:acc/models/authentication/signup_request.dart';
import 'package:acc/models/authentication/signup_response.dart';

class GeneralTermsPrivacy extends StatefulWidget {
  @override
  _GeneralTermsPrivacyState createState() => _GeneralTermsPrivacyState();
}

class _GeneralTermsPrivacyState extends State<GeneralTermsPrivacy> {
  String termsConditions =
      "AmiCorp (“we” or “us” or “our”) respects the privacy of our users (“user” or “you”). This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you visit our mobile application (the “Application”). Please read this Privacy Policy carefully. IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION.";
  String _privacy =
      "AmiCorp (“we” or “us” or “our”) respects the privacy of our users (“user” or “you”). This Privacy Policy explains how we collect, use, disclose IF YOU DO NOT AGREE WITH THE TERMS OF THIS PRIVACY POLICY, PLEASE DO NOT ACCESS THE APPLICATION.";
  var progress;

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
      body: ProgressHUD(
        child: Builder(
          builder: (context) => SafeArea(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        moreStyle:
                                            setTextStyle(Colors.blue, 16.0),
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
                                        moreStyle:
                                            setTextStyle(Colors.blue, 16.0),
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

                      // //CAPTCHA
                      // Container(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(
                      //       left: 25.0,
                      //       bottom: 20.0,
                      //       right: 25.0,
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "Captcha",
                      //           style: TextStyle(
                      //               color: headingBlack,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize: 20.0,
                      //               fontFamily: 'Poppins-Light'),
                      //         ),
                      //         SizedBox(
                      //           height: 20.0,
                      //         ),
                      //         Row(
                      //           children: [
                      //             Expanded(
                      //                 flex: 1,
                      //                 child: Container(
                      //                   margin: EdgeInsets.only(right: 10.0),
                      //                   height: 60,
                      //                   decoration: BoxDecoration(
                      //                       color: HexColor('E5E5E5'),
                      //                       borderRadius: BorderRadius.all(
                      //                         const Radius.circular(20.0),
                      //                       )),
                      //                   child: Center(
                      //                       child: Text(
                      //                     "10 + 2",
                      //                     style: TextStyle(
                      //                         fontSize: 18.0, color: Colors.black),
                      //                   )),
                      //                 )),
                      //             Expanded(
                      //               flex: 1,
                      //               child: Container(
                      //                 margin: EdgeInsets.only(left: 10.0),
                      //                 width: MediaQuery.of(context).size.width,
                      //                 height: 60,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius: BorderRadius.all(
                      //                     const Radius.circular(20.0),
                      //                   ),
                      //                   shape: BoxShape.rectangle,
                      //                   border: Border.all(
                      //                     color: HexColor('E5E5E5'),
                      //                     width: 2,
                      //                   ),
                      //                 ),
                      //                 child: inputTextField(),
                      //               ),
                      //             ),
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      //NEXT BUTTON
                      Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: () async {
                            // on click
                            progress = ProgressHUD.of(context);
                            progress?.showWithText('Uploading Details...');
                            final requestModelInstance =
                                InvestorSignupRequestModel.instance;
                            requestModelInstance.userType = 'investor';
                            User signedUpUser =
                                await SignUpService.uploadUserDetails(
                                    requestModelInstance);
                            progress.dismiss();
                            if (signedUpUser.type == 'success') {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final userJson = jsonEncode(signedUpUser.data);
                              prefs.setString('UserInfo', userJson);
                              openNextScreen();
                            } else {
                              showSnackBar(context, "Something went wrong");
                            }
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
        ),
      ),
    );
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

  void openNextScreen() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return ThankYouInvestor();
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
}
