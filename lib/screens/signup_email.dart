import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_management/services/AuthenticationService.dart';

import 'common/utilites/ui_widgets.dart';

class SignUpEmail extends StatefulWidget {
  @override
  _SignUpEmailState createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail> {
  bool _isHidden = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                        "Personal Details",
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
                        "Please fill out your personal details.",
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
                      child: inputTextField("Fullname", null),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      decoration: customDecoration(),
                      child: inputTextField("E-mail", emailController),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      decoration: customDecoration(),
                      child: passwordTextField("Password", passwordController),
                    ),
                    //SIGN UP BUTTON
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          context.read<AuthenticationService>().signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          decoration: appColorButton(),
                          child: Center(
                              child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                    // OR Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "or",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              fontFamily: 'Poppins-Regular'),
                        ),
                      ],
                    ),
                    // Apple Login
                    Container(
                        margin: const EdgeInsets.only(
                            top: 15.0, left: 25.0, bottom: 5, right: 25.0),
                        child: createButton("Connect with Apple", "Apple")),
                    //Google Button
                    Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      child: createButton("Connect with Google", "Google"),
                    ),
                    // TERMS AND CONDITIONS
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "By signing in, I agree with ",
                            style: setTextStyle(Colors.grey[500]),
                            children: [
                              TextSpan(
                                text: "Terms of Use ",
                                style: setTextStyle(Colors.black),
                              ),
                              TextSpan(
                                text: "\n and ",
                                style: setTextStyle(Colors.grey[500]),
                              ),
                              TextSpan(
                                text: "Privacy Poicy",
                                style: setTextStyle(Colors.black),
                              )
                            ]),
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

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 14, fontWeight: FontWeight.w500);
  }

  InkWell createButton(text, type) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        if (type == "Apple") {
          context.read<AuthenticationService>().signInWithApple();
        } else if (type == "Google") {
          context.read<AuthenticationService>().signInWithGoogle();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: _setButtonBg(type),
            borderRadius: BorderRadius.all(
              const Radius.circular(15.0),
            ),
            border: Border.all(color: Colors.black87)),
        child: Center(
            child: Row(
          children: [
            Padding(padding: EdgeInsets.all(10.0)),
            Image.asset(
              _setImage(type),
              color: _setIconColorBg(type),
              height: 25.0,
            ),
            SizedBox(
              width: 60,
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: _setTextColorBg(type)),
              ),
            )
          ],
        )),
      ),
    );
  }

  // ignore: missing_return
  Color _setButtonBg(type) {
    if (type == "Apple") {
      return Colors.black87;
    }
  }

  // ignore: missing_return
  Color _setIconColorBg(type) {
    if (type == "Apple") {
      return Colors.white;
    }
  }

  // ignore: missing_return
  Color _setTextColorBg(type) {
    if (type == "Apple") {
      return Colors.white;
    } else if (type == "Google") {
      return Colors.black;
    }
  }

  // ignore: missing_return
  String _setImage(type) {
    if (type == "Apple") {
      return "assets/images/social_media/apple.png";
    } else if (type == "Google") {
      return "assets/images/social_media/google.png";
    }
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

  TextField passwordTextField(text, controller) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 14.0,
          fontFamily: 'Poppins-Regular'),
      controller: controller,
      obscureText: _isHidden,
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: text,
        labelStyle: new TextStyle(color: Colors.grey[600]),
        suffix: InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[400],
          ),
        ),
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
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
