import 'dart:io';

import 'package:acc/constants/font_family.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/widgets/app_progressbar.dart';
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
  final String phoneNumber;

  const QuickSignUp({Key key, String mobileNumber})
      : phoneNumber = mobileNumber,
        super(key: key);

  @override
  _QuickSignUpState createState() => _QuickSignUpState();
}

class _QuickSignUpState extends State<QuickSignUp> {
  var progress;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                elevation: 0.0,
                backgroundColor: Color(0xffffffff),
              ),
              bottomNavigationBar: BottomAppBar(),
              backgroundColor: Color(0xffffffff),
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
                            onPressed: () => {_onBackPressed()},
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 10.0, left: 25.0),
                              child: Text("Register Your Email",
                                  style: textBold26(
                                      Theme.of(context).accentColor)),
                            ),

                            // Apple Login
                            Container(
                                margin: const EdgeInsets.only(
                                  top: 20.0,
                                  bottom: 5,
                                ),
                                child: createButton(context, "Apple")),
                            //Google Button
                            Container(
                              margin: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: createButton(context, "Google"),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Center(
                              child:
                                  Text("or", style: textBold16(Colors.black)),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Center(
                              child: Text("Use your email address to register",
                                  style: textNormal16(textGrey)),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),

                            //SIGN UP BUTTON
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 40.0, bottom: 20, right: 40.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {
                                    // on sign up click
                                    openSignUpDetails(null);
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      decoration: appColorButton(context),
                                      child: Center(
                                          child: Text("Register",
                                              style: textWhiteBold18()))),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
                ),
              )),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?', style: textNormal16(headingBlack)),
            content: new Text('You want to cancel your signup',
                style: textNormal14(headingBlack)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigation.openOnBoarding(context);
                  },
                  child: Text(
                    "Yes",
                    style: textNormal14(Theme.of(context).primaryColor),
                  )),
              SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: textNormal14(Theme.of(context).primaryColor),
                  )),
            ],
          ),
        ) ??
        false;
  }

  InkWell createButton(BuildContext context, type) {
    print(type);
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () async {
        progress = AppProgressBar.of(context);
        progress?.showWithText('Loading...');

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
  }

  void checkUserAndNavigate(User user) {
    progress.dismiss();
    if (user != null) {
      openSignUpDetails(user);
    } else {
      final snackBar = SnackBar(
        content: Text('No user found. Try again!!'),
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
    try {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return SignUpDetails(user: user, mobileNumber: widget.phoneNumber);
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
    } catch (e) {
      print("Err: ${e.toString()}");
    }
  }
}
