import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/authentication/signin_otp.dart';
import 'package:portfolio_management/screens/common/user_type.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/ui_widgets.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentPageValue = 0;
  int previousPageValue = 0;
  PageController controller;
  double _moveBar = 0.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    controller = PageController(initialPage: currentPageValue);
  }

  @override
  Widget build(BuildContext context) {
    if (currentPageValue == 0) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(statusBarColor: statusGrey));
    } else if (currentPageValue == 1) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(statusBarColor: statusGrey1));
    } else if (currentPageValue == 2) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(statusBarColor: statusGrey2));
    } else {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(statusBarColor: statusGrey));
    }
    final List<Widget> introWidgetsList = <Widget>[
      Stack(
        children: [
          Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/onboarding/onboarding_first.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
                _addLogo(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(25.0),
            child: Text(
              "Find an investment opportunity\nthat's right for you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: 'Poppins-Regular'),
            ),
          )
        ],
      ),
      Stack(
        children: [
          Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/onboarding/onboarding_second.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
                _addLogo(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(25.0),
            child: Text(
              "Looking for an investor?\nWe will find it for you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: 'Poppins-Regular'),
            ),
          )
        ],
      ),
      Stack(
        children: [
          Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/onboarding/onboarding_third.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
                _addLogo(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(25.0),
            child: Text(
              "Increase your capital gains? Let \nus take the risk",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins-Regular'),
            ),
          )
        ],
      ),
    ];

    return MaterialApp(
        theme: ThemeData(backgroundColor: Colors.white),
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Slider View
                Expanded(
                  child: Container(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        PageView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: introWidgetsList.length,
                          onPageChanged: (int page) {
                            getChangedPageAndMoveBar(page);
                          },
                          controller: controller,
                          itemBuilder: (context, index) {
                            return introWidgetsList[index];
                          },
                        ),
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Divider(color: Colors.white70),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 100),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  for (int i = 0;
                                      i < introWidgetsList.length;
                                      i++)
                                    if (i == currentPageValue) ...[
                                      circleBar(true, i)
                                    ] else
                                      circleBar(false, i),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom view
                Container(
                  color: kDarkGrey,
                  height: 150,
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          // Open  view
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, anotherAnimation) {
                                return UserType();
                              },
                              transitionDuration: Duration(milliseconds: 2000),
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
                              }));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 25.0, right: 25.0),
                          height: 60,
                          decoration: appColorButton(),
                          child: Center(
                              child: Text(
                            "Join our community",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "Already a member? ",
                              style: setTextStyle(textDarkOrange),
                              children: [
                                TextSpan(
                                    text: 'Sign In',
                                    style: setTextStyle(kDarkOrange),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (context,
                                                    animation,
                                                    anotherAnimation) {
                                                  return SignInOTP();
                                                },
                                                transitionDuration: Duration(
                                                    milliseconds: 2000),
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
                                                            begin: Offset(
                                                                1.0, 0.0),
                                                            end: Offset(
                                                                0.0, 0.0))
                                                        .animate(animation),
                                                    child: child,
                                                  );
                                                }));
                                      }),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget circleBar(bool isActive, int currentPageValue) {
    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 2),
          margin: EdgeInsets.symmetric(horizontal: 8),
          height: 30.0,
          width: 30.0,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              (currentPageValue + 1).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins-Light'),
            ),
          ),
          decoration: BoxDecoration(
              color: isActive ? kwhiteGrey : kIndicatorInactive,
              borderRadius: BorderRadius.all(Radius.circular(20))),
        )
      ],
    );
  }

  void getChangedPageAndMoveBar(int page) {
    print('page is $page');

    currentPageValue = page;

    if (previousPageValue == 0) {
      previousPageValue = currentPageValue;
      _moveBar = _moveBar + 0.14;
    } else {
      if (previousPageValue < currentPageValue) {
        previousPageValue = currentPageValue;
        _moveBar = _moveBar + 0.14;
      } else {
        previousPageValue = currentPageValue;
        _moveBar = _moveBar - 0.14;
      }
    }
    setState(() {});
  }

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 16, fontWeight: FontWeight.w500);
  }

  Widget _addLogo() {
    return Container(
      margin: const EdgeInsets.only(left: 15.0),
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 160,
        height: 100,
      ),
    );
  }
}
