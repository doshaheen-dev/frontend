import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/requests/requests.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/hex_color.dart';

import '../chat.dart';
import '../explore.dart';

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
    Explore(),
    Requests(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: _children[_currentTab],
      bottomNavigationBar: Container(
        height: 56,
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Image.asset('assets/images/dashboard/home.png'),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kHomeOrange, kHomeOrange1],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#C3C8CD'),
                      offset: Offset(-4.0, -2.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: HexColor('#50000000'),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 18.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Image.asset('assets/images/dashboard/suitcase.png'),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kHomeOrange, kHomeOrange1],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#C3C8CD'),
                      offset: Offset(-4.0, -2.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: HexColor('#50000000'),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 18.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Image.asset('assets/images/dashboard/money_home.png'),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kHomeOrange, kHomeOrange1],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#C3C8CD'),
                      offset: Offset(-4.0, -2.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: HexColor('#50000000'),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 18.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Image.asset('assets/images/dashboard/thumbs_up.png'),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kHomeOrange, kHomeOrange1],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#C3C8CD'),
                      offset: Offset(-4.0, -2.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: HexColor('#50000000'),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 18.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Image.asset('assets/images/dashboard/profile.png'),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kHomeOrange, kHomeOrange1],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: HexColor('#C3C8CD'),
                      offset: Offset(-4.0, -2.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: HexColor('#50000000'),
                      offset: Offset(4.0, 4.0),
                      blurRadius: 18.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Column(
//         children: <Widget>[
//           Expanded(
//             child: Container(
//               alignment: Alignment.center,
//               child: Text("Hello"),
//             ),
//           ),
//           Container(
//             height: 50,
//             width: double.maxFinite,
//             decoration: BoxDecoration(
//                 color: Colors.deepOrange,
//                 borderRadius:
//                     BorderRadius.vertical(top: Radius.circular(20.0))),
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.arrow_forward),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_downward),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_left),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.arrow_upward),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//   @override
//   Widget build(BuildContext context) {
//     int _currentTab = 0;

//     List<Widget> _children = [
//       Explore(),
//       Requests(),
//     ];

//     SystemChrome.setSystemUIOverlayStyle(
//         SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

//     return Scaffold(
//       backgroundColor: Color(0xffffffff),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                   margin:
//                       const EdgeInsets.only(top: 25.0, left: 15.0, right: 25.0),
//                   child: Row(
//                     children: [
//                       Image.asset('assets/images/investor/icon_menu.png'),
//                       SizedBox(width: 10.0),
//                       Expanded(
//                           child: Text(
//                         'Hello Investor',
//                         style: TextStyle(
//                             color: headingBlack,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 28.0,
//                             fontFamily: 'Poppins-Light'),
//                       )),
//                       Image.asset('assets/images/investor/icon_investor.png'),
//                     ],
//                   )),
//               Container(
//                 margin: const EdgeInsets.only(top: 80.0),
//                 child: Center(
//                   child: Image.asset(
//                     'assets/images/investor/thankyou_smiley.png',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               _children[_currentTab],
//               BottomNavigationBar(
//                   type: BottomNavigationBarType.fixed,
//                   backgroundColor: Color(0xffffffff),
//                   currentIndex: _currentTab,
//                   onTap: (int value) {
//                     setState(() {
//                       _currentTab = value;
//                     });
//                   },
//                   items: [
//                     BottomNavigationBarItem(
//                       icon: Icon(
//                         Icons.explore,
//                         size: 30,
//                       ),
//                       tooltip: "Explore",
//                       title: Text(
//                         "Explore",
//                         style: TextStyle(fontSize: 11),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(
//                         Icons.request_quote,
//                         //color: Colors.black,
//                         size: 30,
//                       ),
//                       tooltip: "Requests",
//                       title: Text(
//                         "Requests",
//                         style: TextStyle(fontSize: 11),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(
//                         Icons.question_answer,
//                         //color: Colors.black,
//                         size: 30,
//                       ),
//                       tooltip: "Chat",
//                       title: Text(
//                         "Chat",
//                         style: TextStyle(fontSize: 11),
//                       ),
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(
//                         Icons.account_circle,
//                         //color: Colors.black,
//                         size: 30,
//                       ),
//                       tooltip: "Profile",
//                       title: Text(
//                         "Profile",
//                         style: TextStyle(fontSize: 11),
//                       ),
//                     )
//                   ])
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
