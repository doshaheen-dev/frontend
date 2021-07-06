import 'package:flutter/material.dart';
import 'package:portfolio_management/constants/theme_colors.dart';
import 'package:portfolio_management/screens/chat.dart';
import 'package:portfolio_management/screens/explore.dart';
import 'package:portfolio_management/screens/requests/requests.dart';
import '../data/services_data.dart';
import '../screens/profile_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTab = 0;

  List<Widget> _children = [
    Explore(),
    Requests(),
    ChatBot(),
    //ProfilePage(DUMMY_SERVICES),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFE7EBEE),
      body: _children[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          selectedItemColor: ThemeColor.greenColor,
          unselectedItemColor: Colors.grey[800],
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentTab,
          onTap: (int value) {
            setState(() {
              _currentTab = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
                size: 30,
              ),
              tooltip: "Explore",
              title: Text(
                "Explore",
                style: TextStyle(fontSize: 11),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.request_quote,
                //color: Colors.black,
                size: 30,
              ),
              tooltip: "Requests",
              title: Text(
                "Requests",
                style: TextStyle(fontSize: 11),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.question_answer,
                //color: Colors.black,
                size: 30,
              ),
              tooltip: "Chat",
              title: Text(
                "Chat",
                style: TextStyle(fontSize: 11),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                //color: Colors.black,
                size: 30,
              ),
              tooltip: "Profile",
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 11),
              ),
            )
          ]),
    );
  }
}
