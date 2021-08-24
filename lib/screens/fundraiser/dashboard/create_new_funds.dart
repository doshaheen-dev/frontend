import 'package:acc/constants/font_family.dart';
import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/widgets/toggle_switch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:acc/services/AuthenticationService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../providers/country_provider.dart' as countryProvider;
import '../../../providers/city_provider.dart' as cityProvider;

class CreateNewFunds extends StatefulWidget {
  @override
  _CreateNewFundsState createState() => _CreateNewFundsState();
}

class _CreateNewFundsState extends State<CreateNewFunds> {
  final _fundNameController = TextEditingController();
  final _fundRegulatorController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _existingFundsController = TextEditingController();
  final _newFundsController = TextEditingController();
  final _websiteController = TextEditingController();

  var progress;
  Future _countries;
  Future _cities;

  var _isInit = true;
  var _isFundRegulated = true;

  var country = '';
  var cityId = 0;
  var selectedCity;

  Future<void> _fetchCountries(BuildContext context) async {
    await Provider.of<countryProvider.Countries>(context, listen: false)
        .fetchAndSetCountries();
  }

  Future<void> _fetchCities(BuildContext context, String country) async {
    await Provider.of<cityProvider.Cities>(context, listen: false)
        .fetchAndSetCitiesByCountry(country);
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
    _fundNameController.dispose();
    _fundRegulatorController.dispose();
    _objectiveController.dispose();
    _existingFundsController.dispose();
    _newFundsController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
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
                        Authentication.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10.0, left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tell us about your fund",
                              style: textBold(headingBlack, 20),
                            ),
                            Text(
                              "Please let us know about the fund ",
                              style: textNormal(textGrey, 17),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, bottom: 20, right: 20.0),
                        child: Column(
                          children: [
                            // Countries dropdown
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: customDecoration(),
                              child: _createDropdownCountries(),
                            ),

                            //Fund Name
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: customDecoration(),
                              child: inputTextField(
                                  "Fund Name",
                                  "Please enter fund name here",
                                  _fundNameController),
                            ),

