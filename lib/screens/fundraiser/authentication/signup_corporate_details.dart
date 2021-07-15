import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:acc/models/profile/basic_details.dart';
import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/screens/investor/welcome.dart';
import 'package:acc/services/ProfileService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';

import '../../../utils/code_utils.dart';

class CorporateDetails extends StatefulWidget {
  @override
  _CorporateDetailsState createState() => _CorporateDetailsState();
}

class _CorporateDetailsState extends State<CorporateDetails> {
  User _user;
  String firstname = "";
  String lastname = "";
  String title = "";
  String company_name = "";
  String company_email = "";
  File profilePhoto;
  var progress;
  var firstNameController = TextEditingController();
  var lastnameController = TextEditingController();
  var titleController = TextEditingController();
  var companyNameController = TextEditingController();
  var companyEmailController = TextEditingController();
  bool _displayConfirmationText = false;
  String nextButtonText = "Submit for Verification";

  void showConfirmationText() {
    setState(() {
      _displayConfirmationText = true;
    });
  }

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
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0, left: 25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Corporate Sign Up",
                                            style: textBold28(headingBlack),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Please fill out your representative details",
                                            style: textNormal18(textGrey),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  // TEXT FIELDS
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textBlackNormal18(),
                                      controller: firstNameController,
                                      onChanged: (value) => {firstname = value},
                                      decoration:
                                          _setTextFieldDecoration("Firstname"),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      controller: lastnameController,
                                      style: textBlackNormal18(),
                                      onChanged: (value) => lastname = value,
                                      decoration:
                                          _setTextFieldDecoration("Lastname"),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      controller: titleController,
                                      style: textBlackNormal18(),
                                      onChanged: (value) => title = value,
                                      decoration:
                                          _setTextFieldDecoration("Title"),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textBlackNormal18(),
                                      controller: companyNameController,
                                      onChanged: (value) =>
                                          company_name = value,
                                      decoration: _setTextFieldDecoration(
                                          "Company Name"),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, left: 25.0, right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textBlackNormal18(),
                                      controller: companyEmailController,
                                      onChanged: (value) =>
                                          company_email = value,
                                      decoration: _setTextFieldDecoration(
                                          "Company Email Id"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Visibility(
                                      visible: _displayConfirmationText,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              bottom: 10.0),
                                          child: Text(
                                            corporateVerificationText,
                                            textAlign: TextAlign.center,
                                            style: textNormal16(
                                                HexColor("#FE904B")),
                                          ))),
                                  //NEXT BUTTON
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 25.0,
                                          bottom: 20,
                                          right: 25.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // on click
                                          if (firstNameController
                                              .text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the Firstname.");
                                            return;
                                          }
                                          if (lastnameController.text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the Lastname.");
                                            return;
                                          }
                                          if (titleController.text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the title.");
                                            return;
                                          }
                                          if (companyEmailController
                                              .text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the email id.");
                                            return;
                                          }
                                          if (CodeUtils.emailValid(
                                              companyEmailController.text)) {
                                            showSnackBar(context,
                                                "Please enter a valid email id.");
                                            return;
                                          }
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (nextButtonText ==
                                              'Back to Home') {
                                            // open onboarding again
                                            openOnboarding();
                                          }

                                          setState(() {
                                            showConfirmationText();
                                            nextButtonText = 'Back to Home';
                                          });

                                          // progress = ProgressHUD.of(context);
                                          // progress?.showWithText('Uploading Details...');
                                          // submitDetails(
                                          //   firstNameController.text.trim(),
                                          //   lastnameController.text.trim(),
                                          //   titleController.text.trim(),
                                          //   country,
                                          //   addressController.text,
                                          // );
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18))),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      kDarkOrange,
                                                      kLightOrange
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 60,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  nextButtonText,
                                                  style: textWhiteBold18(),
                                                ))),
                                      )),
                                ])
                          ])),
                    ))));
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

  InputDecoration _setTextFieldDecoration(_text) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10.0),
      labelText: _text,
      labelStyle: new TextStyle(color: Colors.grey[600]),
      border: InputBorder.none,
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
        borderRadius: BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
    );
  }

  TextField inputTextField(text) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: 'Poppins-Regular'),
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: text,
        labelStyle: new TextStyle(color: Colors.grey[600]),
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> submitDetails(
    String firstName,
    String lastName,
    String emailId,
    String countryCode,
    String address,
  ) async {
    UpdateBasicDetails basicDetails = await ProfileService.updateBasicDetails(
        firstName, lastName, emailId, countryCode, address);
    print('BD type: ${basicDetails.type}');
    print('BD status: ${basicDetails.status}');
    print('BD message: ${basicDetails.message}');
    progress.dismiss();
    if (basicDetails.type == "success") {
      openWelcomeInvestor();
    } else {
      showSnackBar(context, "Something went wrong");
    }
  }

  void openWelcomeInvestor() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return WelcomeInvestor();
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

  void openOnboarding() {
    Navigator.of(context).pushAndRemoveUntil(
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
        (Route<dynamic> route) => false);
  }
}
