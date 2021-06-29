import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/signup_email.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'common/utilites/ui_widgets.dart';

class SignUpVerifyOTP extends StatefulWidget {
  @override
  _SignUpVerifyOTPState createState() => _SignUpVerifyOTPState();
}

class _SignUpVerifyOTPState extends State<SignUpVerifyOTP> {
  String currentText = "";
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
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
              Material(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                      child: Text(
                        "Enter Your OTP",
                        style: TextStyle(
                            color: Colors.black,
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
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
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
                        appContext: context,
                        pastedTextStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                        length: 4,
                        animationType: AnimationType.none,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          selectedColor: Colors.grey,
                          fieldWidth: 60,
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
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          print("Completed " + currentText);
                          //Open new view
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpEmail()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: appColorButton(),
                          child: Center(
                              child: Text(
                            "Verify OTP",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
