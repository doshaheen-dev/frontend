import 'dart:io';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/default.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/services/UpdateProfileService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:acc/widgets/update_bottomsheet/email_update.dart';
import 'package:acc/widgets/update_bottomsheet/mobile_update.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
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

  var newSelectedCountry;
  String _verificationId = "";
  String _emailVerificationId = "";
  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];

  //Future _countries;
  var _isInit = true;
  bool isDataChanged = false;
  EmailUpdate emailUpdateCallback;
  var emailIdCallbackValue;
  String changedVerificationId;

  MobileUpdate mobileUpdate;
  var changedSelectedCountry;
  var changedPhoneNumber;
  var changedMobileVerificationId;

  @override
  void initState() {
    super.initState();
    mobileUpdate = MobileUpdate(this.mobileNumber, this.selectedCountry,
        this.changedMobileVerificationId, this.callback);
    emailUpdateCallback = EmailUpdate(this.emailIdCallbackValue,
        this.changedVerificationId, this.emailCallback);
  }

  void callback(
      var phoneNumber, var _selectedCountry, String _changedVerificationId) {
    setState(() {
      selectedCountry = _selectedCountry;
      _mobileController.text = phoneNumber;
      _verificationId = _changedVerificationId;
      // enable the button
      isDataChanged = true;
    });
  }

  void emailCallback(var _changedEmailId, String _changedVerificationId) {
    setState(() {
      _companyEmailController.text = _changedEmailId;
      _emailVerificationId = _changedVerificationId;
      // enable the button
      isDataChanged = true;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      isDataChanged = false;
      setUserInformation();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ProgressHUD(
                child: Builder(
                    builder: (context) => SingleChildScrollView(
                          child: Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                              child: Column(
                                children: [
                                  Container(
                                    child: setUserProfileView(context),
                                    margin: EdgeInsets.only(
                                        left: 25.0, right: 25.0),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: // UPDATE
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5.0,
                                                    left: 25.0,
                                                    bottom: 10,
                                                    right: 10.0),
                                                child: ElevatedButton(
                                                  onPressed: !isDataChanged
                                                      ? null
                                                      : () {
                                                          // on click

                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                          String _phoneNumber =
                                                              "+${selectedCountry.dialCode}" +
                                                                  _mobileController
                                                                      .text
                                                                      .toString()
                                                                      .trim();

                                                          if (_phoneNumber !=
                                                                  UserData
                                                                      .instance
                                                                      .userInfo
                                                                      .mobileNo ||
                                                              _companyEmailController
                                                                      .text
                                                                      .toString()
                                                                      .trim() !=
                                                                  UserData
                                                                      .instance
                                                                      .userInfo
                                                                      .emailId) {
                                                            progress =
                                                                ProgressHUD.of(
                                                                    context);
                                                            progress?.showWithText(
                                                                'Updating Profile...');
                                                            submitDetails(
                                                                _companyEmailController
                                                                    .text
                                                                    .trim(),
                                                                _phoneNumber,
                                                                _verificationId,
                                                                _emailVerificationId);

                                                            return;
                                                          }
                                                          showSnackBar(context,
                                                              "Please enter any new data for updation.");
                                                        },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                    ),
                                                  ),
                                                  child: Ink(
                                                    decoration: isDataChanged
                                                        ? BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15))
                                                        : BoxDecoration(
                                                            color: kwhiteGrey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 45,
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Update",
                                                        style:
                                                            textWhiteBold16(),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0,
                                              bottom: 10,
                                              right: 25.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                openLogoutDialog(context,
                                                    "Are you sure you want to logout?");
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.all(0.0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18))),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 45,
                                                    alignment: Alignment.center,
                                                    child: Text("Logout",
                                                        style:
                                                            textWhiteBold16())),
                                              )),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        )))));
  }

  void setUserInformation() {
    print(
        "User id:- ${CryptUtils.encryption(UserData.instance.userInfo.emailId)}");
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
          textScaleFactor: 1.0,
          style: textNormal16(Theme.of(context).primaryColor),
        ));

    Widget negativeButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text(
          "No",
          textScaleFactor: 1.0,
          style: textNormal16(Theme.of(context).primaryColor),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        message,
        textScaleFactor: 1.0,
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
        child: EmailUpdate(_companyEmailController.text, _emailVerificationId,
            emailUpdateCallback.updateEmailCallback),
      ),
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        child: MobileUpdate(_mobileController.text, selectedCountry,
            _verificationId, mobileUpdate.callback),
      ),
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
      emptyBuilder: (ctx, search) => Center(
        child: Text('No Data Found',
            style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: FontFamilyMontserrat.bold,
                fontSize: 26,
                color: Colors.black)),
      ),
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
          textScaleFactor: 1.0,
          style: textNormal16(Theme.of(context).primaryColor),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message,
          textScaleFactor: 1.0, style: textNormal18(headingBlack)),
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
