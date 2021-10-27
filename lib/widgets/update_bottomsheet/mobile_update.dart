import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/country/country.dart';
import 'package:acc/models/default.dart';
import 'package:acc/models/local_countries.dart';
import 'package:acc/services/country_service.dart';
import 'package:acc/services/update_otp_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:acc/models/local_countries.dart' as localCountry;

// ignore: must_be_immutable
class MobileUpdate extends StatefulWidget {
  String mobileNumber = "";
  var selectedCountry;
  String changedMobileVerificationId;
  bool showUpdate;

  Function(String, dynamic, String) callback;
  MobileUpdate(this.mobileNumber, this.selectedCountry,
      this.changedMobileVerificationId, this.callback, this.showUpdate);

  @override
  _MobileUpdateState createState() => new _MobileUpdateState();
}

class _MobileUpdateState extends State<MobileUpdate> {
  var selectedCountry;
  String mobileNumber = "";
  String _verificationId = "";
  String otpText = "";
  String newMobileNo = "";
  bool isEmailOtpReceived = false;
  bool isOtpReceived = false;

  TextEditingController _mobileController = TextEditingController();
  TextEditingController _newMobileController = TextEditingController();
  TextEditingController otpController = new TextEditingController();
  TextEditingController _countryController = TextEditingController();

  List<localCountry.Countries> newCountryList = [];
  Map<String, dynamic> selectedCountryItem;
  Countries updateSelectedCountry;

  @override
  void initState() {
    getAllCountries();
    _mobileController.text = widget.mobileNumber;
    updateSelectedCountry = widget.selectedCountry;

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
                    child: TextField(
                      enabled: false,
                      style: textBlackNormal16(),
                      controller: _countryController,
                      decoration: new InputDecoration(
                        suffixIcon: Icon(Icons.arrow_drop_down),
                        contentPadding: EdgeInsets.all(15.0),
                        labelText: updateSelectedCountry == null
                            ? "Code"
                            : "Country Code",
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
                    )
                    //_buildCodeDropDown(),
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
                      Visibility(
                        visible: widget.showUpdate,
                        child: Align(
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
                      )
                    ],
                  ),
                ))
          ],
        ));
  }

  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> showUpdationView() async {
    _newMobileController = TextEditingController();
    otpController = new TextEditingController();
    selectedCountryItem = null;

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
                            Container(
                              child: setHeader(),
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

                                        if (updateSelectedCountry == null) {
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

                                        if (updateSelectedCountry.maxLength !=
                                            _newMobileController.text.length) {
                                          _modelScaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  content: Text(
                                                      "Phone number should be of ${updateSelectedCountry.maxLength} digits.")));

                                          return;
                                        }

                                        otpController = TextEditingController();
                                        _getOtp(
                                            _newMobileController.text,
                                            updateSelectedCountry,
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
                                                "Send OTP",
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
                                          "Please enter the OTP received in your mobile phone.",
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
                                                                updateSelectedCountry,
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
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: customDecoration(),
              child: _countryCodeDropDown(newCountryList
                  .map((info) => {
                        'text': info.name,
                        'value': info.dialCode,
                      })
                  .toList()),
            )),
        SizedBox(width: 10.0),
        Expanded(
            flex: 2,
            child: Container(
              decoration: customDecoration(),
              child: TextField(
                style: textBlackNormal16(),
                onChanged: (value) => newMobileNo = value,
                controller: _newMobileController,
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
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

  Widget _countryCodeDropDown(List<Map<String, dynamic>> list) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 5.0),
        child: DropdownSearch<Map<String, dynamic>>(
          mode: Mode.BOTTOM_SHEET,
          showSearchBox: true,
          emptyBuilder: (ctx, search) => Center(
            child: Text('No Data Found',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: FontFamilyMontserrat.bold,
                    fontSize: 26,
                    color: Colors.black)),
          ),
          showSelectedItem: false,
          items: list,
          itemAsString: (Map<String, dynamic> country) =>
              "+${country['value']} ${country['text']} ",
          hint: "",
          selectedItem: selectedCountryItem,
          onChanged: (map) {
            setState(() {
              final index = newCountryList
                  .indexWhere((element) => element.name == map['text']);
              if (index >= 0) {
                updateSelectedCountry = newCountryList[index];
              }
              selectedCountryItem = map;
            });
          },
          dropdownSearchDecoration: InputDecoration(
            border: InputBorder.none,
            labelText: selectedCountryItem == null ? 'Code' : 'Country Code',
            labelStyle: textNormal14(Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(const Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.transparent)),
          ),
          maxHeight: 500,
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
        _countryController.text =
            "+${updateSelectedCountry.dialCode.toString()}";
        this
            .widget
            .callback(phoneNumber, updateSelectedCountry, verificationId);
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

  Future<void> getAllCountries() async {
    // print("Update- ${widget.mobileNumber}");
    final Country extractedData = await CountryService.fetchCountries();
    if (extractedData.type == "success") {
      if (extractedData.data.options.length != 0) {
        newCountryList.clear();
        for (int i = 0; i < extractedData.data.options.length; i++) {
          var value = extractedData.data.options[i];
          newCountryList.add(localCountry.Countries(
              value.countryName,
              value.countryAbbr,
              int.parse(
                  value.countryPhCode.replaceAll(new RegExp(r'[^0-9]'), '')),
              value.maxLength));
        }
        if (newCountryList.isEmpty) {
          newCountryList = <Countries>[
            const Countries("India", "IN", 91, 10),
            const Countries("Singapore", "SG", 65, 12),
            const Countries("United States", "US", 1, 10),
          ];
        }

        // var subString = UserData.instance.userInfo.mobileNo != null
        //     ? UserData.instance.userInfo.mobileNo.substring(0, 5)
        //     : widget.mobileNumber.substring(0, 5);
        var subString = widget.mobileNumber.substring(0, 5);
        for (var i = 0; i < newCountryList.length; i++) {
          if (subString.contains("+${newCountryList[i].dialCode}")) {
            selectedCountry = newCountryList[i];

            _countryController.text = "+${selectedCountry.dialCode.toString()}";
            int length = _countryController.text.toString().length;
            // String result = UserData.instance.userInfo.mobileNo != null
            //     ? UserData.instance.userInfo.mobileNo.substring(0, length)
            //     : widget.mobileNumber.substring(0, length);

            String result = widget.mobileNumber.substring(0, length);

            // _mobileController.text = UserData.instance.userInfo.mobileNo != null
            //     ? UserData.instance.userInfo.mobileNo.replaceAll(result, "")
            //     : widget.mobileNumber.replaceAll(result, "");

            _mobileController.text = widget.mobileNumber.replaceAll(result, "");
            break;
          }
        }
      }
    }
  }

  Widget setHeader() {
    return Padding(
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
    );
  }
}
