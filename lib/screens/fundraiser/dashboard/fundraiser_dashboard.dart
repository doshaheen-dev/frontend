import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/common/profile_picture.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_profile.dart';
import 'package:acc/widgets/image_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';

import 'fundraiser_home.dart';

class FundraiserDashboard extends StatefulWidget {
  FundraiserDashboard({Key key}) : super(key: key);

  @override
  _FundraiserDashboardState createState() => _FundraiserDashboardState();
}

class _FundraiserDashboardState extends State<FundraiserDashboard> {
  int bottomSelectedIndex = 0;
  final double bRadius = 60;
  final double iHeight = 65;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
          body: Container(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        top: 60.0, left: 25.0, right: 25.0),
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
                                      pageBuilder: (context, animation,
                                          anotherAnimation) {
                                        return ProfilePicScreen(UserData
                                            .instance.userInfo.profileImage);
                                      },
                                      transitionDuration:
                                          Duration(milliseconds: 2000),
                                      transitionsBuilder: (context, animation,
                                          anotherAnimation, child) {
                                        animation = CurvedAnimation(
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
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
                              backgroundColor: Colors.orange,
                              child: (UserData.instance.userInfo.profileImage ==
                                          null ||
                                      UserData.instance.userInfo.profileImage ==
                                          '')
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
                Expanded(child: buildPageView())
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 150,
            child: BottomNavigationBar(
              backgroundColor: Color(0xffffffff),
              elevation: 0.0,
              currentIndex: bottomSelectedIndex,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                bottomTapped(index);
              },
              items: buildBottomNavBarItems(),
            ),
          ),
        ));
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/dashboard/nav_home.png'),
        tooltip: "Home",
        title: Text(
          "Home",
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/dashboard/nav_suitcase.png'),
        tooltip: "Suitcase",
        title: Text(
          "Suitcase",
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/dashboard/nav_money.png'),
        tooltip: "Money",
        title: Text(
          "Money",
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/dashboard/nav_thumbsup.png'),
        tooltip: "Like",
        title: Text(
          "Like",
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/dashboard/nav_profile.png'),
        tooltip: "Profile",
        title: Text(
          "Profile",
        ),
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        FundraiserHome(),
        Blue(),
        Yellow(),
        Red(),
        FundraiserProfile(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;

      pageController.jumpToPage(
        index,
      );
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Yes",
                    style: textNormal16(selectedOrange),
                  )),
              SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: textNormal16(selectedOrange),
                  )),
            ],
          ),
        ) ??
        false;
  }

  openDialog() {
    // set up the AlertDialog
    Widget positiveButton = new GestureDetector(
      onTap: () => Navigator.of(context).pop(false),
      child: Text(
        "Yes",
      ),
    );
    Widget negativeButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop(false);
      },
      child: Text("No", style: textNormal16(selectedOrange)),
    );
    AlertDialog alert = AlertDialog(
      title: new Text('Are you sure?', style: textNormal16(headingBlack)),
      content: new Text('Do you want to exit an App',
          style: textNormal14(headingBlack)),
      actions: <Widget>[positiveButton, SizedBox(height: 16), negativeButton],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Red extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
    );
  }
}
