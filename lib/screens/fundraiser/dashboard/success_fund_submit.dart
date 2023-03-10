import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/common/profile_picture.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_dashboard.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/image_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

class SuccesssFundSubmitted extends StatefulWidget {
  @override
  _SuccesssFundSubmittedState createState() => _SuccesssFundSubmittedState();
}

class _SuccesssFundSubmittedState extends State<SuccesssFundSubmitted> {
  final double bRadius = 60;
  final double iHeight = 65;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
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
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 25.0, right: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child:
                                  UserData.instance.userInfo.firstName != null
                                      ? Text(
                                          'Hello ${UserData.instance.userInfo.firstName}',
                                          style: textBold26(
                                              Theme.of(context).accentColor),
                                        )
                                      : Text(
                                          'Hello Fundraiser',
                                          style: textBold26(
                                              Theme.of(context).accentColor),
                                        ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              anotherAnimation) {
                                            return ProfilePicScreen(UserData
                                                .instance
                                                .userInfo
                                                .profileImage);
                                          },
                                          transitionDuration:
                                              Duration(milliseconds: 2000),
                                          transitionsBuilder: (context,
                                              animation,
                                              anotherAnimation,
                                              child) {
                                            animation = CurvedAnimation(
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn,
                                                parent: animation);
                                            return SlideTransition(
                                              position: Tween(
                                                      begin: Offset(1.0, 0.0),
                                                      end: Offset(0.0, 0.0))
                                                  .animate(animation),
                                              child: child,
                                            );
                                          }),
                                    )
                                    .then((_) => setState(() {}));
                              },
                              child: Container(
                                height: 70,
                                width: 70,
                                child: CircleAvatar(
                                  radius: bRadius,
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                  child: (UserData.instance.userInfo
                                                  .profileImage ==
                                              null ||
                                          UserData.instance.userInfo
                                                  .profileImage ==
                                              '')
                                      ? Image.asset(
                                          'assets/images/UserProfile.png',
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : ImageCircle(
                                          borderRadius: bRadius,
                                          image: Image.network(
                                            UserData
                                                .instance.userInfo.profileImage,
                                            width: iHeight,
                                            height: iHeight,
                                            fit: BoxFit.fill,
                                          )),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: Center(
                        child: Image.asset(
                          'assets/images/fundraiser/success_fundraiser.png',
                        ),
                      ),
                    ),
                    Container(
                        child: Center(
                      child: Column(
                        children: [
                          Text('THANK YOU',
                              textAlign: TextAlign.center,
                              style: textBold(headingBlack, 26)),
                          SizedBox(height: 50),
                          Text('Thank you for registering with us',
                              textAlign: TextAlign.center,
                              style: textNormal(textGrey, 16)),
                          Text(
                              'Our team will review and revert\nback to you at the earliest.',
                              textAlign: TextAlign.center,
                              style: textNormal(textGrey, 16))
                        ],
                      ),
                    )),
                    //NEXT BUTTON
                    Container(
                      margin: const EdgeInsets.only(
                          top: 30.0, left: 40.0, right: 40.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          // on click
                          Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, anotherAnimation) {
                                    return FundraiserDashboard();
                                  },
                                  transitionDuration:
                                      Duration(milliseconds: 2000),
                                  transitionsBuilder: (context, animation,
                                      anotherAnimation, child) {
                                    animation = CurvedAnimation(
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        parent: animation);
                                    return SlideTransition(
                                      position: Tween(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset(0.0, 0.0))
                                          .animate(animation),
                                      child: child,
                                    );
                                  }),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          height: 60,
                          decoration: appColorButton(context),
                          child: Center(
                              child: Text(
                            "Back to Home",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ])),
            )));
  }
}
