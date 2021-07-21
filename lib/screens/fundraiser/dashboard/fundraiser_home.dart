import 'package:flutter/material.dart';
import 'package:acc/screens/explore.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';

class FundraiserHome extends StatefulWidget {
  FundraiserHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FundraiserHomeState();
}

bool _fundsAvailable = false;

class _FundraiserHomeState extends State<FundraiserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(right: 30.0, left: 30.0),
                child: Visibility(
                    visible: !_fundsAvailable,
                    child: Column(
                      children: [
                        Text("You have not adedd any funds yet.",
                            style: textBlackNormal16()),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Open to add new funds
                                openAddNewFunds();
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
                                        addNewFunds,
                                        style: textWhiteBold18(),
                                      ))),
                            )),
                      ],
                    )))
          ],
        ));
  }

  void openAddNewFunds() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return Explore();
        },
        transitionDuration: Duration(milliseconds: 1000),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation =
              CurvedAnimation(curve: Curves.easeInOutExpo, parent: animation);
          return SlideTransition(
            position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          );
        }));
  }
}
