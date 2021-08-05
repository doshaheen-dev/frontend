import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/authentication/signup_request.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/default.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/models/profile/update_profile_request.dart';
import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/services/OtpService.dart';
import 'package:acc/services/update_otp_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/country_provider.dart' as countryProvider;

class InvestorProfile extends StatefulWidget {
  InvestorProfile({Key key}) : super(key: key);

  @override
  _InvestorProfileState createState() => _InvestorProfileState();
}

class _InvestorProfileState extends State<InvestorProfile> {
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

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String firstname = "";
  String lastname = "";
  String email = "";
  String country = "";
  String address = "";
  String mobileNumber = "";
  String savedcountryName = "";
  var selectedCountry;

//---------- bottom sheet ---------------------------//
  TextEditingController _newMobileController = TextEditingController();
  TextEditingController otpController = new TextEditingController();
  var _newEmailController = TextEditingController();
  var emailOtpController = new TextEditingController();

  bool isOtpReceived = false;
  String newMobileNo = "";
  String otpText = "";
  String newEmail = "";
  bool isEmailOtpReceived = false;

  var newSelectedCountry;
  String _verificationId = "";

  String _emailVerificationId = "";
// ------------------------------------------------ //

  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];

  var progress;
  Future _countries;
  var _isInit = true;

  Future<void> _fetchCountries(BuildContext context) async {
    await Provider.of<countryProvider.Countries>(context, listen: false)
        .fetchAndSetCountries();
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _addressController = TextEditingController();
    _newMobileController = TextEditingController();
    otpController = new TextEditingController();
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

  void updateInfo(newSelectedCountry, String phoneNumber) {
    setState(() {
      selectedCountry = newSelectedCountry;
      _mobileController.text = phoneNumber;
    });
  }

  void updateEmail(String emailId) {
    setState(() {
      _emailController.text = emailId;
    });
  }

  // @override
  // void dispose() {
  //   _firstNameController.dispose();
  //   _lastnameController.dispose();
  //   _emailController.dispose();
  //   _addressController.dispose();
  //   // _mobileController.dispose();
  //   //_newMobileController.dispose();
  //   // otpController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
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
                          child: Text(
                            "Logout",
                            style: textWhiteBold16(),
                          )))),
            ),
          ],
        ))));
  }

  void setUserInformation() {
    print(
        "UserData:- ${UserData.instance.userInfo.firstName}, LastName: -${UserData.instance.userInfo.lastName}");
    print(
        "MobileNo:- ${CryptUtils.encryption(UserData.instance.userInfo.mobileNo)}, emailId: -${CryptUtils.encryption("test1234@mailinator.com")}");
    String text =
        CryptUtils.decryption("JkLVXZVc/tXIIg3yUPHZKAj1POYfmQCHy217e5uxL+8=");
    print(text);

    _firstNameController.text = (UserData.instance.userInfo.firstName == null ||
            UserData.instance.userInfo.firstName == 'null')
        ? ''
        : UserData.instance.userInfo.firstName ?? '';

    _lastnameController.text = (UserData.instance.userInfo.lastName == null ||
            UserData.instance.userInfo.lastName == 'null')
        ? ''
        : UserData.instance.userInfo.lastName ?? '';

    _emailController.text = (UserData.instance.userInfo.emailId == null ||
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

    _addressController.text = UserData.instance.userInfo.address;
    savedcountryName = UserData.instance.userInfo.countryName;
    print("country: $savedcountryName");
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

  Widget setUserProfileView() {
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
        //decoration: customDecoration(),
        child: _createMobileFields(),
      ),
      Container(
        margin: const EdgeInsets.only(
          top: 5.0,
          left: 25.0,
          right: 25.0,
          bottom: 20,
        ),
        decoration: customDecoration(),
        child: createEditableEmailId(),
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
        margin: const EdgeInsets.only(top: 5.0, left: 25.0, right: 25.0),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal18(),
          controller: _addressController,
          onChanged: (value) => address = value,
          decoration: _setTextFieldDecoration("Address 1"),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      //NEXT BUTTON
      Container(
        margin: const EdgeInsets.only(left: 25.0, bottom: 10, right: 25.0),
        child: ElevatedButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            // on click
            // if (_firstNameController.text.isEmpty) {
            //   showSnackBar(context, "Please enter the Firstname.");
            //   return;
            // }
            // if (_lastnameController.text.isEmpty) {
            //   showSnackBar(context, "Please enter the Lastname.");
            //   return;
            // }
            // if (_mobileController.text.isEmpty) {
            //   showSnackBar(context, "Please enter the mobile no.");
            //   return;
            // }
            // if (selectedCountry == null) {
            //   showSnackBar(context, errorCountryCode);
            //   return;
            // }

            // if (selectedCountry.maxLength != _mobileController.text.length) {
            //   showSnackBar(context,
            //       "Phone number should be of ${selectedCountry.maxLength} digits.");
            //   return;
            // }

            // if (_emailController.text.isEmpty) {
            //   showSnackBar(context, "Please enter the email id.");
            //   return;
            // }
            // if (!CodeUtils.emailValid(_emailController.text)) {
            //   showSnackBar(context, "Please enter a valid email id.");
            //   return;
            // }
            // if (country.isEmpty) {
            //   showSnackBar(context, "Please select a country.");
            //   return;
            // }
            // if (_addressController.text.isEmpty) {
            //   showSnackBar(context, "Please enter the address.");
            //   return;
            // }
            FocusScope.of(context).requestFocus(FocusNode());
            submitDetails(
                _firstNameController.text.trim(),
                _lastnameController.text.trim(),
                _emailController.text.trim(),
                _mobileController.text.trim(),
                country,
                _addressController.text,
                _verificationId,
                _emailVerificationId);
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18))),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [kDarkOrange, kLightOrange]),
                borderRadius: BorderRadius.circular(15)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              alignment: Alignment.center,
              child: Text("Update", style: textWhiteBold16()),
            ),
          ),
        ),
      )
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
        labelStyle: new TextStyle(
          color: Colors.grey[600],
          fontFamily: FontFamilyMontserrat.name,
          fontSize: 18,
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      selectedItem: null,
      maxHeight: 700,
    );
  }

  Row _createMobileFields() {
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
                            showUpdationView();
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

  //------------------ EMAIL ID --------------------------- //
  Widget createEditableEmailId() {
    return Stack(
      // clipBehavior: Clip.none,
      children: [
        TextField(
            enabled: false,
            style: textBlackNormal18(),
            onChanged: (value) => email = value,
            controller: _emailController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                labelText: "E-mail Id",
                labelStyle: new TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 2.0),
                  borderRadius: BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ))),
        Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.only(right: 10.0, top: 25.0),
            child: InkWell(
                onTap: () {
                  // open Bottom sheet
                  showEmailUpdationView();
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
                              "Update Your E-mail ID",
                              textAlign: TextAlign.start,
                              style: textBold18(headingBlack),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  _newEmailController.clear();
                                  emailOtpController.clear();
                                  setState(() {
                                    isOtpReceived = false;
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
                              margin:
                                  const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    if (_newEmailController.text.isEmpty) {
                                      _emailScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Please enter your email id.")));
                                      return;
                                    }

                                    if (!CodeUtils.emailValid(
                                        _newEmailController.text)) {
                                      _emailScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
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
                                              _newEmailController.text);
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

  // -------------------- Mobile Number ---------------------------------- \\

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
                              margin:
                                  const EdgeInsets.only(top: 20.0, bottom: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (newSelectedCountry == null) {
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(errorCountryCode)));

                                      return;
                                    }

                                    if (_newMobileController.text.isEmpty) {
                                      _modelScaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text(correctMobile)));
                                      return;
                                    }

                                    if (newSelectedCountry.maxLength !=
                                        _newMobileController.text.length) {
                                      _modelScaffoldKey.currentState
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
                                                  style: textWhiteBold16(),
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
        _modelScaffoldKey.currentState.showSnackBar(SnackBar(
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
        _newEmailController.clear();
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

  // ------------------------------------------------------------------//
  Future<void> submitDetails(
      String _firstName,
      String _lastName,
      String _emailId,
      String _mobileNo,
      String _countryCode,
      String _address,
      String _verificationId,
      String emailVerificationId) async {
    String _phoneNumber =
        "+${selectedCountry.dialCode}" + _mobileNo.toString().trim();

    final requestModelInstance = UpdateProfileRequestModel.instance;
    if (_firstName != UserData.instance.userInfo.firstName) {
      requestModelInstance.firstName = CryptUtils.encryption(_firstName);
    }

    if (_lastName != UserData.instance.userInfo.lastName) {
      requestModelInstance.lastName = CryptUtils.encryption(_lastName);
    }

    if (_emailId != UserData.instance.userInfo.emailId) {
      requestModelInstance.emailId = CryptUtils.encryption(_emailId);
      requestModelInstance.emailVerificationId = emailVerificationId;
    }

    if (_phoneNumber != UserData.instance.userInfo.mobileNo) {
      requestModelInstance.mobileNo = CryptUtils.encryption(_phoneNumber);
      requestModelInstance.mobileVerificationId = _verificationId;
    }

    if (country != UserData.instance.userInfo.countryName) {
      requestModelInstance.countryCode = _countryCode;
    }

    if (_address != UserData.instance.userInfo.address) {
      requestModelInstance.address = address;
    }

    print("Model User:- ${requestModelInstance}");

    // User signedUpUser =
    //     await SignUpService.uploadUserDetails(requestModelInstance);
    // progress.dismiss();
    // if (signedUpUser.type == 'success') {
    //   requestModelInstance.clear();
    //   // print("Firstn: ${signedUpUser.data.firstName}");
    //   UserData userData = UserData(
    //       signedUpUser.data.token,
    //       signedUpUser.data.firstName,
    //       "",
    //       signedUpUser.data.lastName,
    //       signedUpUser.data.mobileNo,
    //       signedUpUser.data.emailId,
    //       signedUpUser.data.userType,
    //       "",
    //       signedUpUser.data.designation,
    //      signedUpUser.data.designation,
    //      signedUpUser.data.designation,
    //      signedUpUser.data.designation, );
    //   final prefs = await SharedPreferences.getInstance();
    //   final userJson = jsonEncode(userData);
    //   prefs.setString('UserInfo', userJson);
    //   UserData.instance.userInfo = userData;
    //   print('${userData.firstName}');
    //   print('Ins:${UserData.instance.userInfo.firstName}');
    // } else {
    //   showSnackBar(context, "Something went wrong");
    // }
  }
}
