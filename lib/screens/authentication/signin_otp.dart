import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:portfolio_management/screens/authentication/signin_verify_otp.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

import 'package:portfolio_management/utilites/ui_widgets.dart';

class SignInOTP extends StatefulWidget {
  @override
  _SignInOTPState createState() => _SignInOTPState();
}

bool emailValid(String input) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(input);

class _SignInOTPState extends State<SignInOTP> {
  TextEditingController phoneController = new TextEditingController();
  var progress;

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  bool _isButtonVisible = true;

  void showToast() {
    setState(() {
      _isButtonVisible = true;
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
                            width: 60,
                            height: 60,
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
                                      top: 10.0, left: 25.0),
                                  child: Text(
                                    "Login here",
                                    style: TextStyle(
                                        color: headingBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.0,
                                        fontFamily: 'Poppins-Regular'),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0, left: 25.0),
                                  child: Text(
                                    "You can easily login via mobile number.",
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: _isButtonVisible,
                                      child: Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 5.0,
                                                left: 25.0,
                                                bottom: 20,
                                                right: 5.0),
                                            decoration: customDecoration(),
                                            child: dropdownField(),
                                          )),
                                    ),
                                    Container(
                                      width: 1,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 5.0,
                                            bottom: 20,
                                            left: 25.0,
                                            right: 25.0),
                                        decoration: customDecoration(),
                                        child: inputTextField(
                                            "Mobile Number or Email Id",
                                            phoneController),
                                      ),
                                    ),
                                  ],
                                ),

                                //SIGN IN BUTTON
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (phoneController.text.isEmpty) {
                                          showSnackBar(context,
                                              "Please enter mobile number or email.");
                                          return;
                                        }
                                        if (isPhone(phoneController.text)) {
                                          print("mobile");
                                          progress = ProgressHUD.of(context);
                                          progress?.show();
                                          progress
                                              ?.showWithText('Sending OTP...');
                                          openSignInVerifyOTP();
                                          // _submitPhoneNumber(
                                          //     phoneController.text);
                                        } else if (emailValid(
                                            phoneController.text)) {
                                          print("email");
                                        } else {
                                          showSnackBar(context,
                                              "Please enter correct mobile number or email");
                                          return;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18))),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              kDarkOrange,
                                              kLightOrange
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Send OTP',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ))
                              ])
                        ]))))));
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[200],
        ),
      ],
    );
  }

  String _value = '+91';
  Widget dropdownField() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      child: DropdownButtonFormField(
          decoration: InputDecoration(
              labelText: 'Code',
              labelStyle: new TextStyle(color: Colors.grey[600]),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent))),
          value: _value,
          items: [
            DropdownMenuItem(
              child: Text(
                "+91",
              ),
              value: '+91',
            ),
            DropdownMenuItem(
              child: Text("+1"),
              value: '+1',
            ),
            DropdownMenuItem(
              child: Text("+852"),
              value: '+852',
            ),
          ],
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          }),
    );
  }

  TextField inputTextField(text, controller) {
    return TextField(
      onChanged: (text) {
        print(text);
        if (emailValid(text)) {
          setState(() {
            _isButtonVisible = false;
          });
        } else if (text == null) {
          setState(() {
            _isButtonVisible = true;
          });
        } else {
          setState(() {
            _isButtonVisible = true;
          });
        }
      },
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: 'Poppins-Regular'),
      controller: controller,
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
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

  void openSignInVerifyOTP() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignInVerifyOTP();
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

  Future<void> _submitPhoneNumber(String text) async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + text.toString().trim();
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      progress.dismiss();
      print('verificationCompleted');

      print(" token :- ${phoneAuthCredential.token}");
    }

    void verificationFailed(FirebaseAuthException error) {
      progress.dismiss();
      showSnackBar(context, "Something went wrong. Try again!!");
      print('verificationFailed ${error}');
    }

    void codeSent(String verificationId, [int code]) {
      print(verificationId);
      print("Code sent ${code.toString()}");
      progress?.showWithText('OTP Sent Successfully...');
      Future.delayed(Duration(milliseconds: 2), () {
        progress.dismiss();
        openSignInVerifyOTP();
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      progress.dismiss();
      print('codeAutoRetrievalTimeout');
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      /// When this function is called there is no need to enter the OTP, you can click on Login button to sigin directly as the device is now verified
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }
}
