import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/authentication/signup_otp.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

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
                          margin: const EdgeInsets.only(top: 20.0, left: 25.0),
                          child: Text(
                            "I am a",
                            style: TextStyle(
                                color: headingBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                                fontFamily: 'Poppins-Light'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                          child: Text(
                            "Please choose your appropiate type",
                            style: TextStyle(
                                color: textGrey,
                                fontSize: 20.0,
                                fontFamily: 'Poppins-Regular'),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpOTP()));
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 50.0),
          width: 180,
          height: 180,
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
                  width: 100.0,
                  height: 100.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Investor",
                    style: TextStyle(
                        color: selectedCategory.contains(investor)
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontFamily: 'Poppins-Light'))
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpOTP()));
          });
        },
        child: Container(
          margin: const EdgeInsets.only(top: 50.0),
          width: 180,
          height: 180,
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
                  width: 100.0,
                  height: 100.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Fundraiser",
                    style: TextStyle(
                        color: selectedCategory.contains(fundraiser)
                            ? Colors.white
                            : Colors.black,
                        fontSize: 18.0,
                        fontFamily: 'Poppins-Light'))
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
