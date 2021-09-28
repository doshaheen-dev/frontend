import 'package:acc/screens/common/authentication/signin_otp.dart';
import 'package:acc/screens/common/onboarding.dart';
import 'package:flutter/material.dart';

class Navigation {
  static void openOnBoarding(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return OnBoarding();
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

  static void openSignIn(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return SignInOTP();
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
}