                            // Cities dropdown
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: customDecoration(),
                              child: _createDropdownCities(),
                            ),

                            // // Cities dropdown
                            // Container(
                            //   margin: const EdgeInsets.only(bottom: 20),
                            //   width: MediaQuery.of(context).size.width,
                            //   decoration: customDecoration(),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.all(10.0),
                            //         child: Text(
                            //           "Fund City",
                            //           style: textNormal16(textGrey),
                            //         ),
                            //         // inputTextField("Fund City",
                            //         //     "Please enter fund city here", null)
                            //       ),
                            //       Spacer(),
                            //       IconButton(
                            //           onPressed: () {
                            //             // _openCityDropdown();
                            //           },
                            //           splashColor: Colors.transparent,
                            //           highlightColor: Colors.transparent,
                            //           icon: Image.asset(
                            //             "assets/images/icon_down.png",
                            //             color: Colors.black,
                            //           ))
                            //     ],
                            //   ),
                            //   //_createDropdownCities(),
                            // ),

                            // Fund regulated
                            Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Fund Regulated",
                                      style:
                                          textNormal(HexColor("#8E8E93"), 14),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: ToggleSwitch(
                                          minWidth: 90.0,
                                          cornerRadius: 20.0,
                                          activeFgColor: Colors.white,
                                          inactiveBgColor: unselectedGray,
                                          inactiveFgColor: Colors.black,
                                          totalSwitches: 2,
                                          labels: ['YES', 'No'],
                                          onToggle: (index) {
                                            print('switched to: $index');
                                            if (index == 0) {
                                              _isFundRegulated = true;
                                            } else {
                                              _isFundRegulated = false;
                                            }
                                          },
                                        )),
                                  ],
                                )),
                            //Fund Regulator (if regulated)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: customDecoration(),
                              child: inputTextField(
                                  "Fund Regulator (if regulated)",
                                  "Please enter the name of fund regulator here",
                                  _fundRegulatorController),
                            ),

                            //Investment Objective
                            Container(
                              height: 150,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: customDecoration(),
                              child: multiLineInputTextField(
                                  "Investment Objective",
                                  "Please provide a brief description of the fund here",
                                  _objectiveController),
                            ),

                            //Total Assets Under Management (Sponsor)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: customDecoration(),
                              child: inputNumberTextField(
                                  "Total Assets Under Management(Sponsor)",
                                  "Please enter fund value here in \$",
                                  _existingFundsController),
                            ),

                            //Target Amount to be Raised
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: customDecoration(),
                              child: inputNumberTextField(
                                  "Target Amount to be Raised",
                                  "Please enter fund value here in \$",
                                  _newFundsController),
                            ),
                            //Funds currently managed by the sponsors
                            Container(
                              decoration: customDecoration(),
                              child: inputTextField(
                                  "Website Link",
                                  "Please enter website link here",
                                  _websiteController),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  //NEXT BUTTON
                  Container(
                      margin: const EdgeInsets.only(
                          left: 25.0, bottom: 20, right: 25.0),
                      child: ElevatedButton(
                          onPressed: () {
                            if (country.isEmpty) {
                              showSnackBar(context, "Please select a country.");
                              return;
                            }
                            if (_fundNameController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the fund name.");
                              return;
                            }
                            if (cityId <= 0) {
                              showSnackBar(context, "Please select a city.");
                              return;
                            }
                            if (_isFundRegulated) {
                              if (_fundRegulatorController.text.isEmpty) {
                                showSnackBar(context,
                                    "Please enter the regulator name.");
                                return;
                              }
                            }
                            if (_objectiveController.text.isEmpty) {
                              showSnackBar(context,
                                  "Please enter the investment objective.");
                              return;
                            }
                            if (_existingFundsController.text.isEmpty) {
                              showSnackBar(context,
                                  "Please enter the existing fund value.");
                              return;
                            }
                            if (_newFundsController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the new fund value.");
                              return;
                            }
                            if (_websiteController.text.isEmpty) {
                              showSnackBar(
                                  context, "Please enter the website link.");
                              return;
                            }
                            bool _validURL =
                                Uri.parse(_websiteController.text).isAbsolute;
                            if (!_validURL) {
                              showSnackBar(context,
                                  "Please enter a valid website link.");
                              return;
                            }
                            FocusScope.of(context).requestFocus(FocusNode());
                            final requestModelInstance =
                                AddFundRequestModel.instance;
                            requestModelInstance.countryCode = country;
                            requestModelInstance.fundName =
                                _fundNameController.text.trim();
                            requestModelInstance.cityId = cityId;
                            requestModelInstance.fundRegulated =
                                _isFundRegulated;
                            requestModelInstance.regulatorName =
                                _fundRegulatorController.text.trim();
                            requestModelInstance.fundInvstmtObj =
                                _objectiveController.text.trim();
                            requestModelInstance.fundExistVal =
                                int.parse(_existingFundsController.text.trim());
                            requestModelInstance.fundNewVal =
                                int.parse(_newFundsController.text.trim());
                            requestModelInstance.fundWebsite =
                                _websiteController.text.trim();

                            openCreateNewFundsContinue();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [kDarkOrange, kLightOrange]),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                alignment: Alignment.center,
                                child: Text("Next", style: textWhiteBold18()),
                              )))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField inputTextField(text, hint, _controller) {
    return TextField(
        onChanged: (text) {},
        style: textBlackNormal16(),
        controller: _controller,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: text,
            hintText: hint,
            hintMaxLines: 2,
            labelStyle: new TextStyle(color: Colors.grey),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  TextField inputNumberTextField(text, hint, _controller) {
    return TextField(
        onChanged: (text) {},
        style: textBlackNormal16(),
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: text,
            hintText: hint,
            hintMaxLines: 2,
            labelStyle: new TextStyle(color: Colors.grey),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  TextField multiLineInputTextField(text, hint, _controller) {
    return TextField(
        onChanged: (text) {},
        style: textBlackNormal16(),
        controller: _controller,
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: text,
            hintText: hint,
            hintMaxLines: 2,
            labelStyle: new TextStyle(color: Colors.grey),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  FutureBuilder<dynamic> _createDropdownCountries() {
    return FutureBuilder(
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
                  child: getDropDownSearch(
                      countryData.countries
                          .map((info) => {
                                'id': info.id,
                                'text': info.name,
                                'value': info.abbreviation,
                              })
                          .toList(),
                      "Fund  Location"),
                ),
              );
            }
          }
        });
  }

  Widget getDropDownSearch(List<Map<String, dynamic>> items, String label) {
    return DropdownSearch<Map<String, dynamic>>(
      mode: Mode.BOTTOM_SHEET,
      showSearchBox: true,
      showSelectedItem: false,
      items: items,
      itemAsString: (Map<String, dynamic> i) => i['text'],
      label: label,
      hint: "Search",
      onChanged: (map) {
        setState(() {
          if (label == "Fund  Location") {
            country = map['value'];
            cityId = 0;
            _cities = _fetchCities(context, country);
          } else {
            cityId = map['id'];
            print('City id: $cityId');
          }
        });
      },
      dropdownSearchDecoration: InputDecoration(
        border: InputBorder.none,
      ),
      emptyBuilder: (ctx, search) => Center(
        child: Text(
          'No $label found',
          style: TextStyle(
            color: Colors.red,
            fontFamily: FontFamilyMontserrat.name,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      selectedItem: null,
      maxHeight: 700,
    );
  }

  FutureBuilder<dynamic> _createDropdownCities() {
    return FutureBuilder(
        future: _cities,
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
              return Consumer<cityProvider.Cities>(
                builder: (ctx, cityData, child) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: getDropDownSearch(
                      cityData.cities
                          .map((info) => {
                                'id': info.id,
                                'text': info.name,
                                'value': info.name,
                              })
                          .toList(),
                      "Fund City"),
                ),
              );
            }
          }
        });
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

  void openCreateNewFundsContinue() {
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext context) => new CreateFundsContinue(),
      ),
    );
  }
}
