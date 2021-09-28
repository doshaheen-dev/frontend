import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/default.dart';
import 'package:acc/services/update_otp_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class EmailUpdate extends StatefulWidget {
  String emailId = "";
  String verificationId = "";
  Function(String, String) updateEmailCallback;
  EmailUpdate(this.emailId, this.verificationId, this.updateEmailCallback);

  @override
  _EmailUpdateState createState() => new _EmailUpdateState();
}

class _EmailUpdateState extends State<EmailUpdate> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController otpController = new TextEditingController();
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController emailOtpController = new TextEditingController();
  String _emailVerificationId = "";
  bool isEmailOtpReceived = false;
  String newEmail = "";
  String email = "";
  String otpText = "";

  @override
  void initState() {
    _emailController.text = widget.emailId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Stack(
          children: [
            TextField(
                enabled: false,
                style: textBlackNormal16(),
                onChanged: (value) => email = value,
                controller: _emailController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: "Email Id",
                    labelStyle: textNormal14(Colors.grey[600]),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ))),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(left: 25.0, right: 20.0, top: 15.0),
                child: InkWell(
                    onTap: () {
                      // open Bottom sheet
                      showEmailUpdationView();
                    },
                    child: Text(
                      "Update",
                      style: textNormal12(Colors.blue),
                    )),
              ),
            ),
          ],
        ));
  }

  final GlobalKey<ScaffoldState> _emailScaffoldKey = GlobalKey<ScaffoldState>();
  void showEmailUpdationView() {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Scaffold(
                    key: _emailScaffoldKey,
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Text(
                                  "Update Your E-mail ID",
                                  textAlign: TextAlign.start,
                                  style: textBold16(headingBlack),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      _newEmailController.clear();
                                      emailOtpController.clear();
                                      setState(() {
                                        isEmailOtpReceived = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Close",
                                      style: textNormal16(headingBlack),
                                    ))
                              ]),
                            ),
                            Container(
                              decoration: customDecoration(),
                              margin: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
                              width: MediaQuery.of(context).size.width,
                              child: TextField(
                                  style: textBlackNormal16(),
                                  onChanged: (value) => newEmail = value,
                                  controller: _newEmailController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      labelText: "E-mail Id",
                                      labelStyle: new TextStyle(
                                          color: Colors.grey[600]),
                                      border: InputBorder.none,
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ))),
                            ),
                            Visibility(
                              visible: !isEmailOtpReceived,
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

                                        if (_newEmailController.text.isEmpty) {
                                          _emailScaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      "Please enter your email id.")));
                                          return;
                                        }

                                        if (!CodeUtils.emailValid(
                                            _newEmailController.text
                                                .trim()
                                                .toString())) {
                                          _emailScaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      "Please enter a valid email id.")));
                                          return;
                                        }

                                        //  progress = ProgressHUD.of(context);
                                        // progress?.showWithText(sendingOtp);

                                        emailOtpController =
                                            TextEditingController();

                                        _getOtp(_newEmailController.text, "",
                                            setState, "email_id");
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18))),
                                      child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Theme.of(context).primaryColor,
                                                Theme.of(context).primaryColor
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Container(
                                              width: 240,
                                              height: 45,
                                              alignment: Alignment.center,
                                              child: Text(
                                                sendOtpSecret,
                                                style: textWhiteBold16(),
                                              ))))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                                visible: isEmailOtpReceived,
                                child: Column(
                                  children: [
                                    Container(
                                        alignment: Alignment.topLeft,
                                        margin: const EdgeInsets.only(
                                            top: 5.0, left: 25.0),
                                        child: Text(
                                          otpMobileLabel,
                                          style: textNormal16(Colors.black),
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.only(
                                          top: 5.0, left: 40.0, right: 40.0),
                                      child: PinCodeTextField(
                                        controller: emailOtpController,
                                        appContext: context,
                                        pastedTextStyle: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        length: 6,
                                        animationType: AnimationType.none,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.underline,
                                          selectedColor: Colors.grey,
                                          inactiveColor: Colors.grey,
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          activeFillColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        cursorColor: Colors.black,
                                        enableActiveFill: false,
                                        keyboardType: TextInputType.number,
                                        onCompleted: (v) {
                                          print("Completed " + v);
                                        },
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            otpText = value;
                                          });
                                        },
                                        beforeTextPaste: (text) {
                                          print("Allowing to paste $text");
                                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                          return false;
                                        },
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 20.0),
                                        alignment: Alignment.topRight,
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text: "Didn't receive the code? ",
                                              style: textNormal14(Colors.black),
                                              children: [
                                                TextSpan(
                                                    text: 'Resend OTP',
                                                    style: textNormal14(
                                                        Theme.of(context)
                                                            .primaryColor),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            _getOtp(
                                                                _newEmailController
                                                                    .text,
                                                                "",
                                                                setState,
                                                                "email_id");
                                                          })
                                              ]),
                                        )),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            top: 20.0, bottom: 20),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              if (emailOtpController
                                                  .text.isEmpty) {
                                                _emailScaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text(warningOTP)));
                                                return;
                                              }
                                              // verify otp for email id
                                              verifyEmailOTP(
                                                  _emailVerificationId,
                                                  emailOtpController.text,
                                                  _newEmailController.text);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.all(0.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18))),
                                            child: Ink(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          Theme.of(context)
                                                              .primaryColor
                                                        ]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Container(
                                                    width: 240,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      verifyOtp,
                                                      style: textWhiteBold18(),
                                                    )))))
                                  ],
                                )),
                          ],
                        ),
                      ),
                    )));
          });
        });
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

  Future<void> _getOtp(String text, newSelectedCountry, StateSetter setState,
      String otpType) async {
    VerificationIdSignIn verificationIdSignIn =
        await UpdateProfileOtpService.getOtp(text, otpType);
    if (verificationIdSignIn.status == 200) {
      Future.delayed(Duration(milliseconds: 2), () {
        _emailVerificationId = verificationIdSignIn.data.verificationId;

        setState(() {
          isEmailOtpReceived = true;
        });
      });
    } else {
      setState(() {
        isEmailOtpReceived = false;
      });
    }
    showSnackBar(context, verificationIdSignIn.message);
  }

  Future<void> verifyEmailOTP(
      String emailVerificationId, String otpCode, String emailId) async {
    Default updateProfileOtpService =
        await UpdateProfileOtpService.verifyOtp(emailVerificationId, otpCode);
    if (updateProfileOtpService.status == 200) {
      Future.delayed(Duration(milliseconds: 2), () async {
        print("id:- $emailVerificationId");
        setState(() {
          isEmailOtpReceived = false;
        });
        _emailController.text = emailId;
        this.widget.updateEmailCallback(emailId, emailVerificationId);
        _newEmailController.clear();
        emailOtpController.clear();
        _emailScaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text(updateProfileOtpService.message)));
        Navigator.pop(context);
      });
    } else {
      emailVerificationId = "";
      showSnackBar(context, updateProfileOtpService.message);
    }
  }
}
