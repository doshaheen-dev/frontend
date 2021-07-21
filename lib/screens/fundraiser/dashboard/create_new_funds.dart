import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
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

class CreateNewFunds extends StatefulWidget {
  @override
  _CreateNewFundsState createState() => _CreateNewFundsState();
}

class _CreateNewFundsState extends State<CreateNewFunds> {
  final _fundNameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  var progress;
  Future _countries;
  var _isInit = true;

  var country;

  Future<void> _fetchCountries(BuildContext context) async {
    await Provider.of<countryProvider.Countries>(context, listen: false)
        .fetchAndSetCountries();
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
    _lastnameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
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
                            left: 25.0, bottom: 20, right: 25.0),
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
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 20),
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
                              height: 80,
                              decoration: customDecoration(),
                              child: _createDropdownCities(),
                            ),

                            // Fund regulated
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Fund Regulated",
                                    style: textNormal(HexColor("#8E8E93"), 14),
                                  ),
                                ),
                                Expanded(
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
                                      },
                                    )),
                              ],
                            ),
                            //Fund Regulator (if regulated)
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 20),
                              decoration: customDecoration(),
                              child: inputTextField(
                                  "Fund Regulator (if regulated)",
                                  "Please enter the name of fund regulator here",
                                  null),
                            ),

                            //Investment Objective
                            Container(
                              height: 150,
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 20),
                              decoration: customDecoration(),
                              child: multiLineInputTextField(
                                  "Investment Objective",
                                  "Please provide a brief description of the fund here",
                                  null),
                            ),

                            //Funds currently managed by the sponsors
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 20),
                              decoration: customDecoration(),
                              child: inputTextField(
                                  "Funds currently managed by the sponsors",
                                  "Please enter fund value here in \$",
                                  null),
                            ),

                            //New Fund for which funds are being raised
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 20),
                              decoration: customDecoration(),
                              child: inputTextField(
                                  "New Fund for which funds are being raised ",
                                  "Please enter fund value here in \$",
                                  null),
                            ),
                            //Funds currently managed by the sponsors
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 20),
                              decoration: customDecoration(),
                              child: inputTextField("Website Link",
                                  "Please enter website link here", null),
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
                            FocusScope.of(context).requestFocus(FocusNode());
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
        });
  }

  Widget getDropDownSearch(List<Map<String, dynamic>> items) {
    return DropdownSearch<Map<String, dynamic>>(
      mode: Mode.BOTTOM_SHEET,
      showSearchBox: true,
      showSelectedItem: false,
      items: items,
      itemAsString: (Map<String, dynamic> i) => i['text'],
      label: "Fund  Location",
      hint: "Search your country",
      onChanged: (map) {
        setState(() {
          country = map['value'];
          print(country);
        });
      },
      dropdownSearchDecoration: InputDecoration(
        border: InputBorder.none,
      ),
      selectedItem: null,
      maxHeight: 700,
    );
  }

  FutureBuilder<dynamic> _createDropdownCities() {
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
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Fund  City',
                        labelStyle: new TextStyle(color: Colors.grey[600]),
                        enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(const Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.transparent))),
                    // value: country,
                    items: countryData.countries
                        .map((info) => DropdownMenuItem(
                              child: Text(info.name),
                              value: info.abbreviation,
                            ))
                        .toList(),
                    onChanged: (value) {
                      // print(value);
                      setState(() {
                        country = value;
                      });
                    },
                  ),
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
