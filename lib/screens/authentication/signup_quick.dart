import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/authentication/signup_details.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_management/services/AuthenticationService.dart';

import 'package:portfolio_management/utilites/ui_widgets.dart';

class QuickSignUp extends StatefulWidget {
  @override
  _QuickSignUpState createState() => _QuickSignUpState();
}

class _QuickSignUpState extends State<QuickSignUp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));
    return Scaffold(
      backgroundColor: Color(0xffffffff),
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
                      "Quick Sign Up",
                      style: TextStyle(
                          color: headingBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          fontFamily: 'Poppins-Light'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                    child: Text(
                      "You can easily sign up via",
                      style: TextStyle(
                          color: textGrey,
                          fontWeight: FontWeight.normal,
                          fontSize: 20.0,
                          fontFamily: 'Poppins-Regular'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Apple Login
                  Container(
                      margin: const EdgeInsets.only(
                        top: 15.0,
                        bottom: 5,
                      ),
                      child: createButton("Apple")),
                  //Google Button
                  Container(
                    margin: const EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: createButton("Google"),
                  ),
                  Center(
                    child: Text(
                      "or",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'Poppins-Regular'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(
                      "Use your email address to sign up",
                      style: TextStyle(
                          color: textGrey,
                          fontSize: 18.0,
                          fontFamily: 'Poppins-Regular'),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  //SIGN UP BUTTON
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 40.0, bottom: 20, right: 40.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        // on sign up click
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpDetails()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: appColorButton(),
                        child: Center(
                            child: Text(
                          "Sign up",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  // TERMS AND CONDITIONS
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "By signing in, I agree with ",
                          style: setTextStyle(textLightGrey),
                          children: [
                            TextSpan(
                              text: "Terms of Use ",
                              style: setTextStyle(Colors.black),
                            ),
                            TextSpan(
                              text: "\n and ",
                              style: setTextStyle(textLightGrey),
                            ),
                            TextSpan(
                              text: "Privacy Poicy",
                              style: setTextStyle(Colors.black),
                            )
                          ]),
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

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 16, fontWeight: FontWeight.w500);
  }

  InkWell createButton(type) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        if (type == "Apple") {
          context.read<AuthenticationService>().signInWithApple();
        } else if (type == "Google") {
          context.read<AuthenticationService>().signInWithGoogle();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Row(
          children: [
            Image.asset(
              _setImage(type),
              width: MediaQuery.of(context).size.width,
            ),
          ],
        )),
      ),
    );
  }

  // ignore: missing_return
  String _setImage(type) {
    if (type == "Apple") {
      return "assets/images/connect_apple.png";
    } else if (type == "Google") {
      return "assets/images/connect_google.png";
      //return "assets/images/social_media/google.png";
    }
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
