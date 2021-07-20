import 'dart:io';

import 'package:acc/constants/font_family.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/authentication/signup_details.dart';
import 'package:acc/services/AuthenticationService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Color(0xffffffff),
      ),
      bottomNavigationBar: BottomAppBar(),
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
                      "Register Your Email",
                      style: TextStyle(
                          color: headingBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          fontFamily: FontFamilyMontserrat.name),
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
                          fontFamily: FontFamilyMontserrat.name),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(
                      "Use your email address to register",
                      style: TextStyle(
                          color: textGrey,
                          fontSize: 18.0,
                          fontFamily: FontFamilyMontserrat.name),
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
                        openSignUpDetails(null);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: appColorButton(),
                        child: Center(
                            child: Text(
                          "Register",
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
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //openSignIn(context);
                                  }),
                            TextSpan(
                              text: "\n and ",
                              style: setTextStyle(textLightGrey),
                            ),
                            TextSpan(
                                text: "Privacy Poicy",
                                style: setTextStyle(Colors.black),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //openSignIn(context);
                                  })
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
    print(type);
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () async {
        if (type == "Apple") {
          User user;
          if (Platform.isAndroid) {
            print("ANDROID");
            // Android-specific code
            user = await context
                .read<Authentication>()
                .appleAuthenticationAndroid();
          } else if (Platform.isIOS) {
            print("IOS");
            user = await context.read<Authentication>().signInWithApple();
            // iOS-specific code
          }
          checkUserAndNavigate(user);
        } else if (type == "Google") {
          await signInGoogle();
          // context.read<AuthenticationService>().signInWithGoogle();
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

  Future<void> signInGoogle() async {
    User user = await Authentication.signInWithGoogle(context: context);
    checkUserAndNavigate(user);
    print("Google => $user");
    // context.read<AuthenticationService>().signInWithGoogle();
  }

  void checkUserAndNavigate(User user) {
    if (user != null) {
      openSignUpDetails(user);
    } else {
      final snackBar = SnackBar(
        content: Text('Something went wrong. Try again!!'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Authentication.signOut();
    }
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

  void openSignUpDetails(User user) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignUpDetails(
            user: user,
            userAvatar: user != null ? user.photoURL : '',
          );
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
