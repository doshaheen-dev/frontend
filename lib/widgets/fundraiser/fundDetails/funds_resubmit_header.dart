import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/common/profile_picture.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';

import '../../image_circle.dart';

class FundsResubmitHeader extends StatefulWidget {
  @override
  _FundsResubmitHeaderState createState() => _FundsResubmitHeaderState();
}

class _FundsResubmitHeaderState extends State<FundsResubmitHeader> {
  final double bRadius = 60;
  final double iHeight = 65;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.arrow_back_ios,
                    size: 30, color: backButtonColor),
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: UserData.instance.userInfo.firstName != null
                          ? Text(
                              'Hello ${UserData.instance.userInfo.firstName}',
                              style: textBold26(headingBlack),
                            )
                          : Text(
                              'Hello Fundraiser',
                              style: textBold26(headingBlack),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, anotherAnimation) {
                                    return ProfilePicScreen(UserData
                                        .instance.userInfo.profileImage);
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
                            )
                            .then((_) => setState(() {}));
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        child: CircleAvatar(
                          radius: bRadius,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: (UserData.instance.userInfo.profileImage ==
                                      null ||
                                  UserData.instance.userInfo.profileImage == '')
                              ? ImageCircle(
                                  borderRadius: bRadius,
                                  image: Image.asset(
                                    'assets/images/UserProfile.png',
                                    width: iHeight,
                                    height: iHeight,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : ImageCircle(
                                  borderRadius: bRadius,
                                  image: Image.network(
                                    UserData.instance.userInfo.profileImage,
                                    width: iHeight,
                                    height: iHeight,
                                    fit: BoxFit.fill,
                                  )),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Review and Resubmit your Fund",
                style: textBold18(headingBlack),
              ),
            )
          ],
        ));
  }
}
