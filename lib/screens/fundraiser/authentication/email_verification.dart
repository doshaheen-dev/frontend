import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/default.dart';
import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/services/UpdateProfileService.dart';
import 'package:acc/services/update_otp_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:acc/widgets/app_progressbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key key}) : super(key: key);

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final GlobalKey<ScaffoldState> _emailScaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _newEmailController = TextEditingController();
  TextEditingController emailOtpController = new TextEditingController();
  String _emailVerificationId = "";
  bool isEmailOtpReceived = false;
  String newEmail = "";
  String email = "";
  String otpText = "";
  var progress;

  @override
  Widget build(BuildContext context) {
    return AppProgressBar(
        child: Builder(
      builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            key: _emailScaffoldKey,
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0.0,
              backgroundColor: Color(0xffffffff),
            ),
            bottomNavigationBar: BottomAppBar(),
            backgroundColor: Colors.white,
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
                          "Verify Your E-mail ID",
                          textAlign: TextAlign.start,
                          style: textBold16(headingBlack),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: _onBackPressed,
                            child: Text(
                              "Close",
                              style: textNormal16(headingBlack),
                            ))
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(children: [
                        Flexible(
                          child: Text(
                            "Your E-mail ID has not been verified yet. \nPlease verify now.",
                            textAlign: TextAlign.start,
                            style: textNormal16(headingBlack),
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      decoration: customDecoration(),
                      margin:
                          EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                          style: textBlackNormal16(),
                          onChanged: (value) => newEmail = value,
                          controller: _newEmailController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              labelText: "E-mail Id",
                              labelStyle:
                                  new TextStyle(color: Colors.grey[600]),
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                                borderRadius: BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ))),
                    ),
                    Visibility(
                      visible: !isEmailOtpReceived,
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                if (_newEmailController.text.isEmpty) {
                                  _emailScaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                              "Please enter your email id.")));
                                  return;
                                }

                                if (!CodeUtils.emailValid(_newEmailController
                                    .text
                                    .trim()
                                    .toString())) {
                                  _emailScaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                              "Please enter a valid email id.")));
                                  return;
                                }

                                emailOtpController = TextEditingController();
                                progress = AppProgressBar.of(context);
                                progress?.showWithText('Sending OTP...');
                                _getOtp(_newEmailController.text, "", setState,
                                    "email_id");
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(context).primaryColor
                                      ]),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                      width: 240,
                                      height: 45,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Send OTP",
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
                                margin:
                                    const EdgeInsets.only(top: 5.0, left: 25.0),
                                child: Text(
                                  "Please enter the OTP received in your inbox.",
                                  style: textNormal16(Colors.black),
                                )),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 40.0,
                                  bottom: 20,
                                  right: 40.0),
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
                                  activeColor: Theme.of(context).primaryColor,
                                  activeFillColor:
                                      Theme.of(context).primaryColor,
                                ),
                                cursorColor: Colors.black,
                                enableActiveFill: false,
                                keyboardType: TextInputType.number,
                                onCompleted: (v) {},
                                onChanged: (value) {
                                  setState(() {
                                    otpText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
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
                                      text: "Didn't receive the OTP? ",
                                      style: textNormal16(Colors.black),
                                      children: [
                                        TextSpan(
                                            text: 'Resend OTP',
                                            style: textNormal16(
                                                Theme.of(context).primaryColor),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                progress =
                                                    AppProgressBar.of(context);
                                                progress?.showWithText(
                                                    'Sending OTP...');
                                                _getOtp(
                                                    _newEmailController.text,
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
                                      if (emailOtpController.text.isEmpty) {
                                        _emailScaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                content: Text(warningOTP)));
                                        return;
                                      }
                                      progress = AppProgressBar.of(context);
                                      progress
                                          ?.showWithText('Verifying OTP...');
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
            ),
          )),
    ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?', style: textNormal16(headingBlack)),
            content: new Text('You want to cancel preferences setup',
                style: textNormal14(headingBlack)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    _newEmailController.clear();
                    emailOtpController.clear();
                    setState(() {
                      isEmailOtpReceived = false;
                    });
                    Navigation.openOnBoarding(context);
                  },
                  child: Text(
                    "Yes",
                    style: textNormal14(Theme.of(context).primaryColor),
                  )),
              SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: textNormal14(Theme.of(context).primaryColor),
                  )),
            ],
          ),
        ) ??
        false;
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
    progress.dismiss();
    if (verificationIdSignIn.type == 'success') {
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
    progress.dismiss();
    if (updateProfileOtpService.type == 'success') {
      Map<String, dynamic> requestMap = Map();

      requestMap["email_id"] = CryptUtils.encryption(emailId);
      requestMap["email_verificationId"] = emailVerificationId;
      progress?.showWithText('Updating Email...');
      Future.delayed(Duration(seconds: 2), () async {
        Default updateResponse =
            await UpdateProfileService.updateUserInfo(requestMap);
        progress.dismiss();
        if (updateResponse.type == 'success') {
          _openDialog(context, updateResponse.message);
        } else {
          showSnackBar(context, updateResponse.message);
        }
      });
    } else {
      emailVerificationId = "";
      showSnackBar(context, updateProfileOtpService.message);
    }
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          Navigation.openOnBoarding(context);
          setState(() {
            isEmailOtpReceived = false;
          });
          _newEmailController.clear();
          emailOtpController.clear();
        },
        child: Text(
          "Ok",
          style: textNormal16(Theme.of(context).primaryColor),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message, style: textNormal18(headingBlack)),
      actions: [
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
