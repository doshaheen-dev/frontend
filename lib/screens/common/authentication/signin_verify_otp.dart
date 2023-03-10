import 'dart:convert';

import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/screens/fundraiser/authentication/email_verification.dart';
import 'package:acc/screens/investor/dashboard/investor_dashboard.dart';
import 'package:acc/screens/investor/welcome.dart';
import 'package:acc/widgets/app_progressbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_dashboard.dart';
import 'package:acc/services/OtpService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';

import 'package:acc/utilites/ui_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInVerifyOTP extends StatefulWidget {
  final String _verificationId;
  final String _phoneNumber;
  final String _otpType;

  const SignInVerifyOTP(
      {Key key, String verificationId, String phoneNumber, String otpType})
      : _verificationId = verificationId,
        _phoneNumber = phoneNumber,
        _otpType = otpType,
        super(key: key);

  @override
  _SignInVerifyOTPState createState() => _SignInVerifyOTPState();
}

class _SignInVerifyOTPState extends State<SignInVerifyOTP> {
  String currentText = "";
  bool hasError = false;

  String _verificationId;
  String _phoneNumber;
  String _otpType;

  TextEditingController otpController = new TextEditingController();
  var progress;

  int totalRecommendationItems;

  @override
  void initState() {
    _verificationId = widget._verificationId;
    _phoneNumber = widget._phoneNumber;
    _otpType = widget._otpType;
    super.initState();
  }

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
                                      margin: const EdgeInsets.only(left: 25.0),
                                      child: Text("Enter OTP",
                                          style: textBold26(
                                              Theme.of(context).accentColor)),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5.0, left: 25.0, right: 25.0),
                                      child: Text(
                                          "Please enter the OTP received in your mobile phone or Email ID.",
                                          style: textNormal16(textGrey)),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          top: 5.0, left: 40.0, right: 40.0),
                                      child: PinCodeTextField(
                                        controller: otpController,
                                        appContext: context,
                                        pastedTextStyle: textNormal16(textGrey),
                                        length: 6,
                                        animationType: AnimationType.none,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.underline,
                                          selectedColor: Colors.grey,
                                          inactiveColor: Colors.grey,
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          activeFillColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        cursorColor: Colors.black,
                                        enableActiveFill: false,
                                        keyboardType: TextInputType.number,
                                        onCompleted: (v) {},
                                        onChanged: (value) {
                                          setState(() {
                                            currentText = value;
                                          });
                                        },
                                        beforeTextPaste: (text) {
                                          return false;
                                        },
                                      ),
                                    ),

                                    Container(
                                        margin: EdgeInsets.only(right: 20.0),
                                        alignment: Alignment.topRight,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text: "Didn't receive the OTP? ",
                                              style: textNormal16(textGrey),
                                              children: [
                                                TextSpan(
                                                    text: 'Resend OTP',
                                                    style: textNormal16(
                                                        Theme.of(context)
                                                            .accentColor),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            progress =
                                                                AppProgressBar
                                                                    .of(context);
                                                            progress
                                                                ?.showWithText(
                                                                    sendingOtp);
                                                            otpController
                                                                .clear();
                                                            sendOTPServer();
                                                          })
                                              ]),
                                        )),

                                    SizedBox(
                                      height: 30,
                                    ),
                                    //Verify BUTTON
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 5.0,
                                            left: 40.0,
                                            bottom: 20,
                                            right: 40.0),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              if (otpController.text.isEmpty) {
                                                showSnackBar(
                                                    context, warningOTP);
                                                return;
                                              }
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              signIn(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(0.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        18))),
                                            child: Ink(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(colors: [
                                                      Theme.of(context)
                                                          .primaryColor,
                                                      Theme.of(context)
                                                          .primaryColor
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 60,
                                                    alignment: Alignment.center,
                                                    child: Text(verifyOtp, style: textWhiteBold18())))))
                                  ])
                            ]),
                      ))),
            )));
  }

  void signIn(BuildContext context) {
    progress = AppProgressBar.of(context);
    progress?.showWithText(verifyingOtp);

    verifyPhoneUser("", _phoneNumber, _otpType,
        otpController.text.trim().toString(), _verificationId);
  }

  Future<void> openHome(UserData data) {
    print("data:- ${data.mobileNo}");
    if (data.userType == "Investor" ||
        data.userType == "investor" ||
        data.userType == "") {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: (context, animation, anotherAnimation) {
                if (data.slotId == null &&
                    (data.productIds == null || data.productIds == '')) {
                  return WelcomeInvestor();
                } else {
                  return InvestorDashboard(userData: data);
                }
              },
              transitionDuration: Duration(milliseconds: 2000),
              transitionsBuilder:
                  (context, animation, anotherAnimation, child) {
                animation = CurvedAnimation(
                    curve: Curves.fastLinearToSlowEaseIn, parent: animation);
                return SlideTransition(
                  position:
                      Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                  child: child,
                );
              }),
          (Route<dynamic> route) => false);
    } else if (data.userType == "Fundraiser" || data.userType == "fundraiser") {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: (context, animation, anotherAnimation) {
                if (data.emailVerified == 1) {
                  return FundraiserDashboard();
                } else {
                  return EmailVerification();
                }
              },
              transitionDuration: Duration(milliseconds: 2000),
              transitionsBuilder:
                  (context, animation, anotherAnimation, child) {
                animation = CurvedAnimation(
                    curve: Curves.fastLinearToSlowEaseIn, parent: animation);
                return SlideTransition(
                  position:
                      Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                  child: child,
                );
              }),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> sendOTPServer() async {
    Future.delayed(Duration(seconds: 2), () async {
      VerificationIdSignIn verificationIdSignIn =
          await OtpService.getVerificationFromTwillio(
              _phoneNumber, _otpType, "twilio");

      progress.dismiss();
      if (verificationIdSignIn.type == "success") {
        _verificationId = verificationIdSignIn.data.verificationId;
      }
      showSnackBar(context, verificationIdSignIn.message);
    });
  }

  Future<void> verifyPhoneUser(String token, String phoneNumber, String otpType,
      String smsCode, String verificationId) async {
    UserSignIn verifyPhoneNumber = await OtpService.verifyUserByServer(
        token, phoneNumber, verificationId, smsCode, otpType);
    progress.dismiss();

    if (verifyPhoneNumber == null) {
      progress.dismiss();
      showSnackBar(context, "Please check your credentials");
      return;
    }
    if (verifyPhoneNumber.type == "success") {
      saveUserInfo(verifyPhoneNumber.data);
      openHome(verifyPhoneNumber.data);
    } else {
      _openDialog(context, verifyPhoneNumber.message);
    }
  }

  Future<void> saveUserInfo(UserData data) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(data);
    prefs.setString('UserInfo', userJson);
    UserData.instance.userInfo = data;
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Ok",
          textScaleFactor: 1.0,
          style: textNormal16(Color(0xff00A699)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message, textScaleFactor: 1.0),
      actions: [
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
