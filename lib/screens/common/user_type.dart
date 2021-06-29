import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/signup_otp.dart';

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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 20.0, left: 25.0),
                  child: Text(
                    "I am a",
                    style: TextStyle(
                        color: Colors.black,
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
                        color: Colors.grey,
                        fontSize: 18.0,
                        fontFamily: 'Poppins-Regular'),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () => setState(() => {
                              pressAttention = !pressAttention,
                              new Future.delayed(const Duration(seconds: 1),
                                  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpOTP()));
                              })
                            }),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: pressAttention
                                ? Colors.grey[300]
                                : Colors.orange[600],
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
                                        color: pressAttention
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16.0,
                                        fontFamily: 'Poppins-Light'))
                              ],
                            ),
                          ),
                        ),
                      ),

                      // FUND RAISER
                      InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () => setState(() => {
                              fundRaiserClick = !fundRaiserClick,
                              new Future.delayed(const Duration(seconds: 1),
                                  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpOTP()));
                              })
                            }),
                        splashColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: fundRaiserClick
                                ? Colors.grey[300]
                                : Colors.orange[600],
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
                                        color: fundRaiserClick
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16.0,
                                        fontFamily: 'Poppins-Light'))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        ],
      ),
    )));
  }

  InkWell createButton(text, image) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {},
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 100.0,
                height: 100.0,
              ),
              Text(text,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      fontFamily: 'Poppins-Light'))
            ],
          ),
        ),
      ),
    );
  }
}
