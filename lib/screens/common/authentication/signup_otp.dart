import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/services/OtpService.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:acc/screens/common/authentication/signup_verify_otp.dart';
import 'package:acc/utilites/app_colors.dart';

import 'package:acc/utilites/ui_widgets.dart';
import 'package:ps_code_checking/ps_code_checking.dart';

class SignUpOTP extends StatefulWidget {
  final String _userType;
  SignUpOTP({Key key, String userType})
      : _userType = userType,
        super(key: key);

  @override
  _SignUpOTPState createState() => _SignUpOTPState();
}

class _SignUpOTPState extends State<SignUpOTP> {
  bool visible = false;
  EdgeInsets margin;
  String _userType;
  var selectedCountry;
  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];

  @override
  void initState() {
    _userType = widget._userType;
    super.initState();
  }

  loadProgress() {
    if (visible == true) {
      setState(() {
        visible = false;
      });
    } else {
      setState(() {
        visible = true;
      });
    }
  }

  TextEditingController phoneController = new TextEditingController();
  final captchaController = CodeCheckController();
  final textConroller = TextEditingController();
  var progress;

  @override
  Widget build(BuildContext context) {
    selectedCountry = countryList[0];
    String code = "";
    for (var i = 0; i < 6; i++) {
      code = code + Random().nextInt(9).toString();
    }

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0.0,
          backgroundColor: Color(0xffffffff),
        ),
        bottomNavigationBar: BottomAppBar(),
        backgroundColor: Colors.white,
        body: ProgressHUD(
            child: Builder(
          builder: (context) => SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 30),
                      onPressed: () => {Navigator.of(context).maybePop()},
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                        child:
                            Text(signUpHeader, style: textBold26(headingBlack)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                        child: Text(signUpSubHeader,
                            style: textNormal16(textGrey)),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: _createMobileFields(),
                      ),

                      //CAPTCHA
                      _createCaptcha(context),

                      //SIGN UP BUTTON
                      Container(
                          margin: const EdgeInsets.only(
                              top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              if (selectedCountry == null) {
                                showSnackBar(context, errorCountryCode);
                                return;
                              }

                              if (phoneController.text.isEmpty) {
                                showSnackBar(context, correctMobile);
                                return;
                              }
                              if (selectedCountry.maxLength !=
                                  phoneController.text.length) {
                                showSnackBar(context,
                                    "Phone number should be of ${selectedCountry.maxLength} digits.");
                                return;
                              }

                              if (!captchaController
                                  .verify(textConroller.value.text)) {
                                showSnackBar(context, correctCaptcha);
                                textConroller.clear();
                                captchaController.refresh();
                                return;
                              }

                              progress = ProgressHUD.of(context);
                              progress?.showWithText(sendingOtp);
                              _getOtp(phoneController.text);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18))),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [kDarkOrange, kLightOrange]),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text(sendOtpSecret,
                                    style: textWhiteBold18()),
                              ),
                            ),
                          )),

                      Container(
                        margin: const EdgeInsets.only(
                            left: 25.0, bottom: 20, right: 25.0),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                            "*You will recieve a one time password(Secret Code) on your mobile.",
                            style: textNormal16(textGrey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Row _createMobileFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(
                  top: 5.0, left: 25.0, bottom: 20, right: 5.0),
              decoration: customDecoration(),
              child: _buildCodeDropDown(),
            )),
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 20, right: 25.0),
            decoration: customDecoration(),
            child: labelTextField(mobileNumber, phoneController),
          ),
        ),
      ],
    );
  }

  Container _createCaptcha(BuildContext context) {
    if (Platform.isIOS) {
      margin = EdgeInsets.only(right: 10.0);
    }
    if (Platform.isAndroid) {
      margin = EdgeInsets.only(right: 20.0, left: 20.0);
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
          bottom: 20.0,
          right: 25.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              captchaText,
              style: textNormal16(textGrey),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(right: 10.0),
                  height: 60,
                  decoration: BoxDecoration(
                      color: HexColor('E5E5E5'),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(20.0),
                      )),
                  child: Container(
                    margin: margin,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() {}),
                      child: Row(children: [
                        Expanded(
                          flex: 2,
                          child: PSCodeCheckingWidget(
                            lineWidth: 1,
                            maxFontSize: 24,
                            dotMaxSize: 8,
                            lineColorGenerator:
                                SingleColorGenerator(Colors.transparent),
                            textColorGenerator:
                                SingleColorGenerator(Colors.black),
                            dotColorGenerator:
                                SingleColorGenerator(Colors.black),
                            controller: captchaController,
                            codeGenerator: SizedCodeGenerator(size: 6),
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                                margin:
                                    EdgeInsets.only(left: 20.0, bottom: 5.0),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                    ),
                                    iconSize: 30,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: kDarkOrange,
                                    onPressed: () {
                                      captchaController.refresh();
                                      textConroller.clear();
                                      captchaController.refresh();
                                    })))
                      ]),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        const Radius.circular(20.0),
                      ),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: HexColor('E5E5E5'),
                        width: 2,
                      ),
                    ),
                    child: inputTextField(),
                  ))
            ])
          ],
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

  Widget _buildCodeDropDown() {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0),
        child: DropdownButtonFormField<Countries>(
          decoration: InputDecoration(
              labelText: 'Country Code',
              labelStyle: new TextStyle(color: Colors.grey[600]),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent))),
          value: selectedCountry,
          onChanged: (Countries countries) {
            setState(() {
              selectedCountry = countries;
            });
          },
          items: countryList.map((Countries countries) {
            return DropdownMenuItem<Countries>(
              value: countries,
              child: Row(
                children: <Widget>[
                  Text(
                    "+${countries.dialCode}",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          }).toList(),
        ));
  }

  TextField inputTextField() {
    return TextField(
      controller: textConroller,
      style: textBlackNormal18(),
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          labelStyle: new TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.all(
                const Radius.circular(10.0),
              ))),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  TextField labelTextField(text, controller) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: FontFamilyMontserrat.name),
      controller: controller,
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
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
      ],
    );
  }

  Future<void> _getOtp(String phoneNumber) async {
    String _phoneNumber =
        "+${selectedCountry.dialCode}" + phoneNumber.toString().trim();
    print(_phoneNumber);
    VerificationIdSignIn verificationIdSignIn =
        await OtpService.getSignUpOtp(_phoneNumber);
    if (verificationIdSignIn.status == 200) {
      progress?.showWithText(successOTP);
      Future.delayed(Duration(milliseconds: 2), () {
        progress.dismiss();
        openSignUpVerifyOTP(
            verificationIdSignIn.data.verificationId, _phoneNumber);
      });
    } else {
      progress.dismiss();
      showSnackBar(context, verificationIdSignIn.message);
    }
  }

  void openSignUpVerifyOTP([String verificationId, String phoneNumber]) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignUpVerifyOTP(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              userType: _userType);
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
