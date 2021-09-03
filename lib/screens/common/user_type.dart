import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/common/authentication/signup_otp.dart';
import 'package:acc/utilites/app_colors.dart';

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  bool pressAttention = true;
  bool fundRaiserClick = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 30),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              Material(
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 80.0, left: 25.0),
                          child: Text(
                            "I am a",
                            style: textBold(Colors.black, 26),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                          child: Text(
                            "Please choose your appropiate type",
                            style: textNormal(textGrey, 16.0),
                          ),
                        ),
                        Center(
                          child: header(),
                        )
                      ])),
            ],
          ),
        )));
  }

  List<String> selectedCategory = [];
  String investor = 'investor';
  String fundraiser = 'fundraiser';

  Widget header() {
    return Column(children: [
      // INVESTOR
      InkWell(
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          selectedCategory = [];
          selectedCategory.add(investor);
          setState(() {
            openSignUp("Investor");
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 50.0),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: selectedCategory.contains(investor)
                ? Colors.orange[600]
                : Colors.grey[300],
            borderRadius: BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/investor_user.png",
                  width: 80.0,
                  height: 80.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Investor",
                    style: textNormal16(selectedCategory.contains(investor)
                        ? Colors.white
                        : Colors.black))
              ],
            ),
          ),
        ),
      ),

      SizedBox(
        height: 10.0,
      ),

      // FUND RAISER
      InkWell(
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          selectedCategory = [];
          selectedCategory.add(fundraiser);
          setState(() {
            openSignUp("Fundraiser");
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 30.0),
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: selectedCategory.contains(fundraiser)
                ? selectedOrange
                : unselectedGray,
            borderRadius: BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/fund_raiser.png",
                  width: 80.0,
                  height: 80.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Fundraiser",
                    style: textNormal16(selectedCategory.contains(fundraiser)
                        ? Colors.white
                        : Colors.black))
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  void openSignUp(String userType) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignUpOTP(userType: userType);
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
        }));
  }
}
