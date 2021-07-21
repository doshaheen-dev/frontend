import 'package:acc/screens/fundraiser/dashboard/fundraiser_profile.dart';
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Container(
        child: Column(
          children: [
            Container(
                margin:
                    const EdgeInsets.only(top: 80.0, left: 15.0, right: 25.0),
                child: Row(
                  children: [
                    Image.asset('assets/images/investor/icon_menu.png'),
                    SizedBox(width: 10.0),
                    Expanded(
                        child: Text(
                      'Hello  Fundraiser',
                      style: textBold26(headingBlack),
                    )),
                    Image.asset('assets/images/investor/icon_investor.png'),
                  ],
                )),
            Expanded(child: buildPageView())
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
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
