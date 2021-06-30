import 'dart:io';

import 'package:flutter/material.dart';
import 'package:portfolio_management/screens/signup.dart';
import 'package:portfolio_management/services/AuthenticationService.dart';
import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color colorGreen = Color(0xff00A699);
  bool _inscription = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[300],
          blurRadius: 5,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 130,
                    width: 130,
                    child: Image.asset(
                        "assets/images/company_logo/doshaheenlogo.png"),
                  ),
                  Text(
                    "Welcome to Portfolio Management",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: colorGreen,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: customDecoration(),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Password",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: colorGreen,
                          )),
                    ),
                  ),
                  Visibility(
                    visible: _inscription,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot password ?",
                            style: TextStyle(color: colorGreen, fontSize: 12),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: _inscription ? 30 : 0,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      context.read<AuthenticationService>().signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                    },
                    splashColor: Colors.white,
                    hoverColor: colorGreen,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 2),
                            color: Colors.grey,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      )),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          child: RichText(
                            text: TextSpan(
                                text: "Don't have an account ? ",
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: "Sign up",
                                    style: TextStyle(
                                        color: colorGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Or continue with ",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //     height: 50,
                  //     child: SignInWithAppleButton(onPressed: () async {
                  //       final credential =
                  //           await SignInWithApple.getAppleIDCredential(
                  //         scopes: [
                  //           AppleIDAuthorizationScopes.email,
                  //           AppleIDAuthorizationScopes.fullName,
                  //         ],
                  //         webAuthenticationOptions: WebAuthenticationOptions(
                  //           clientId:
                  //               'com.doshaheen.portfoliomanagementservice',
                  //           redirectUri: Uri.parse(
                  //             'https://portfolio-management.glitch.me/callbacks/sign_in_with_apple',
                  //           ),
                  //         ),
                  //       );
                  //       print(credential);
                  //       final signInWithAppleEndpoint = Uri(
                  //         scheme: 'https',
                  //         host: 'portfolio-management.glitch.me',
                  //         path: '/sign_in_with_apple',
                  //         queryParameters: <String, String>{
                  //           'code': credential.authorizationCode,
                  //           if (credential.givenName != null)
                  //             'firstName': credential.givenName,
                  //           if (credential.familyName != null)
                  //             'lastName': credential.familyName,
                  //           'useBundleId': Platform.isIOS || Platform.isMacOS
                  //               ? 'true'
                  //               : 'false',
                  //           if (credential.state != null)
                  //             'state': credential.state,
                  //         },
                  //       );

                  //       final session = await http.Client().post(
                  //         signInWithAppleEndpoint,
                  //       );
                  //       print(session);
                  //     }),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      continueWith(
                          "assets/images/social_media/google.png", "google"),
                      if (Platform.isIOS)
                        continueWith(
                            "assets/images/social_media/apple.png", "apple"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // ignore: missing_return
  InkWell continueWith(String image, String type) {
    return InkWell(
      onTap: () {
        if (type == 'google') {
          context.read<AuthenticationService>().signInWithGoogle();
        } else if (type == 'apple') {
          context.read<AuthenticationService>().signInWithApple();
        }
      },
      child: Container(
        padding: EdgeInsets.all(15),
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(offset: Offset(0, 3), color: Colors.grey, blurRadius: 5)
            ]),
        child: Image.asset(
          image,
        ),
      ),
    );
  }
}
