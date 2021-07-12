import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:portfolio_management/models/authentication/verify_phone_signin.dart';
import 'package:portfolio_management/screens/investor/dashboard/investor_dashboard.dart';
import 'package:portfolio_management/services/OtpService.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

import 'package:portfolio_management/utilites/ui_widgets.dart';

class SignInVerifyOTP extends StatefulWidget {
  final String _verificationId;
  final String _phoneNumber;
  final String _otpType;
  final String _requesterType;

  const SignInVerifyOTP(
      {Key key,
      String verificationId,
      String phoneNumber,
      String otpType,
      String requesterType})
      : _verificationId = verificationId,
        _phoneNumber = phoneNumber,
        _otpType = otpType,
        _requesterType = requesterType,
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
  String _requesterType;

  TextEditingController otpController = new TextEditingController();
  var progress;

  @override
  void initState() {
    _verificationId = widget._verificationId;
    _phoneNumber = widget._phoneNumber;
    _otpType = widget._otpType;
    _requesterType = widget._requesterType;
    super.initState();
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
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                        child: Text(
                          "Enter Your OTP",
                          style: TextStyle(
                              color: headingBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                        child: Text(
                          "Enter the OTP sent to your mobile/email",
                          style: TextStyle(
                              color: textGrey,
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 40.0, bottom: 20, right: 40.0),
                        child: PinCodeTextField(
                          controller: otpController,
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                          length: 6,
                          animationType: AnimationType.none,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            selectedColor: Colors.grey,
                            inactiveColor: Colors.grey,
                            activeColor: Colors.orange,
                            activeFillColor: Colors.orange,
                          ),
                          cursorColor: Colors.black,
                          enableActiveFill: false,
                          keyboardType: TextInputType.number,
                          onCompleted: (v) {
                            print("Completed " + v);
                          },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      //Verify BUTTON
                      Container(
                          margin: const EdgeInsets.only(
                              top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (otpController.text.isEmpty) {
                                showSnackBar(context,
                                    "Please enter OTP sent to your mobile number.");
                                return;
                              }
                              FocusScope.of(context).requestFocus(FocusNode());

                              progress = ProgressHUD.of(context);
                              progress?.showWithText('Verifying OTP...');
                              // verifyUser(otpController.text, _verificationId,
                              //     _phoneNumber);

                              //mobile
                              print(
                                  "---> $_otpType _requesterType => $_requesterType");
                              if (_otpType == "mobile" &&
                                  _requesterType == "firebase") {
                                _verifyOtpByFirebase(
                                    otpController.text,
                                    _verificationId,
                                    _phoneNumber,
                                    _otpType,
                                    _requesterType);
                              } else {
                                // 1. email using firebase or
                                // 2. email mobile using twillo
                                print(
                                    "SIGNIN Header => $_otpType, phoneNumber => $_phoneNumber, verificationId => $_verificationId, smsCode => ${otpController.text}");
                                verifyPhoneUser(
                                    "",
                                    _phoneNumber,
                                    _otpType,
                                    otpController.text.trim().toString(),
                                    _verificationId,
                                    _requesterType);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [kDarkOrange, kLightOrange]),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'Poppins-Regular',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  void openHome() {
    Navigator.of(context).pushAndRemoveUntil(
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
        (Route<dynamic> route) => false);
  }

  Future<void> _verifyOtpByFirebase(String text, String verificationId,
      String phoneNumber, String otpType, String requesterType) async {
    String smsCode = text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    AuthCredential _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this._verificationId, smsCode: smsCode);

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("verificationId => ${verificationId}");
      print("userResult -> ${userResult.toString()}");
      final User currentUser = await FirebaseAuth.instance.currentUser;
      print("User => ${currentUser.toString()}");
      if (currentUser != null) {
        currentUser.getIdToken().then((token) async {
          //verify number
          print("VERIFY");
          verifyPhoneUser(token.toString(), phoneNumber, otpType, smsCode,
              verificationId, requesterType);
        });
      } else {
        progress.dismiss();
        showSnackBar(context, "Something went wrong");
      }
    } catch (e) {
      progress.dismiss();
      print("Error -> ${e.toString()}");
    }
  }

  Future<void> verifyPhoneUser(String token, String phoneNumber, String otpType,
      String smsCode, String verificationId, String requesterType) async {
    VerifyPhoneNumberSignIn verifyPhoneNumber =
        await OtpService.verifyUserByServer(token, phoneNumber, verificationId,
            smsCode, otpType, requesterType);
    progress.dismiss();
    print("veriyPhone :- ${verifyPhoneNumber.type}");
    print("veriyPhone :- ${verifyPhoneNumber.status}");
    print("veriyPhone :- ${verifyPhoneNumber.message}");
    print("veriyPhone :- ${verifyPhoneNumber.data}");
    if (verifyPhoneNumber.type == "success") {
      showSnackBarWithoutButton(context, verifyPhoneNumber.message);
      openHome();
    } else {
      _openDialog(context, verifyPhoneNumber.message);
    }
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Ok",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xff00A699),
              fontSize: 16.0,
              fontFamily: 'Poppins-Regular')),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
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
