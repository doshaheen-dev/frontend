import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/authentication/signin_verify_otp.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

import 'package:portfolio_management/utilites/ui_widgets.dart';

class SignInOTP extends StatefulWidget {
  @override
  _SignInOTPState createState() => _SignInOTPState();
}

class _SignInOTPState extends State<SignInOTP> {
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
                    margin: const EdgeInsets.only(top: 10.0, left: 25.0),
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
                    margin: const EdgeInsets.only(top: 5.0, left: 25.0),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 5.0, left: 25.0, bottom: 20, right: 5.0),
                            decoration: customDecoration(),
                            child: dropdownField(),
                          )),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 5.0, bottom: 20, right: 25.0),
                          decoration: customDecoration(),
                          child: inputTextField("Mobile Number", null),
                        ),
                      ),
                    ],
                  ),

                  //SIGN IN BUTTON
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        // Open otp view
                        openSignInVerifyOTP();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: appColorButton(),
                        child: Center(
                            child: Text(
                          "Send OTP",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Poppins-Regular',
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
              child: Text("+91"),
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
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
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
}
