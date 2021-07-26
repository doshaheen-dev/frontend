import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestorProfile extends StatefulWidget {
  InvestorProfile({Key key}) : super(key: key);

  @override
  _InvestorProfileState createState() => _InvestorProfileState();
}

class _InvestorProfileState extends State<InvestorProfile> {
  void openOnBoarding() {
    Navigator.pushAndRemoveUntil(
        context,
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
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 150.0, left: 25.0, bottom: 20, right: 25.0),
                child: ElevatedButton(
                    onPressed: () {
                      openLogoutDialog(
                          context, "Are you sure you want to logout?");
                    },
                    // onPressed: () async {
                    //   final prefs = await SharedPreferences.getInstance();
                    //   prefs.setString('UserInfo', '');
                    //   openOnBoarding();
                    // },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          alignment: Alignment.center,
                          child: Text("Logout",
                              style: textNormal(Colors.white, 16))),
                    )))));
  }

  openLogoutDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          openOnBoarding();
        },
        child: Text(
          "Yes",
          style: textNormal16(Color(0xff00A699)),
        ));

    Widget negativeButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text(
          "No",
          style: textNormal16(Color(0xff00A699)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
      actions: [positiveButton, negativeButton],
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
