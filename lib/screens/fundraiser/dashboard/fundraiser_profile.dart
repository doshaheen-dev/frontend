import 'dart:io';

import 'package:acc/models/authentication/signup_request.dart';
import 'package:acc/models/authentication/signup_response.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/services/OtpService.dart';
import 'package:acc/services/signup_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/country_provider.dart' as countryProvider;

class FundraiserProfile extends StatefulWidget {
  FundraiserProfile({Key key}) : super(key: key);

  @override
  _FundraiserProfileState createState() => _FundraiserProfileState();
}

class _FundraiserProfileState extends State<FundraiserProfile> {
  void openOnBoarding() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return OnBoarding();
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
            }),
        (route) => false);
  }

  String firstname = "";
  String lastname = "";
  String title = "";
  String company_name = "";
  String company_email = "";
  String country = "";
  String mobileNumber = "";

  File profilePhoto;
  var progress;
  var _firstNameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _titleController = TextEditingController();
  var _companyNameController = TextEditingController();
  var _companyEmailController = TextEditingController();
  var _mobileController = TextEditingController();

  bool _displayConfirmationText = false;
  String nextButtonText = "Submit for Verification";
  var selectedCountry;

  // NEW EMAIL AND MOBILE NO UPDATION BOTTOM SHEET
  var _companyNewEmailController = TextEditingController();
  var _newMobileController = TextEditingController();
  var otpController = new TextEditingController();
  bool isEmailLinkSent = false;
  bool isOtpReceived = false;
  String newMobileNo = "";
  String otpText = "";
  var newSelectedCountry;
  String _verificationId;
  String companyNewEmail = "";

  // ------------------------------------------------ //

  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];

  Future _countries;
  var _isInit = true;

  Future<void> _fetchCountries(BuildContext context) async {
    await Provider.of<countryProvider.Countries>(context, listen: false)
        .fetchAndSetCountries();
  }

  void showConfirmationText() {
    setState(() {
      _displayConfirmationText = true;
    });
  }

  void updateInfo(newSelectedCountry, String phoneNumber) {
    setState(() {
      selectedCountry = newSelectedCountry;
      _mobileController.text = phoneNumber;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _countries = _fetchCountries(context);
      setUserInformation();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastnameController.dispose();
    _titleController.dispose();
    _companyNameController.dispose();
    _companyEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Container(child: setUserProfileView()),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 25.0, bottom: 10, right: 25.0),
                    child: ElevatedButton(
                        onPressed: () {
                          openLogoutDialog(
                              context, "Are you sure you want to logout?");
                        },
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(0.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18))),
                        child: Ink(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              alignment: Alignment.center,
                              child: Text("Logout", style: textWhiteBold16())),
                        )),
                  ),
                ],
              )),
        ));
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

    country = UserData.instance.userInfo.countryName;
    _companyNameController.text = UserData.instance.userInfo.companyName;
    _titleController.text = UserData.instance.designation;
  }

  openLogoutDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          openOnBoarding();
        },
        child: Text(
          "Yes",
          style: textNormal16(Color(0xff00A699)),
        ));

    Widget negativeButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: Text(
          "No",
          style: textNormal16(Color(0xff00A699)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
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

  setUserProfileView() {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal18(),
          controller: _firstNameController,
          onChanged: (value) => {firstname = value},
          decoration: _setTextFieldDecoration("Firstname"),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
        decoration: customDecoration(),
        child: TextField(
          controller: _lastnameController,
          style: textBlackNormal18(),
          onChanged: (value) => lastname = value,
          decoration: _setTextFieldDecoration("Lastname"),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
        decoration: customDecoration(),
        child: TextField(
          controller: _titleController,
          style: textBlackNormal18(),
          onChanged: (value) => title = value,
          decoration: _setTextFieldDecoration("Title"),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: customDecoration(),
        child: FutureBuilder(
            future: _countries,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
                ));
              } else {
                if (dataSnapshot.error != null) {
                  return Center(child: Text("An error occurred!"));
                } else {
                  return Consumer<countryProvider.Countries>(
                    builder: (ctx, countryData, child) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: getDropDownSearch(countryData.countries
                          .map((info) => {
                                'text': info.name,
                                'value': info.abbreviation,
                              })
                          .toList()),
                    ),
                  );
                }
              }
            }),
      ),
      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal18(),
          controller: _companyNameController,
          onChanged: (value) => company_name = value,
          decoration: _setTextFieldDecoration("Company Name"),
        ),
      ),

      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, right: 25.0, bottom: 20),
        decoration: customDecoration(),
        child: createEditableEmailId(),
      ),

      Container(
        margin: const EdgeInsets.only(
            top: 5.0, left: 25.0, right: 25.0, bottom: 20),
        child: createEditableMobileNo(),
      ),
      // UPDATE
      Container(
          margin: const EdgeInsets.only(
              top: 5.0, left: 25.0, bottom: 20, right: 25.0),
          child: ElevatedButton(
            onPressed: () {
              // on click
              if (_firstNameController.text.isEmpty) {
                showSnackBar(context, "Please enter the Firstname.");
                return;
              }
              if (_lastnameController.text.isEmpty) {
                showSnackBar(context, "Please enter the Lastname.");
                return;
              }
              if (_titleController.text.isEmpty) {
                showSnackBar(context, "Please enter the title.");
                return;
              }
              if (_companyNameController.text.isEmpty) {
                showSnackBar(context, "Please enter the company name.");
                return;
              }
              if (_companyEmailController.text.isEmpty) {
                showSnackBar(context, "Please enter the email id.");
                return;
              }
              if (!CodeUtils.emailValid(_companyEmailController.text)) {
                showSnackBar(context, "Please enter a valid email id.");
                return;
              }
              if (country.isEmpty) {
                showSnackBar(context, "Please select a country.");
                return;
              }
              FocusScope.of(context).requestFocus(FocusNode());

              setState(() {
                // progress = ProgressHUD.of(context);
                // progress?.showWithText(
                //     'Uploading Details...');
                // submitDetails(
                //   _firstNameController.text.trim(),
                //   _lastnameController.text.trim(),
                //   _titleController.text.trim(),
                //   country,
                //   _companyNameController.text,
                //   _companyEmailController.text,
                //);
              });
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18))),
            child: Ink(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [kDarkOrange, kLightOrange]),
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
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
      onChanged: (map) {
        setState(() {
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
            style: textBlackNormal18(),
            onChanged: (value) => company_email = value,
            controller: _companyEmailController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "Company Email Id",
                labelStyle: new TextStyle(color: Colors.grey[600]),
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
            margin: EdgeInsets.only(left: 25.0, right: 20.0, top: 25.0),
            child: InkWell(
                onTap: () {
                  // open Bottom sheet
                  showUpdationView();
                },
                child: Text(
                  "Update",
                  style: textNormal16(Colors.blue),
                )),
          ),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  void showUpdationView() {
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
                              "Update Your Email ID",
                              textAlign: TextAlign.start,
                              style: textBold18(headingBlack),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  _companyNewEmailController.clear();
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
                            visible: isEmailLinkSent,
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 30.0, right: 30.0, bottom: 10.0),
                                child: Text(
                                  corporateVerificationText,
                                  textAlign: TextAlign.center,
                                  style: textNormal16(HexColor("#FE904B")),
                                ))),
                        Visibility(
                          visible: !isEmailLinkSent,
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
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Please enter your email id.")));
                                      return;
                                    }

                                    if (!CodeUtils.emailValid(
                                        _companyNewEmailController.text)) {
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Please enter a valid email id.")));
                                      return;
                                    }

                                    //  progress = ProgressHUD.of(context);
                                    // progress?.showWithText(sendingOtp);
                                    sendVerificationEmail(
                                      _firstNameController.text.trim(),
                                      _lastnameController.text.trim(),
                                      _titleController.text.trim(),
                                      country,
                                      _companyNameController.text,
                                      _companyNewEmailController.text,
                                    );
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
                      ],
                    ),
                  ),
                ));
          });
        });
  }

  Future<void> sendVerificationEmail(
      String firstName,
      String lastName,
      String title,
      String countryCode,
      String companyName,
      String newEmailId) async {
    Navigator.pop(context);
    //if success
    // _companyNewEmailController.text = newEmailId;
    // final requestModelInstance = InvestorSignupRequestModel.instance;
    // requestModelInstance.firstName = CryptUtils.encryption(firstName);
    // requestModelInstance.lastName = CryptUtils.encryption(lastName);
    // requestModelInstance.emailId = CryptUtils.encryption(newEmailId);
    // requestModelInstance.countryCode = countryCode;
    // requestModelInstance.companyName = companyName;
    // requestModelInstance.designation = title;
    // requestModelInstance.userType = 'fundraiser';

    // User signedUpUser =
    //     await SignUpService.uploadUserDetails(requestModelInstance);
    // //progress.dismiss();
    // if (signedUpUser.type == 'success') {
    //   requestModelInstance.clear();
    //   // close bottom sheet and show message
    //   setVerificationSentLink(true);
    // } else {
    //   setVerificationSentLink(false);
    // }

    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          Navigation.openOnBoarding(context);
        },
        child: Text(
          "Sign In",
          style: textNormal16(Color(0xff00A699)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Email sent to your email id. Verify your email"),
      actions: [
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void setVerificationSentLink(bool value) {
    setState(() {
      isEmailLinkSent = value;
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
                    style: textBlackNormal18(),
                    onChanged: (value) => mobileNumber = value,
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
                      margin:
                          EdgeInsets.only(left: 25.0, right: 20.0, top: 25.0),
                      child: InkWell(
                          onTap: () {
                            // open Bottom sheet
                            showMobileUpdationView();
                          },
                          child: Text(
                            "Update",
                            style: textNormal16(Colors.blue),
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
        padding: EdgeInsets.only(left: 10.0, right: 5.0),
        child: DropdownButtonFormField<Countries>(
          decoration: InputDecoration(
              labelText: 'Country Code',
              labelStyle: new TextStyle(color: Colors.grey[600]),
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
                              style: textBold18(headingBlack),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  _newMobileController.clear();
                                  otpController.clear();
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
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              content: Text(errorCountryCode)));

                                      return;
                                    }

                                    if (_newMobileController.text.isEmpty) {
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              content: Text(correctMobile)));
                                      return;
                                    }

                                    if (newSelectedCountry.maxLength !=
                                        _newMobileController.text.length) {
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Phone number should be of ${newSelectedCountry.maxLength} digits.")));

                                      return;
                                    }

                                    //  progress = ProgressHUD.of(context);
                                    // progress?.showWithText(sendingOtp);
                                    _getOtp(_newMobileController.text,
                                        newSelectedCountry, setState);
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
                                            _modelScaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                    content: Text(warningOTP)));
                                            return;
                                          }
                                          // verify otp
                                          _verifySignUpOTP(
                                              otpController.text,
                                              _verificationId,
                                              _newMobileController.text.trim());
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

  Future<void> _getOtp(
      String phoneNumber, newSelectedCountry, StateSetter setState) async {
    String _phoneNumber =
        "+${newSelectedCountry.dialCode}" + phoneNumber.toString().trim();
    print(_phoneNumber);
    VerificationIdSignIn verificationIdSignIn =
        await OtpService.getSignUpOtp(_phoneNumber);
    if (verificationIdSignIn.status == 200) {
      //progress?.showWithText(successOTP);
      Future.delayed(Duration(milliseconds: 2), () {
        // progress.dismiss();
        _verificationId = verificationIdSignIn.data.verificationId;
        setState(() {
          isOtpReceived = true;
        });
      });
    } else {
      // progress.dismiss();
      setState(() {
        isOtpReceived = false;
      });
      showSnackBar(context, verificationIdSignIn.message);
    }
  }

  Future<void> _verifySignUpOTP(
      String otpCode, String verificationId, String phoneNumber) async {
    String _phoneNumber =
        "+${newSelectedCountry.dialCode}" + phoneNumber.toString().trim();
    print(_phoneNumber);

    SignUpInvestor verificationIdSignIn = await OtpService.getVerifySignUpOtp(
        _phoneNumber, verificationId, otpCode);
    if (verificationIdSignIn.status == 200) {
      //progress?.showWithText(successOTP);

      Future.delayed(Duration(milliseconds: 2), () async {
        // progress.dismiss();
        _mobileController.text = phoneNumber;
        selectedCountry = newSelectedCountry;
        updateInfo(selectedCountry, phoneNumber);
        Navigator.pop(context);
      });
    } else {
      //progress.dismiss();
      showSnackBar(context, verificationIdSignIn.message);
    }
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
}
