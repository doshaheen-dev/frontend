import 'package:acc/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/thank_you.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

class SignUpPanDetails extends StatefulWidget {
  @override
  _SignUpPanDetailsState createState() => _SignUpPanDetailsState();
}

class _SignUpPanDetailsState extends State<SignUpPanDetails> {
  String panNumber = "";
  String dob = "";

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
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, size: 30),
                    onPressed: () => {Navigator.pop(context)},
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                      child: Text(
                        "Enter Your PAN",
                        style: TextStyle(
                            color: headingBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            fontFamily: FontFamilyMontserrat.name),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                      child: Text(
                        "Please enter your PAN details",
                        style: TextStyle(
                            color: textGrey,
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0,
                            fontFamily: FontFamilyMontserrat.name),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      decoration: customDecoration(),
                      child: TextField(
                        style: _setTextFieldStyle(),
                        onChanged: (value) => panNumber = value,
                        decoration: _setTextFieldDecoration("PAN Number"),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      decoration: customDecoration(),
                      child: TextField(
                        style: _setTextFieldStyle(),
                        onChanged: (value) => dob = value,
                        decoration: _setTextFieldDecoration("Date Of Birth"),
                      ),
                    ),

                    //NEXT BUTTON
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          // on click
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ThankYouInvestor()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: appColorButton(context),
                          child: Center(
                              child: Text(
                            "Complete Process",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                        color: unselectedGray,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        margin: EdgeInsets.only(
                            right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      left: 10.0,
                                      bottom: 20.0,
                                      right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Why we need your PAN details?",
                                        style: setBoldTextStyle(headingBlack),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Investments - Providing PAN details is mandatory for investing in mutual funds as per the governmentregulations. Loan - we will check our systems to provide any pre-approved offer you are eligible for",
                                        style: setTextStyle(textGrey),
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        "Worried about the safety of your details",
                                        style: setBoldTextStyle(headingBlack),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "We have bank level encrypted systems for all the information you provide to us. Be rest assured, your details are absolutely safe with us.",
                                        style: setTextStyle(textGrey),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        )),
                  ],
                )
              ]))),
        ));
  }

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 14, fontWeight: FontWeight.w500);
  }

  TextStyle setBoldTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 16, fontWeight: FontWeight.bold);
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[200],
        )
      ],
    );
  }

  TextStyle _setTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        fontFamily: FontFamilyMontserrat.name);
  }

  InputDecoration _setTextFieldDecoration(_text) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10.0),
      labelText: _text,
      labelStyle: new TextStyle(color: Colors.grey[600]),
      border: InputBorder.none,
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
        borderRadius: BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
    );
  }

  TextField inputTextField(text) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: FontFamilyMontserrat.name),
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: text,
        labelStyle: new TextStyle(color: Colors.grey[600]),
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
