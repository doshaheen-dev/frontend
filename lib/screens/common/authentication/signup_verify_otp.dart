import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/fundraiser/authentication/signup_corporate_details.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/app_progressbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:acc/screens/investor/authentication/signup_quick.dart';
import 'package:acc/services/OtpService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/ui_widgets.dart';

import 'package:acc/models/authentication/signup_request.dart';
import 'package:acc/utils/crypt_utils.dart';

class SignUpVerifyOTP extends StatefulWidget {
  final String _verificationId;
  final String _phoneNumber;
  final String _userType;
  const SignUpVerifyOTP(
      {Key key, String verificationId, String phoneNumber, String userType})
      : _verificationId = verificationId,
        _phoneNumber = phoneNumber,
        _userType = userType,
        super(key: key);

  @override
  _SignUpVerifyOTPState createState() => _SignUpVerifyOTPState();
}

class _SignUpVerifyOTPState extends State<SignUpVerifyOTP> {
  String currentText = "";
  bool hasError = false;
  String _verificationId;
  String _phoneNumber;
  String _userType;
  TextEditingController otpController = new TextEditingController();
  var progress;

  @override
  void initState() {
    _verificationId = widget._verificationId;
    _phoneNumber = widget._phoneNumber;
    _userType = widget._userType;
    super.initState();
  }

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
            body: AppProgressBar(
                child: Builder(
              builder: (context) => SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              size: 30, color: backButtonColor),
                          onPressed: () => {Navigator.pop(context)},
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 25.0),
                            child: Text("Enter OTP",
                                style:
                                    textBold26(Theme.of(context).accentColor)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 25.0),
                            child: Text(
                                "Please enter the OTP received in your mobile phone.",
                                style: textNormal16(textGrey)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                top: 5.0, left: 40.0, right: 40.0),
                            child: PinCodeTextField(
                              controller: otpController,
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
                                activeFillColor: Theme.of(context).primaryColor,
                              ),
                              cursorColor: Colors.black,
                              enableActiveFill: false,
                              keyboardType: TextInputType.number,
                              onCompleted: (v) {},
                              onChanged: (value) {
                                setState(() {
                                  currentText = value;
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
                                    style: textNormal16(textGrey),
                                    children: [
                                      TextSpan(
                                          text: 'Resend OTP',
                                          style: textNormal16(
                                              Theme.of(context).primaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              progress =
                                                  AppProgressBar.of(context);
                                              progress
                                                  ?.showWithText(sendingOtp);
                                              otpController.clear();
                                              _getOtp();
                                            })
                                    ]),
                              )),

                          SizedBox(
                            height: 40,
                          ),
                          //Verify BUTTON
                          Container(
                              margin: const EdgeInsets.only(
                                  top: 5.0,
                                  left: 40.0,
                                  bottom: 20,
                                  right: 40.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (otpController.text.isEmpty) {
                                      showSnackBar(context, warningOTP);
                                      return;
                                    }
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    progress = AppProgressBar.of(context);
                                    progress?.showWithText(verifyingOtp);
                                    _verifySignUpOTP(otpController.text,
                                        _verificationId, _phoneNumber);
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: Text(
                                            verifyOtp,
                                            style: textWhiteBold18(),
                                          )))))
                        ],
                      )
                    ])),
              ),
            ))));
  }

  Future<void> _getOtp() async {
    VerificationIdSignIn verificationIdSignIn =
        await OtpService.getSignUpOtp(_phoneNumber);
    if (verificationIdSignIn.status == 200) {
      Future.delayed(Duration(milliseconds: 2), () {
        _verificationId = verificationIdSignIn.data.verificationId;
      });
    }
    progress.dismiss();
    showSnackBar(context, verificationIdSignIn.message);
  }

  Future<void> _verifySignUpOTP(
      String otpCode, String verificationId, String phoneNumber) async {
    SignUpInvestor verificationIdSignIn = await OtpService.getVerifySignUpOtp(
        phoneNumber, verificationId, otpCode);

    if (verificationIdSignIn.status == 200) {
      progress?.showWithText(successOTP);
      final requestModelInstance = InvestorSignupRequestModel.instance;
      requestModelInstance.mobileNo = CryptUtils.encryption(phoneNumber);
      requestModelInstance.verificationId = verificationId;
      Future.delayed(Duration(milliseconds: 2), () async {
        progress.dismiss();
        openQuickSignUp();
      });
    } else {
      progress.dismiss();
      showSnackBar(context, verificationIdSignIn.message);
    }
  }

  void openQuickSignUp() {
    if (_userType == "Investor") {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return QuickSignUp(
              mobileNumber: _phoneNumber,
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
    } else if (_userType == "Fundraiser") {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, anotherAnimation) {
            return CorporateDetails(
              mobileNumber: _phoneNumber,
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
}
