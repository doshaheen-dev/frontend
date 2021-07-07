import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:portfolio_management/screens/dashboard/home.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

import 'package:portfolio_management/utilites/ui_widgets.dart';

class SignInVerifyOTP extends StatefulWidget {
  @override
  _SignInVerifyOTPState createState() => _SignInVerifyOTPState();
}

class _SignInVerifyOTPState extends State<SignInVerifyOTP> {
  String currentText = "";
  bool hasError = false;

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
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        print("Completed " + currentText);
                        //Open new view
                        openHome();
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
            ],
          ),
        ),
      ),
    );
  }

  void openHome() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return Home();
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
