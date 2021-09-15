import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/default.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/screens/investor/dashboard/update/investor_prefs.dart';
import 'package:acc/services/UpdateProfileService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:acc/widgets/update_bottomsheet/address_update.dart';
import 'package:acc/widgets/update_bottomsheet/email_update.dart';
import 'package:acc/widgets/update_bottomsheet/mobile_update.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../providers/country_provider.dart' as countryProvider;

class InvestorProfile extends StatefulWidget {
  const InvestorProfile({Key key}) : super(key: key);

  @override
  _InvestorProfileState createState() => _InvestorProfileState();
}

class _InvestorProfileState extends State<InvestorProfile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String email = "";
  String countryCode = "";
  String countryName = "";
  String address = "";
  String mobileNumber = "";
  String savedcountryName = "";
  var selectedCountry;

  String savedAddress;
  String _verificationId = "";
  String _emailVerificationId = "";
  List<Countries> countryList = <Countries>[
    const Countries("India", "IN", 91, 10),
    const Countries("Singapore", "SG", 65, 12),
    const Countries("United States", "US", 1, 10),
  ];
  var progress;
  var _isInit = true;
  static bool isDataChanged = false;
  Future _countries;

  MobileUpdate mobileUpdate;
  var changedSelectedCountry;
  var changedPhoneNumber;
  var changedMobileVerificationId;

  EmailUpdate emailUpdateCallback;
  var emailIdCallbackValue;
  String changedEmailVerificationId;

  AddressUpdate addressUpdate;
  var changedAddress;

  Future<void> _fetchCountries(BuildContext context) async {
    await Provider.of<countryProvider.Countries>(context, listen: false)
        .fetchAndSetCountries();
  }

  @override
  void initState() {
    super.initState();
    mobileUpdate = MobileUpdate(this.mobileNumber, this.selectedCountry,
        this.changedMobileVerificationId, this.callback);
    emailUpdateCallback = EmailUpdate(this.emailIdCallbackValue,
        this.changedEmailVerificationId, this.emailCallback);
    addressUpdate = AddressUpdate(this.changedAddress, this.addressCallback);
  }

  @override
  void dispose() {
    _addressController.dispose();
    countryCode = "";
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      isDataChanged = false;
      setUserInformation();
      _countries = _fetchCountries(context);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void enableUpdate(bool isActivated) {
    setState(() {
      isDataChanged = isActivated;
    });
  }

  void callback(
      var phoneNumber, var _selectedCountry, String _changedVerificationId) {
    setState(() {
      selectedCountry = _selectedCountry;
      _mobileController.text = phoneNumber;
      _verificationId = _changedVerificationId;
      // enable the button
      enableUpdate(true);
    });
  }

  void emailCallback(String _changedEmailId, String _changedVerificationId) {
    setState(() {
      _emailController.text = _changedEmailId;
      _emailVerificationId = _changedVerificationId;
      // enable the button
      enableUpdate(true);
    });
  }

  void addressCallback(String address) {
    setState(() {
      _addressController.text = address;
      // enable the button
      enableUpdate(true);
    });
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
                child: Column(
              children: [
                Container(
                    child: setUserProfileView(context),
                    margin:
                        EdgeInsets.only(right: 25.0, left: 25.0, bottom: 10.0)),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    //NEXT BUTTON
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 25.0, right: 10.0),
                        child: ElevatedButton(
                          onPressed: !isDataChanged
                              ? null
                              : () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  // on click

                                  submitDetails(
                                      _firstNameController.text.trim(),
                                      _lastnameController.text.trim(),
                                      _emailController.text.trim(),
                                      _mobileController.text.trim(),
                                      countryCode,
                                      _addressController.text,
                                      _verificationId,
                                      _emailVerificationId,
                                      context);
                                },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14))),
                          child: Ink(
                            decoration: isDataChanged
                                ? BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor
                                    ]),
                                    borderRadius: BorderRadius.circular(10))
                                : BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [kwhiteGrey, kwhiteGrey]),
                                    borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text("Update", style: textWhiteBold16()),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 25.0),
                        child: ElevatedButton(
                            onPressed: () {
                              openLogoutDialog(
                                  context, "Are you sure you want to logout?");
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14))),
                            child: Ink(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Logout",
                                      style: textWhiteBold16(),
                                    )))),
                      ),
                    )
                  ],
                )
              ],
            )),
          ))),
    );
  }

  void setUserInformation() {
    print(CryptUtils.encryption(UserData.instance.userInfo.emailId));
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

    String countryCodeLength;
    if (UserData.instance.userInfo.mobileNo.length == 13 ||
        UserData.instance.userInfo.mobileNo.length == 15) {
      //IN and SG
      countryCodeLength = UserData.instance.userInfo.mobileNo.substring(1, 3);
    } else if (UserData.instance.userInfo.mobileNo.length == 12) {
      // US
      countryCodeLength = UserData.instance.userInfo.mobileNo.substring(1, 2);
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
      if (countryCodeLength == countryList[i].dialCode.toString()) {
        selectedCountry = countryList[i];
      }
    }
    _mobileController.text = (UserData.instance.userInfo.mobileNo == null ||
            UserData.instance.userInfo.mobileNo == 'null')
        ? ''
        : mobileNo ?? '';

    _addressController.text = UserData.instance.userInfo.address;
    savedAddress = UserData.instance.userInfo.address;
    //_countryController.text = UserData.instance.userInfo.countryName;
    savedcountryName = UserData.instance.userInfo.countryName;
    countryCode = UserData.instance.userInfo.countryName;
    countryName = UserData.instance.userInfo.countryName;
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
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          textScaleFactor: 1.0,
          style: textNormal18(headingBlack),
        ),
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

  Widget setUserProfileView(BuildContext context) {
    return Column(children: [
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          style: textBlackNormal16(),
          controller: _firstNameController,
          decoration: _setTextFieldDecoration("Firstname", false),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        decoration: customDecoration(),
        child: TextField(
          controller: _lastnameController,
          style: textBlackNormal16(),
          decoration: _setTextFieldDecoration("Lastname", false),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 10),
        child: MobileUpdate(_mobileController.text, selectedCountry,
            _verificationId, mobileUpdate.callback),
      ),
      Container(
        margin: const EdgeInsets.only(
          top: 5.0,
          bottom: 20,
        ),
        decoration: customDecoration(),
        child: EmailUpdate(_emailController.text, _emailVerificationId,
            emailUpdateCallback.updateEmailCallback),
      ),
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: 80,
        decoration: customDecoration(),
        child: FutureBuilder(
            future: _countries,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
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
          top: 5.0,
          bottom: 20,
        ),
        decoration: customDecoration(),
        child: AddressUpdate(_addressController.text, addressUpdate.callback),
      ),
      InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InvestorPreferences()));
        },
        child: Container(
            margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Click Here to Edit preferences",
                          textAlign: TextAlign.start,
                          style: textNormal16(Colors.white)),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        InvestorPreferences()));
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Image.asset(
                            "assets/images/navigation/arrow_right.png",
                            color: Colors.white,
                          ))
                    ]))),
      )
    ]);
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
          countryCode = map['value'];
          countryName = map['text'];
          if (UserData.instance.userInfo.countryName != null &&
              map['text'] != UserData.instance.userInfo.countryName) {
            enableUpdate(true);
          } else {
            if (_addressController.text.toLowerCase() == savedAddress) {
              enableUpdate(false);
            }
          }
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

  InputDecoration _setTextFieldDecoration(_text, bool enabled) {
    return InputDecoration(
      enabled: enabled,
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

  // ------------------------------------------------------------------//
  Future<void> submitDetails(
      String _firstName,
      String _lastName,
      String _emailId,
      String _mobileNo,
      String _countryCode,
      String _address,
      String _verificationId,
      String _emailVerificationId,
      BuildContext context) async {
    String _phoneNumber =
        "+${selectedCountry.dialCode}" + _mobileNo.toString().trim();

    progress = ProgressHUD.of(context);
    progress?.showWithText('Updating Profile...');

    Map<String, dynamic> requestMap = Map();
    var isSignInRequired = false;

    if (UserData.instance.userInfo.countryName != null &&
        countryCode != UserData.instance.userInfo.countryName) {
      requestMap["country_code"] = _countryCode;
    }

    if (_address != UserData.instance.userInfo.address) {
      requestMap["address"] = _address;
      UserData.instance.userInfo.address = _address;
    }

    if (_emailId != UserData.instance.userInfo.emailId) {
      isSignInRequired = true;
      requestMap["email_id"] = CryptUtils.encryption(_emailId);
      requestMap["email_verificationId"] = _emailVerificationId;
    }

    if (_phoneNumber != UserData.instance.userInfo.mobileNo) {
      isSignInRequired = true;
      requestMap["mobile_no"] = CryptUtils.encryption(_phoneNumber);
      requestMap["mobile_verificationId"] = _verificationId;
    }

    Future.delayed(Duration(seconds: 2), () async {
      Default updateResponse =
          await UpdateProfileService.updateUserInfo(requestMap);
      if (updateResponse.status == 200) {
        progress.dismiss();
        savedAddress = _address;
        //_openDialog(context, updateResponse.message);
        if (isSignInRequired) {
          _openDialog(context, updateResponse.message);
        } else {
          showSnackBar(context, updateResponse.message);
          enableUpdate(false);

          UserData userData = UserData(
            UserData.instance.userInfo.token,
            UserData.instance.userInfo.firstName,
            "",
            UserData.instance.userInfo.lastName,
            UserData.instance.userInfo.mobileNo,
            UserData.instance.userInfo.emailId,
            UserData.instance.userInfo.userType,
            "",
            "",
            "",
            _address,
            countryName,
            UserData.instance.userInfo.hearAboutUs,
            UserData.instance.userInfo.referralName,
            UserData.instance.userInfo.slotId,
            UserData.instance.userInfo.productIds,
            UserData.instance.userInfo.emailVerified,
          );
          final prefs = await SharedPreferences.getInstance();
          final userJson = jsonEncode(userData);
          prefs.setString('UserInfo', userJson);
          UserData.instance.userInfo = userData;
        }
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
          textScaleFactor: 1.0, style: textNormal16(headingBlack)),
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
