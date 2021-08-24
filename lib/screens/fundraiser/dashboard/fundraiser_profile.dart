import 'dart:io';

import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/default.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/services/UpdateProfileService.dart';
import 'package:acc/services/update_otp_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FundraiserProfile extends StatefulWidget {
  FundraiserProfile({Key key}) : super(key: key);

  @override
  _FundraiserProfileState createState() => _FundraiserProfileState();
}

class _FundraiserProfileState extends State<FundraiserProfile> {
  String firstname = "";
  String lastname = "";
  String title = "";
  String companyName = "";
  String companyEmail = "";
  String country = "";
  String mobileNumber = "";
  String savedcountryName = "";
  File profilePhoto;
  var progress;
  var _firstNameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _titleController = TextEditingController();
  var _companyNameController = TextEditingController();
  var _companyEmailController = TextEditingController();
  var _mobileController = TextEditingController();
  var _countryController = TextEditingController();
  var selectedCountry;

  // NEW EMAIL AND MOBILE NO UPDATION BOTTOM SHEET
  var _companyNewEmailController = TextEditingController();
  var _newMobileController = TextEditingController();
  var otpController = new TextEditingController();
  var emailOtpController = new TextEditingController();
  bool isEmailLinkSent = false;
  bool isOtpReceived = false;
  bool isEmailOtpReceived = false;
  String newMobileNo = "";
  String otpText = "";
  var newSelectedCountry;
  String _verificationId = "";
  String _emailVerificationId = "";

  String companyNewEmail = "";
  final GlobalKey<ScaffoldState> _mobileScaffoldKey =
      GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _emailScaffoldKey = GlobalKey<ScaffoldState>();

