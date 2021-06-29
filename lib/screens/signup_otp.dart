import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/signup_verify_otp.dart';

import 'common/utilites/ui_widgets.dart';

class SignUpOTP extends StatefulWidget {
  @override
  _SignUpOTPState createState() => _SignUpOTPState();
}

class _SignUpOTPState extends State<SignUpOTP> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
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
                      margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                      child: Text(
                        "Let's start here",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28.0,
                            fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                      child: Text(
                        "Let's verify your mobile number",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            fontFamily: 'Poppins-Regular'),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      decoration: customDecoration(),
                      child: inputTextField("Mobile Number", null),
                    ),

                    //SIGN UP BUTTON
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          // Open otp view
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpVerifyOTP()));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: appColorButton(),
                          child: Center(
                              child: Text(
                            "Send OTP",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Poppins-Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[200],
        ),
      ],
    );
  }

  TextField inputTextField(text, controller) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: 'Poppins-Regular'),
      controller: controller,
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
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }
}
