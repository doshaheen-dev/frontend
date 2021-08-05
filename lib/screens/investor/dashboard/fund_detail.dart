import 'dart:async';
import 'dart:io';

import 'package:acc/constants/font_family.dart';
import 'package:acc/providers/investor_home_provider.dart';
import 'package:acc/screens/investor/dashboard/pdf_viewer.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FundDetail extends StatefulWidget {
  final FundsInfo _recommendation;
  const FundDetail({Key key, FundsInfo data})
      : _recommendation = data,
        super(key: key);

  @override
  _FundDetailState createState() => _FundDetailState();
}

class _FundDetailState extends State<FundDetail> {
  // String description =
  //     "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn";
  FundsInfo _likedFunds;
  bool _isFundOverview = false;
  bool _isFundDeck = false;
  var _changeBgColor = unselectedGray;
  var _changeFundDeckBgColor = unselectedGray;
  var _selectedFundDeckTextColor = Colors.black;
  var _selectedTextColor = Colors.black;
  String _pefFilePath = "";

  @override
  void initState() {
    _likedFunds = widget._recommendation;
    super.initState();
    createFileOfPdfUrl().then((file) {
      setState(() {
        _pefFilePath = file.path;
        print(_pefFilePath);
      });
    });
  }

  _displayFundOverview() {
    if (_isFundOverview == true) {
      setState(() {
        _isFundOverview = false;
        _changeBgColor = unselectedGray;
        _selectedTextColor = Colors.black;
      });
    } else {
      setState(() {
        _isFundOverview = true;
        _changeBgColor = kDarkOrange;
        _selectedTextColor = Colors.white;
      });
    }
  }

  _displayFundDeck() {
    if (_isFundDeck == true) {
      setState(() {
        _isFundDeck = false;
        _changeFundDeckBgColor = unselectedGray;
        _selectedFundDeckTextColor = Colors.black;
      });
    } else {
      setState(() {
        _isFundDeck = true;
        _changeFundDeckBgColor = kDarkOrange;
        _selectedFundDeckTextColor = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Image.asset("assets/images/icon_close.png"),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  Image(
                    image: _likedFunds.fundLogo != ""
                        ? NetworkImage(_likedFunds.fundLogo)
                        : AssetImage("assets/images/dummy/investment1.png"),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    fit: BoxFit.fill,
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: _createFundHeader(),
                  ),

                  Divider(color: HexColor("#E8E8E8")),
                  // Fund overview
                  Container(
                    child: _createFundBody(),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "\$${_likedFunds.fundNewVal}",
                                  style: textBlackNormal16(),
                                ),
                                Text("Target", style: textNormal16(kDarkOrange))
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  _likedFunds.minimumInvestment,
                                  style: textBlackNormal16(),
                                ),
                                Text("Min Per Investor",
                                    style: textNormal16(kDarkOrange))
                              ],
                            ))
                      ],
                    ),
                  ),
                ]),
          ),
        ));
  }

  Widget _createFundHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _likedFunds.fundName,
          style: textBold18(headingBlack),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/map.png",
              height: 30,
              width: 30,
            ),
            Text(
              "${_likedFunds.city_name}, ${_likedFunds.country_name}",
              style: textNormal(HexColor("#404040"), 12.0),
            )
          ],
        ),
        Text(
          "Minimum Investment : ${_likedFunds.minimumInvestment}",
          style: textNormal(HexColor("#404040"), 12.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          _likedFunds.fund_invstmt_obj,
          style: textNormal(HexColor("#3A3B3F"), 14.0),
        )
      ],
    );
  }

  Widget _createFundBody() {
    return Column(
      children: [
        Container(
          child: _createFundOverview(),
        ),
        Container(
          child: _createFundDeck(),
        )
      ],
    );
  }

  Widget _createFundOverview() {
    return Column(children: [
      Card(
        color: _changeBgColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Fund Overview",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: _selectedTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          fontFamily: FontFamilyMontserrat.name))),
              Spacer(),
              IconButton(
                  onPressed: () {
                    _displayFundOverview();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    "assets/images/icon_down.png",
                    color: _selectedTextColor,
                  ))
            ],
          ),
        ),
      ),
      Visibility(
          visible: _isFundOverview,
          child: Container(
              child: Card(
            color: unselectedGray,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Regulated")),
                          Expanded(
                              flex: 1,
                              child: Text(_likedFunds.fundRegulated == 1
                                  ? "Yes"
                                  : "No"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Regulator")),
                          Expanded(
                              flex: 1,
                              child: Text(_likedFunds.fundRegulatorName))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Website Link")),
                          Expanded(
                              flex: 1, child: Text(_likedFunds.fundWebsite))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Sponsor")),
                          Expanded(
                              flex: 1, child: Text(_likedFunds.fundSponsorName))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Existing Fund")),
                          Expanded(
                              flex: 1,
                              child: Text("\$${_likedFunds.fundExistVal}"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("New Fund")),
                          Expanded(
                              flex: 1,
                              child: Text("\$${_likedFunds.fundNewVal}"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Product Type")),
                          Expanded(flex: 1, child: Text("Angel Investment"))
                        ],
                      )
                    ]))),
          )))
    ]);
  }

  Widget _createFundDeck() {
    return Column(children: [
      Card(
        color: _changeFundDeckBgColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Fund Deck",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: _selectedFundDeckTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          fontFamily: FontFamilyMontserrat.name))),
              Spacer(),
              IconButton(
                  onPressed: () {
                    _displayFundDeck();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    "assets/images/icon_down.png",
                    color: _selectedFundDeckTextColor,
                  ))
            ],
          ),
        ),
      ),
      Visibility(
          visible: _isFundDeck,
          child: Container(
              child: Card(
            color: unselectedGray,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Image.asset(
                                "assets/images/UserProfile.png",
                                height: 150,
                                width: 50,
                                fit: BoxFit.fill,
                              )),
                          Expanded(flex: 1, child: Text("Image/PDF Name"))
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // if image
                            //else if pdf open pdf view
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PDFViewer(pdf: _pefFilePath)));
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
                                width: 100,
                                height: 50,
                                alignment: Alignment.center,
                                child:
                                    Text("View", style: textWhiteNormal(16.0))),
                          ),
                        ),
                      ),
                    ]))),
          )))
    ]);
  }

  Future<File> createFileOfPdfUrl() async {
    final url = "http://www.africau.edu/images/default/sample.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
