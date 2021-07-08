import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:portfolio_management/screens/authentication/signup_quick.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

import 'package:portfolio_management/utilites/ui_widgets.dart';

class SignUpVerifyOTP extends StatefulWidget {
  final String _verificationId;
  const SignUpVerifyOTP({Key key, String verificationId})
      : _verificationId = verificationId,
        super(key: key);

  @override
  _SignUpVerifyOTPState createState() => _SignUpVerifyOTPState();
}

class _SignUpVerifyOTPState extends State<SignUpVerifyOTP> {
  String currentText = "";
  bool hasError = false;
  String _verificationId;
  TextEditingController otpController = new TextEditingController();
  var progress;

  @override
  void initState() {
    _verificationId = widget._verificationId;
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
                          "Enter the OTP sent to your mobile",
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
                                showSnackBar(
                                    context, "Please enter phone number.");
                                return;
                              }
                              FocusScope.of(context).requestFocus(FocusNode());

                              progress = ProgressHUD.of(context);
                              // progress?.show();
                              progress?.showWithText('Verifying OTP...');
                              _verifyPhoneOTP(
                                  otpController.text, _verificationId);
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
                          ))

                      // Container(
                      //   margin: const EdgeInsets.only(
                      //       top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      //   child: InkWell(
                      //     borderRadius: BorderRadius.circular(40),
                      //     onTap: () {
                      //       print("Completed " + currentText);
                      //       //Open new view
                      //       openQuickSignUp();
                      //     },
                      //     child: Container(
                      //       width: MediaQuery.of(context).size.width,
                      //       height: 60,
                      //       decoration: appColorButton(),
                      //       child: Center(
                      //           child: Text(
                      //         "Verify OTP",
                      //         style: TextStyle(
                      //             fontSize: 18.0,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       )),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  void openQuickSignUp() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return QuickSignUp();
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

  AuthCredential _phoneAuthCredential;
  User _firebaseUser;

  Future<void> _verifyPhoneOTP(String text, [String verificationId]) async {
    String smsCode = text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this._verificationId, smsCode: smsCode);

    // try {
    //   await FirebaseAuth.instance
    //       .signInWithCredential(this._phoneAuthCredential)
    //       .then((UserCredential authRes) async {
    //     _firebaseUser = authRes.user;
    //     final User currentUser = await authRes.user;
    //     print(_firebaseUser.toString());
    //     print(currentUser.toString());
    //     progress.dismiss();
    //   }).catchError((e) => print(e));
    //   setState(() {
    //   //  print('Signed In\n');
    //   });
    // } catch (e) {
    //  // print(e);
    // }

    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User currentUser = await FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        currentUser.getIdToken().then((token) {
          print("Token -> ${token.toString()}");
        });
      }
      print("User => ${currentUser.toString()}");
    } catch (e) {
      print("Error -> ${e.toString()}");
    }
  }
}