  // ------------------------------------------------ //

  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];

  //Future _countries;
  var _isInit = true;
  bool isDataChanged = false;

  // Future<void> _fetchCountries(BuildContext context) async {
  //   await Provider.of<countryProvider.Countries>(context, listen: false)
  //       .fetchAndSetCountries();
  // }

  void updateInfo(newSelectedCountry, String phoneNumber) {
    setState(() {
      selectedCountry = newSelectedCountry;
      _mobileController.text = phoneNumber;
      isOtpReceived = false;
      // enable the button
      isDataChanged = true;
    });
  }

  void updateEmail(String emailId) {
    _companyEmailController.text = emailId;
    isEmailOtpReceived = false;
    // enable the button
    isDataChanged = true;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      //_countries = _fetchCountries(context);
      setUserInformation();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _firstNameController.dispose();
    // _lastnameController.dispose();
    // _titleController.dispose();
    // _companyNameController.dispose();
    // _companyEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
            child: Builder(
                builder: (context) => SafeArea(
                        child: SingleChildScrollView(
                      child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            children: [
                              Container(
                                child: setUserProfileView(context),
                                margin:
                                    EdgeInsets.only(left: 25.0, right: 25.0),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5.0,
                                    left: 50.0,
                                    bottom: 10,
                                    right: 50.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      openLogoutDialog(context,
                                          "Are you sure you want to logout?");
                                    },
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(0.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18))),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 45,
                                          alignment: Alignment.center,
                                          child: Text("Logout",
                                              style: textWhiteBold16())),
                                    )),
                              ),
                            ],
                          )),
                    )))));
  }

  void setUserInformation() {
    _firstNameController.text = (UserData.instance.userInfo.firstName == null ||
            UserData.instance.userInfo.firstName == 'null')
        ? ''
        : UserData.instance.userInfo.firstName ?? '';

    _lastnameController.text = (UserData.instance.userInfo.lastName == null ||
            UserData.instance.userInfo.lastName == 'null')
        ? ''
        : UserData.instance.userInfo.lastName ?? '';

    _companyEmailController.text =
        (UserData.instance.userInfo.emailId == null ||
                UserData.instance.userInfo.emailId == 'null')
            ? ''
            : UserData.instance.userInfo.emailId ?? '';

    String countryCode;
    if (UserData.instance.userInfo.mobileNo.length == 13 ||
        UserData.instance.userInfo.mobileNo.length == 15) {
      //IN and SG
      countryCode = UserData.instance.userInfo.mobileNo.substring(1, 3);
    } else if (UserData.instance.userInfo.mobileNo.length == 12) {
      // US
      countryCode = UserData.instance.userInfo.mobileNo.substring(1, 2);
    }
    String mobileNo;
    if (UserData.instance.userInfo.mobileNo.length == 13 ||
        UserData.instance.userInfo.mobileNo.length == 15) {
      //IN and SG
      mobileNo = UserData.instance.userInfo.mobileNo
          .substring(3, UserData.instance.userInfo.mobileNo.length);
    } else if (UserData.instance.userInfo.mobileNo.length == 12) {
      // US
      mobileNo = UserData.instance.userInfo.mobileNo
          .substring(2, UserData.instance.userInfo.mobileNo.length);
    }

    for (var i = 0; i < countryList.length; i++) {
      if (countryCode == countryList[i].dialCode.toString()) {
        selectedCountry = countryList[i];
      }
    }
    _mobileController.text = (UserData.instance.userInfo.mobileNo == null ||
            UserData.instance.userInfo.mobileNo == 'null')
        ? ''
        : mobileNo ?? '';

    _countryController.text = UserData.instance.userInfo.countryName;
    // savedcountryName = UserData.instance.userInfo.countryName;
    _companyNameController.text = UserData.instance.userInfo.companyName;
    _titleController.text = UserData.instance.userInfo.designation;
  }

  openLogoutDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          Navigation.openOnBoarding(context);
        },
        child: Text(
          "Yes",
          style: textNormal16(selectedOrange),
        ));

    Widget negativeButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text(
          "No",
          style: textNormal16(selectedOrange),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        message,
        style: textNormal18(headingBlack),
      ),
      actions: [positiveButton, negativeButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setUserProfileView(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal16(),
          controller: _firstNameController,
          onChanged: (value) => {firstname = value},
          decoration: _setTextFieldDecoration("Firstname"),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          controller: _lastnameController,
          style: textBlackNormal16(),
          onChanged: (value) => lastname = value,
          decoration: _setTextFieldDecoration("Lastname"),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          controller: _titleController,
          style: textBlackNormal16(),
          onChanged: (value) => title = value,
          decoration: _setTextFieldDecoration("Title"),
        ),
      ),

      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal16(),
          onChanged: (value) => country = value,
          controller: _countryController,
          decoration: _setTextFieldDecoration("Country"),
        ),
      ),
      // Container(
      //   margin: const EdgeInsets.only(
      //       top: 5.0, left: 25.0, bottom: 20, right: 25.0),
      //   width: MediaQuery.of(context).size.width,
      //   height: 80,
      //   decoration: customDecoration(),
      //   child: FutureBuilder(
      //       future: _countries,
      //       builder: (ctx, dataSnapshot) {
      //         if (dataSnapshot.connectionState == ConnectionState.waiting) {
      //           return Center(
      //               child: CircularProgressIndicator(
      //             backgroundColor: Colors.orange,
      //             valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
      //           ));
      //         } else {
      //           if (dataSnapshot.error != null) {
      //             return Center(child: Text("An error occurred!"));
      //           } else {
      //             return Consumer<countryProvider.Countries>(
      //               builder: (ctx, countryData, child) => Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //                 child: getDropDownSearch(countryData.countries
      //                     .map((info) => {
      //                           'text': info.name,
      //                           'value': info.abbreviation,
      //                         })
      //                     .toList()),
      //               ),
      //             );
      //           }
      //         }
      //       }),
      // ),
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal16(),
          controller: _companyNameController,
          onChanged: (value) => companyName = value,
          decoration: _setTextFieldDecoration("Company Name"),
        ),
      ),

      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: createEditableEmailId(),
      ),

      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        child: createEditableMobileNo(),
      ),
      // UPDATE
      Container(
          margin: const EdgeInsets.only(
              top: 5.0, left: 25.0, bottom: 10, right: 25.0),
          child: ElevatedButton(
            onPressed: !isDataChanged
                ? null
                : () {
                    // on click

                    FocusScope.of(context).requestFocus(FocusNode());
                    String _phoneNumber = "+${selectedCountry.dialCode}" +
                        _mobileController.text.toString().trim();

                    if (_phoneNumber != UserData.instance.userInfo.mobileNo ||
                        _companyEmailController.text.toString().trim() !=
                            UserData.instance.userInfo.emailId) {
                      progress = ProgressHUD.of(context);
                      progress?.showWithText('Updating Profile...');
                      submitDetails(_companyEmailController.text.trim(),
                          _phoneNumber, _verificationId, _emailVerificationId);

                      return;
                    }
                    showSnackBar(
                        context, "Please enter any new data for updation.");
                  },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: Ink(
                decoration: isDataChanged
                    ? BoxDecoration(
                        gradient:
                            LinearGradient(colors: [kDarkOrange, kLightOrange]),
                        borderRadius: BorderRadius.circular(10))
                    : BoxDecoration(
                        gradient:
                            LinearGradient(colors: [kwhiteGrey, kwhiteGrey]),
                        borderRadius: BorderRadius.circular(10)),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      "Update",
                      style: textWhiteBold16(),
                    ))),
          ))
    ]);
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

  InputDecoration _setTextFieldDecoration(_text) {
    return InputDecoration(
      enabled: false,
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

  Widget getDropDownSearch(List<Map<String, dynamic>> items) {
    return DropdownSearch<Map<String, dynamic>>(
      mode: Mode.BOTTOM_SHEET,
      showSearchBox: true,
      showSelectedItem: false,
      items: items,
      itemAsString: (Map<String, dynamic> i) => i['text'],
      hint: "",
      label: savedcountryName != "" ? savedcountryName : 'Country',
      onChanged: (map) {
        setState(() {
          savedcountryName = "";
          country = map['value'];
          print(country);
        });
      },
      dropdownSearchDecoration: InputDecoration(
        labelText: 'Country',
        labelStyle: textNormal18(Colors.grey[600]),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      selectedItem: null,
      maxHeight: 700,
    );
  }

//  ------------------ EMAIL ID --------------------------- //
  Widget createEditableEmailId() {
    return Stack(
      children: [
        TextField(
            enabled: false,
            style: textBlackNormal16(),
            onChanged: (value) => companyEmail = value,
            controller: _companyEmailController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Company Email Id",
                labelStyle: textNormal14(Colors.grey[600]),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 2.0),
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
                  showUpdationView();
                },
                child: Text(
                  "Update",
                  style: textNormal12(Colors.blue),
                )),
          ),
        ),
      ],
    );
  }

  void showUpdationView() {
    emailOtpController = TextEditingController();
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
            return Scaffold(
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
                              "Update Your Email ID",
                              textAlign: TextAlign.start,
                              style: textBold16(headingBlack),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  _companyNewEmailController.clear();
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
                              style: textBlackNormal18(),
                              onChanged: (value) => companyNewEmail = value,
                              controller: _companyNewEmailController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  labelText: "Company Email Id",
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
                              margin:
                                  const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    if (_companyNewEmailController
                                        .text.isEmpty) {
                                      _emailScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Please enter your email id.")));
                                      return;
                                    }

                                    if (!CodeUtils.emailValid(
                                        _companyNewEmailController.text)) {
                                      _emailScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Please enter a valid email id.")));
                                      return;
                                    }
                                    emailOtpController =
                                        TextEditingController();

                                    _getOtp(_companyNewEmailController.text, "",
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
                                            kDarkOrange,
                                            kLightOrange
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Container(
                                          width: 240,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Update Email Id",
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
                                      activeColor: Colors.orange,
                                      activeFillColor: Colors.orange,
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
                                          // verify otp for email id
                                          verifyEmailOTP(
                                              _emailVerificationId,
                                              emailOtpController.text,
                                              _companyNewEmailController.text);
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
                ));
          });
        });
  }

