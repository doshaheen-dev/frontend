import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:acc/screens/common/authentication/signin_verify_otp.dart';
import 'package:acc/services/OtpService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';

import 'package:acc/utilites/ui_widgets.dart';
import 'package:ps_code_checking/ps_code_checking.dart';

class SignInOTP extends StatefulWidget {
  @override
  _SignInOTPState createState() => _SignInOTPState();
}

class _SignInOTPState extends State<SignInOTP> {
  TextEditingController phoneController = new TextEditingController();
  final captchaController = CodeCheckController();
  final textConroller = TextEditingController();
  var progress;
  var selectedCountry;
  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];

  bool _isDropdownVisible = true;

  void showToast() {
    setState(() {
      _isDropdownVisible = true;
    });
  }

  @override
  void initState() {
    selectedCountry = countryList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                              onPressed: () => {Navigator.pop(context)},
                            ),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 25.0),
                                  child: Text(loginHeader,
                                      style: textBold26(headingBlack)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0, left: 25.0, right: 25.0),
                                  child: Text(loginVia,
                                      style: textNormal16(textGrey)),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                _createMobileFields(),
                                //CAPTCHA
                                _createCaptcha(context),

                                //SIGN IN BUTTON
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());

                                          if (phoneController.text.isEmpty) {
                                            showSnackBar(
                                                context, correctEmailMobile);
                                            return;
                                          }

                                          if (!captchaController.verify(
                                              textConroller.value.text)) {
                                            showSnackBar(
                                                context, correctCaptcha);
                                            textConroller.clear();
                                            captchaController.refresh();
                                            return;
                                          }

                                          if (CodeUtils.isPhone(
                                              phoneController.text)) {
                                            if (selectedCountry == null) {
                                              showSnackBar(
                                                  context, errorCountryCode);
                                              return;
                                            }

                                            if (selectedCountry.maxLength !=
                                                phoneController.text.length) {
                                              showSnackBar(context,
                                                  "Phone number should be of ${selectedCountry.maxLength} digits.");
                                              return;
                                            }
                                            print("mobile");
                                            progress = ProgressHUD.of(context);
                                            progress?.showWithText(sendingOtp);

                                            sendOTPServer(phoneController.text,
                                                "twilio", "mobile");
                                          } else if (CodeUtils.emailValid(
                                              phoneController.text)) {
                                            progress = ProgressHUD.of(context);

                                            progress?.showWithText(sendingOtp);

                                            sendOTPServer(phoneController.text,
                                                "twilio", "email");
                                          } else {
                                            showSnackBar(
                                                context, warningEmailMobile);
                                            return;
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18))),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      kDarkOrange,
                                                      kLightOrange
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 60,
                                              alignment: Alignment.center,
                                              child: Text(sendOtp,
                                                  style: textWhiteBold18()),
                                            ))))
                              ]),
                        ])),
                  )),
        ));
  }

  Row _createMobileFields() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: _isDropdownVisible,
          child: Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(
                    top: 5.0, left: 25.0, bottom: 20, right: 5.0),
                decoration: customDecoration(),
                child: _buildCodeDropDown(),
              )),
        ),
        Container(
          width: 1,
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(
                top: 5.0, bottom: 20, left: 25.0, right: 25.0),
            decoration: customDecoration(),
            child: inputTextField(mobileEmailLabel, phoneController),
          ),
        ),
      ],
    );
  }

  Container _createCaptcha(BuildContext context) {
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
                    margin:
                        EdgeInsets.only(right: 10.0, left: 10.0, bottom: 5.0),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() {}),
                      child: Row(children: [
                        Expanded(
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
                            child: Container(
                                margin: EdgeInsets.only(left: 40, bottom: 20),
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
                    child: otpTextField(),
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
          )
        ]);
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
              print("selectedItemValue3 => ${countries.maxLength}");

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

  TextField otpTextField() {
    return TextField(
      controller: textConroller,
      style: textBlackNormal18(),
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
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

  TextField inputTextField(text, _controller) {
    return TextField(
        onChanged: (text) {
          if (CodeUtils.emailValid(text)) {
            setState(() {
              _isDropdownVisible = false;
            });
          } else if (text == null) {
            setState(() {
              _isDropdownVisible = true;
            });
          } else {
            setState(() {
              _isDropdownVisible = true;
            });
          }
        },
        style: textBlackNormal16(),
        controller: _controller,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(15.0),
            labelText: text,
            labelStyle: new TextStyle(color: Colors.grey[600]),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  Future<void> sendOTPServer(
      String text, String requesterType, String osType) async {
    String getOtpPlatform = "";
    print("osType => $osType");
    if (osType == "email") {
      getOtpPlatform = text.toString().trim();
    } else {
      getOtpPlatform = "+${selectedCountry.dialCode}" + text.toString().trim();
    }
    VerificationIdSignIn verificationIdSignIn =
        await OtpService.getVerificationFromTwillio(
            getOtpPlatform, osType, requesterType);

    progress.dismiss();
    if (verificationIdSignIn.type == "success") {
      openSignInVerifyOTP(verificationIdSignIn.data.verificationId,
          getOtpPlatform, osType, requesterType);
    } else {
      showSnackBar(context, verificationIdSignIn.message);
    }
  }

  void openSignInVerifyOTP(String verificationId, String phoneNumber,
      String otpType, String requesterType) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignInVerifyOTP(
            verificationId: verificationId,
            phoneNumber: phoneNumber,
            otpType: otpType,
          );
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
