import 'dart:io';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/signup_request.dart';
import 'package:acc/models/authentication/signup_response.dart' as response;
import 'package:acc/services/signup_service.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/screens/investor/welcome.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../utils/code_utils.dart';
import '../../../providers/country_provider.dart' as countryProvider;

class CorporateDetails extends StatefulWidget {
  @override
  _CorporateDetailsState createState() => _CorporateDetailsState();
}

class _CorporateDetailsState extends State<CorporateDetails> {
  String firstname = "";
  String lastname = "";
  String title = "";
  String companyName = "";
  String companyEmail = "";
  String country = "";
  File profilePhoto;
  var progress;
  var _firstNameController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _titleController = TextEditingController();
  var _companyNameController = TextEditingController();
  var _companyEmailController = TextEditingController();
  bool _displayConfirmationText = false;
  String nextButtonText = "Submit for Verification";

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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _countries = _fetchCountries(context);
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
          body: ProgressHUD(
            child: Builder(
                builder: (context) => SafeArea(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, size: 30),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 10.0, left: 25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Corporate Sign Up",
                                            style: textBold26(headingBlack),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Please fill out your representative details",
                                            style: textNormal16(textGrey),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  // TEXT FIELDS
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textBlackNormal18(),
                                      controller: _firstNameController,
                                      onChanged: (value) => {firstname = value},
                                      decoration:
                                          _setTextFieldDecoration("Firstname"),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      controller: _lastnameController,
                                      style: textBlackNormal18(),
                                      onChanged: (value) => lastname = value,
                                      decoration:
                                          _setTextFieldDecoration("Lastname"),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      controller: _titleController,
                                      style: textBlackNormal18(),
                                      onChanged: (value) => title = value,
                                      decoration:
                                          _setTextFieldDecoration("Title"),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 80,
                                    decoration: customDecoration(),
                                    child: FutureBuilder(
                                        future: _countries,
                                        builder: (ctx, dataSnapshot) {
                                          if (dataSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ));
                                          } else {
                                            if (dataSnapshot.error != null) {
                                              return Center(
                                                  child: Text(
                                                      "An error occurred!"));
                                            } else {
                                              return Consumer<
                                                  countryProvider.Countries>(
                                                builder:
                                                    (ctx, countryData, child) =>
                                                        Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: getDropDownSearch(
                                                      countryData.countries
                                                          .map((info) => {
                                                                'text':
                                                                    info.name,
                                                                'value': info
                                                                    .abbreviation,
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
                                        left: 25.0,
                                        bottom: 20,
                                        right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textBlackNormal18(),
                                      controller: _companyNameController,
                                      onChanged: (value) => companyName = value,
                                      decoration: _setTextFieldDecoration(
                                          "Company Name"),
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 5.0, left: 25.0, right: 25.0),
                                    decoration: customDecoration(),
                                    child: TextField(
                                      style: textBlackNormal18(),
                                      controller: _companyEmailController,
                                      onChanged: (value) =>
                                          companyEmail = value,
                                      decoration: _setTextFieldDecoration(
                                          "Company Email Id"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Visibility(
                                      visible: _displayConfirmationText,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              left: 30.0,
                                              right: 30.0,
                                              bottom: 10.0),
                                          child: Text(
                                            corporateVerificationText,
                                            textAlign: TextAlign.center,
                                            style: textNormal16(
                                                HexColor("#FE904B")),
                                          ))),
                                  //NEXT BUTTON
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 5.0,
                                          left: 25.0,
                                          bottom: 20,
                                          right: 25.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // on click
                                          if (_firstNameController
                                              .text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the Firstname.");
                                            return;
                                          }
                                          if (_lastnameController
                                              .text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the Lastname.");
                                            return;
                                          }
                                          if (_titleController.text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the title.");
                                            return;
                                          }
                                          if (_companyNameController
                                              .text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the company name.");
                                            return;
                                          }
                                          if (_companyEmailController
                                              .text.isEmpty) {
                                            showSnackBar(context,
                                                "Please enter the email id.");
                                            return;
                                          }
                                          if (!CodeUtils.emailValid(
                                              _companyEmailController.text)) {
                                            showSnackBar(context,
                                                "Please enter a valid email id.");
                                            return;
                                          }
                                          if (country.isEmpty) {
                                            showSnackBar(context,
                                                "Please select a country.");
                                            return;
                                          }
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (nextButtonText ==
                                              'Back to Home') {
                                            openOnboarding();
                                            return;
                                          }

                                          setState(() {
                                            progress = ProgressHUD.of(context);
                                            progress?.showWithText(
                                                'Uploading Details...');
                                            submitDetails(
                                              _firstNameController.text.trim(),
                                              _lastnameController.text.trim(),
                                              _titleController.text.trim(),
                                              country,
                                              _companyNameController.text,
                                              _companyEmailController.text,
                                            );
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18))),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  Theme.of(context).primaryColor
                                                ]),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 60,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  nextButtonText,
                                                  style: textWhiteBold18(),
                                                ))),
                                      )),
                                ])
                          ])),
                    )),
          )),
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

  TextField inputTextField(text) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 16.0,
          fontFamily: FontFamilyMontserrat.name),
      decoration: new InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: text,
        labelStyle: new TextStyle(color: Colors.grey[600]),
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> submitDetails(
    String firstName,
    String lastName,
    String title,
    String countryCode,
    String companyName,
    String companyEmailId,
  ) async {
    final requestModelInstance = InvestorSignupRequestModel.instance;
    requestModelInstance.firstName = CryptUtils.encryption(firstName);
    requestModelInstance.lastName = CryptUtils.encryption(lastName);
    requestModelInstance.emailId = CryptUtils.encryption(companyEmailId);
    requestModelInstance.countryCode = countryCode;
    requestModelInstance.companyName = companyName;
    requestModelInstance.designation = title;
    requestModelInstance.userType = 'fundraiser';

    response.User signedUpUser =
        await SignUpService.uploadUserDetails(requestModelInstance);
    progress.dismiss();
    if (signedUpUser.type == 'success') {
      requestModelInstance.clear();
      showConfirmationText();
      nextButtonText = 'Back to Home';
    } else {
      showSnackBar(context, signedUpUser.message);
    }
  }

  void openWelcomeInvestor() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return WelcomeInvestor();
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

  void openOnboarding() {
    Navigator.of(context).pushAndRemoveUntil(
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
        (Route<dynamic> route) => false);
  }
}
