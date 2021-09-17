import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/default.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/services/update_otp_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class MobileUpdate extends StatefulWidget {
  String mobileNumber = "";
  var selectedCountry;
  String changedMobileVerificationId;

  Function(String, dynamic, String) callback;
  MobileUpdate(this.mobileNumber, this.selectedCountry,
      this.changedMobileVerificationId, this.callback);

  @override
  _MobileUpdateState createState() => new _MobileUpdateState();
}

class _MobileUpdateState extends State<MobileUpdate> {
  var selectedCountry;
  var newSelectedCountry;
  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];
  String mobileNumber = "";
  String _verificationId = "";
  String otpText = "";
  String newMobileNo = "";
  bool isEmailOtpReceived = false;
  bool isOtpReceived = false;

  TextEditingController _mobileController = TextEditingController();
  TextEditingController _newMobileController = TextEditingController();
  TextEditingController otpController = new TextEditingController();

  @override
  void initState() {
    _mobileController.text = widget.mobileNumber;
    selectedCountry = widget.selectedCountry;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  decoration: customDecoration(),
                  child: _buildCodeDropDown(),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: customDecoration(),
                  child: Stack(
                    children: [
                      TextField(
                        enabled: false,
                        style: textBlackNormal16(),
                        onChanged: (value) => {
                          mobileNumber = value,
                        },
                        controller: _mobileController,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(15.0),
                          labelText: "Mobile No.",
                          labelStyle: new TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0, top: 25.0),
                          child: InkWell(
                              onTap: () {
                                // open Bottom sheet
                                showUpdationView();
                              },
                              child: Text(
                                "Update",
                                style: textNormal12(Colors.blue),
                              )),
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _buildCodeDropDown() {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0),
        child: DropdownButtonFormField<Countries>(
          decoration: InputDecoration(
              labelText: 'Country Code',
              labelStyle: textNormal14(Colors.grey[600]),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent))),
          value: selectedCountry,
          items: countryList.map((Countries countries) {
            return DropdownMenuItem<Countries>(
              value: countries,
              child: Row(
                children: <Widget>[
                  Text("+${countries.dialCode}",
                      style: textNormal14(Colors.black)),
                ],
              ),
            );
          }).toList(),
        ));
  }

  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> showUpdationView() async {
    newSelectedCountry = selectedCountry;
    _newMobileController = TextEditingController();
    otpController = new TextEditingController();

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
                    key: _modelScaffoldKey,
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
                                  "Update Your Mobile Number",
                                  textAlign: TextAlign.start,
                                  style: textBold16(headingBlack),
                                ),
                                Spacer(),
                                InkWell(
                                    onTap: () {
                                      _newMobileController.clear();
                                      otpController.clear();

                                      setState(() {
                                        isOtpReceived = false;
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
                              margin: EdgeInsets.only(
                                  left: 15.0, right: 15.0, top: 10.0),
                              width: MediaQuery.of(context).size.width,
                              child: _createNewMobileFields(setState),
                            ),
                            Visibility(
                              visible: !isOtpReceived,
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (newSelectedCountry == null) {
                                          _modelScaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content:
                                                      Text(errorCountryCode)));

                                          return;
                                        }

                                        if (_newMobileController.text.isEmpty) {
                                          _modelScaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content:
                                                      Text(correctMobile)));
                                          return;
                                        }

                                        if (newSelectedCountry.maxLength !=
                                            _newMobileController.text.length) {
                                          _modelScaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      "Phone number should be of ${newSelectedCountry.maxLength} digits.")));

                                          return;
                                        }

                                        //  progress = ProgressHUD.of(context);
                                        // progress?.showWithText(sendingOtp);
                                        otpController = TextEditingController();
                                        _getOtp(
                                            _newMobileController.text,
                                            newSelectedCountry,
                                            setState,
                                            "mobile_no");
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
                                visible: isOtpReceived,
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
                                                                _newMobileController
                                                                    .text,
                                                                newSelectedCountry,
                                                                setState,
                                                                "mobile_no");
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
                                              if (otpController.text.isEmpty) {
                                                _modelScaffoldKey.currentState
                                                    .showSnackBar(SnackBar(
                                                        duration: Duration(
                                                            seconds: 1),
                                                        content:
                                                            Text(warningOTP)));
                                                return;
                                              }
                                              // verify otp
                                              verifyMobileOTP(
                                                  otpController.text,
                                                  _verificationId,
                                                  _newMobileController.text
                                                      .trim(),
                                                  setState);
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
                                                      style: textWhiteBold16(),
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

  Row _createNewMobileFields(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              decoration: customDecoration(),
              child: _buildBottomSheetCodeDropDown(setState),
            )),
        SizedBox(width: 30.0),
        Expanded(
            flex: 2,
            child: Container(
              decoration: customDecoration(),
              child: TextField(
                style: textBlackNormal16(),
                onChanged: (value) => newMobileNo = value,
                controller: _newMobileController,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  labelText: "Mobile No.",
                  labelStyle: new TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.transparent, width: 2.0),
                    borderRadius: BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ))
      ],
    );
  }

  Widget _buildBottomSheetCodeDropDown(StateSetter setState) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0),
        child: DropdownButtonFormField<Countries>(
          decoration: InputDecoration(
              labelText: 'Country Code',
              labelStyle: new TextStyle(color: Colors.grey[600]),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent))),
          value: newSelectedCountry,
          onChanged: (Countries countries) {
            setState(() {
              isOtpReceived = false;
              newSelectedCountry = countries;
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
    String _phoneNumber = text;
    _phoneNumber = "+${newSelectedCountry.dialCode}" + text.toString().trim();

    print(_phoneNumber);
    VerificationIdSignIn verificationIdSignIn =
        await UpdateProfileOtpService.getOtp(_phoneNumber, otpType);
    if (verificationIdSignIn.status == 200) {
      Future.delayed(Duration(milliseconds: 2), () {
        _verificationId = verificationIdSignIn.data.verificationId;
        setState(() {
          isOtpReceived = true;
        });
      });
    } else {
      setState(() {
        isOtpReceived = false;
      });
    }
    showSnackBar(context, verificationIdSignIn.message);
  }

  Future<void> verifyMobileOTP(String otpCode, String verificationId,
      String phoneNumber, StateSetter setState) async {
    Default updateProfileOtpService =
        await UpdateProfileOtpService.verifyOtp(verificationId, otpCode);
    if (updateProfileOtpService.status == 200) {
      Future.delayed(Duration(milliseconds: 2), () async {
        setState(() {
          isOtpReceived = false;
        });
        _mobileController.text = phoneNumber;
        selectedCountry = newSelectedCountry;
        this.widget.callback(phoneNumber, selectedCountry, verificationId);
        _modelScaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text(updateProfileOtpService.message)));
      });

      Future.delayed(Duration(milliseconds: 2), () async {
        Navigator.pop(context);
      });
    } else {
      verificationId = "";
      showSnackBar(context, updateProfileOtpService.message);
    }
  }
}