//  ------------------ MOBILE NO --------------------------- //
  Widget createEditableMobileNo() {
    return Row(
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
                    onChanged: (value) => mobileNumber = value,
                    controller: _mobileController,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(15.0),
                      labelText: "Mobile No.",
                      labelStyle: textNormal14(Colors.grey[600]),
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
                      margin:
                          EdgeInsets.only(left: 25.0, right: 20.0, top: 25.0),
                      child: InkWell(
                          onTap: () {
                            // open Bottom sheet
                            showMobileUpdationView();
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
    );
  }

  Widget _buildCodeDropDown() {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0, bottom: 5.0),
        child: DropdownButtonFormField<Countries>(
          decoration: InputDecoration(
              labelText: 'Country Code',
              labelStyle: textNormal14(Colors.grey[600]),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent))),
          value: selectedCountry,
          // onChanged: (Countries countries) {
          //   setState(() {
          //     selectedCountry = countries;
          //   });
          // },
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

  void showMobileUpdationView() {
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
            return Scaffold(
                key: _mobileScaffoldKey,
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
                          child: _createNewMobileFields(),
                        ),
                        Visibility(
                          visible: !isOtpReceived,
                          child: Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (newSelectedCountry == null) {
                                      _mobileScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              content: Text(errorCountryCode)));

                                      return;
                                    }

                                    if (_newMobileController.text.isEmpty) {
                                      _mobileScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              content: Text(correctMobile)));
                                      return;
                                    }

                                    if (newSelectedCountry.maxLength !=
                                        _newMobileController.text.length) {
                                      _mobileScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
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
                                          kDarkOrange,
                                          kLightOrange
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Container(
                                        width: 240,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          sendOtpSecret,
                                          style: textWhiteBold16(),
                                        )),
                                  ))),
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
                                      top: 5.0,
                                      left: 40.0,
                                      bottom: 20,
                                      right: 40.0),
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
                                      activeColor: Colors.orange,
                                      activeFillColor: Colors.orange,
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
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                        top: 20.0, bottom: 20),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (otpController.text.isEmpty) {
                                            _mobileScaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                    duration:
                                                        Duration(seconds: 1),
                                                    content: Text(warningOTP)));
                                            return;
                                          }
                                          // verify otp
                                          verifyMobileOTP(
                                              otpController.text,
                                              _verificationId,
                                              _newMobileController.text.trim(),
                                              setState);
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
                ));
          });
        });
  }

  Row _createNewMobileFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: Container(
              decoration: customDecoration(),
              child: _buildBottomSheetCodeDropDown(),
            )),
        SizedBox(width: 30.0),
        Expanded(
            flex: 2,
            child: Container(
              decoration: customDecoration(),
              child: TextField(
                style: textBlackNormal18(),
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

  Widget _buildBottomSheetCodeDropDown() {
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

// -------------------------------------------------------------------------f\\
  Future<void> _getOtp(String text, newSelectedCountry, StateSetter setState,
      String otpType) async {
    String _phoneNumber = text;
    if (otpType == "mobile_no") {
      _phoneNumber = "+${newSelectedCountry.dialCode}" + text.toString().trim();
    }

    print(_phoneNumber);
    VerificationIdSignIn verificationIdSignIn =
        await UpdateProfileOtpService.getOtp(_phoneNumber, otpType);
    if (verificationIdSignIn.status == 200) {
      progress?.showWithText(successOTP);
      Future.delayed(Duration(milliseconds: 2), () {
        // progress.dismiss();
        if (otpType == "mobile_no") {
          _verificationId = verificationIdSignIn.data.verificationId;
        } else {
          _emailVerificationId = verificationIdSignIn.data.verificationId;
        }

        setState(() {
          if (otpType == "mobile_no") {
            isOtpReceived = true;
          } else {
            isEmailOtpReceived = true;
          }
        });
      });
    } else {
      // progress.dismiss();
      setState(() {
        isOtpReceived = false;
        isEmailOtpReceived = false;
      });
      showSnackBar(context, verificationIdSignIn.message);
    }
  }

  Future<void> verifyMobileOTP(String otpCode, String verificationId,
      String phoneNumber, StateSetter setState) async {
    Default updateProfileOtpService =
        await UpdateProfileOtpService.verifyOtp(verificationId, otpCode);
    if (updateProfileOtpService.status == 200) {
//      progress?.showWithText(successOTP);

      Future.delayed(Duration(milliseconds: 2), () async {
        // progress.dismiss();
        setState(() {
          isOtpReceived = false;
        });
        _mobileController.text = phoneNumber;
        selectedCountry = newSelectedCountry;
        updateInfo(selectedCountry, phoneNumber);
        _mobileScaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text(updateProfileOtpService.message)));
      });

      Future.delayed(Duration(milliseconds: 2), () async {
        Navigator.pop(context);
      });
    } else {
      //progress.dismiss();
      verificationId = "";
      showSnackBar(context, updateProfileOtpService.message);
    }
  }

  Future<void> verifyEmailOTP(
      String emailVerificationId, String otpCode, String emailId) async {
    Default updateProfileOtpService =
        await UpdateProfileOtpService.verifyOtp(emailVerificationId, otpCode);
    if (updateProfileOtpService.status == 200) {
//      progress?.showWithText(successOTP);

      Future.delayed(Duration(milliseconds: 2), () async {
        print("id:- $emailVerificationId");
        // progress.dismiss();
        setState(() {
          isEmailOtpReceived = false;
        });
        updateEmail(emailId);
        _companyNewEmailController.clear();
        emailOtpController.clear();
        _emailScaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text(updateProfileOtpService.message)));
        Navigator.pop(context);
      });
    } else {
      //progress.dismiss();
      emailVerificationId = "";
      showSnackBar(context, updateProfileOtpService.message);
    }
  }

  Future<void> submitDetails(String _email, String _phoneNumber,
      String _verificationId, String _emailVerificationId) async {
    Map<String, dynamic> requestMap = Map();

    if (_email != UserData.instance.userInfo.emailId) {
      requestMap["email_id"] = CryptUtils.encryption(_email);
      requestMap["email_verificationId"] = _emailVerificationId;
    }

    if (_phoneNumber != UserData.instance.userInfo.mobileNo) {
      requestMap["mobile_no"] = CryptUtils.encryption(_phoneNumber);
      requestMap["mobile_verificationId"] = _verificationId;
    }

    Future.delayed(Duration(seconds: 2), () async {
      Default updateResponse =
          await UpdateProfileService.updateUserInfo(requestMap);
      if (updateResponse.status == 200) {
        progress.dismiss();
        _openDialog(context, updateResponse.message);
      } else {
        if (progress != null) {
          progress.dismiss();
        }
        showSnackBar(context, updateResponse.message);
      }
    });
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          Navigation.openOnBoarding(context);
        },
        child: Text(
          "Ok",
          style: textNormal16(selectedOrange),
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
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
