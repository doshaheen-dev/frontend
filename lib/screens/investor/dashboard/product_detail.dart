import 'dart:math';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/investor/respond_recommendation.dart';
import 'package:acc/providers/investor_home_provider.dart';
import 'package:acc/screens/investor/dashboard/investor_dashboard.dart';
import 'package:acc/services/investor_home_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class ProductDetail extends StatefulWidget {
  final FundsInfo _recommendation;
  final String _token;
  const ProductDetail({Key key, FundsInfo data, String token})
      : _recommendation = data,
        _token = token,
        super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  FundsInfo _recommendation;
  String _token;
  bool _isFundOverview = false;
  var _changeBgColor = unselectedGray;
  var _selectedTextColor = Colors.black;

  var progress;

  @override
  void initState() {
    _recommendation = widget._recommendation;
    _token = widget._token;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 40.0, left: 15.0, right: 25.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Image.asset(
                                      "assets/images/icon_close.png"),
                                  onPressed: () => {Navigator.pop(context)},
                                ),
                              ),
                              Image(
                                image: _recommendation.fundLogo != ""
                                    ? NetworkImage(_recommendation.fundLogo)
                                    : AssetImage(
                                        "assets/images/dummy/investment1.png"),
                                height: 250,
                                fit: BoxFit.fill,
                              ),

                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                  child: Text(
                                _recommendation.fundName,
                                style: textBold18(headingBlack),
                              )),
                              Divider(color: HexColor("#E8E8E8")),
                              // Fund overview
                              Container(
                                child: Card(
                                  color: _changeBgColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text("Fund Overview",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: _selectedTextColor,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                        FontFamilyMontserrat
                                                            .name))),
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
                              ),
                              Visibility(
                                  visible: _isFundOverview,
                                  child: Container(
                                      child: Card(
                                    color: unselectedGray,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "Fund Regulated")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(_recommendation
                                                                  .fundRegulated ==
                                                              1
                                                          ? "Yes"
                                                          : "No"))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "Fund Regulator")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(_recommendation
                                                          .fundRegulatorName))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child:
                                                          Text("Website Link")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          _recommendation
                                                              .fundWebsite))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child:
                                                          Text("Fund Sponsor")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          _recommendation
                                                              .fundSponsorName))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "Existing Fund")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "\$${_recommendation.fundExistVal}"))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text("New Fund")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "\$${_recommendation.fundNewVal}"))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child:
                                                          Text("Product Type")),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "Angel Investment"))
                                                ],
                                              )
                                            ]))),
                                  ))),
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
                                              "\$${_recommendation.fundNewVal}",
                                              style: textBlackNormal16(),
                                            ),
                                            Text("Target",
                                                style:
                                                    textNormal16(kDarkOrange))
                                          ],
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Text(
                                              _recommendation.minimumInvestment,
                                              style: textBlackNormal16(),
                                            ),
                                            Text("Min Per Investor",
                                                style:
                                                    textNormal16(kDarkOrange))
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 5.0,
                                            left: 5.0,
                                            bottom: 20,
                                            right: 5.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            progress = ProgressHUD.of(context);
                                            progress
                                                ?.showWithText("Please wait");
                                            respondRecommendation(
                                                _recommendation.fundTxnId,
                                                0,
                                                _token);
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
                                                      kDarkOrange,
                                                      kLightOrange
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: Text("Reject",
                                                    style: textWhiteBold16())),
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 5.0,
                                              left: 5.0,
                                              bottom: 20,
                                              right: 5.0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              progress =
                                                  ProgressHUD.of(context);
                                              progress
                                                  ?.showWithText("Please wait");
                                              respondRecommendation(
                                                  _recommendation.fundTxnId,
                                                  1,
                                                  _token);
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
                                                        kDarkOrange,
                                                        kLightOrange
                                                      ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                alignment: Alignment.center,
                                                child: Text("Show Interest",
                                                    style: textWhiteBold16()),
                                              ),
                                            ),
                                          )))
                                ],
                              )
                            ]),
                      ),
                    )))));
  }

  Future<void> respondRecommendation(
      int fundTxnId, int selection, String token) async {
    RespondRecommendation respondRecommendation =
        await InvestorHomeService.acceptRejectRecommendation(
            _recommendation.fundTxnId, selection, token);
    progress.dismiss();
    if (respondRecommendation.status == 200) {
      _openDialog(context, respondRecommendation.message, "Success");
    } else {
      _openDialog(context, respondRecommendation.message, "Failure");
    }
  }

  _openDialog(BuildContext context, String message, String responseType) {
    Widget positiveButton = TextButton(
      onPressed: () {
        if (responseType == "Success") {
          Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                  pageBuilder: (context, animation, anotherAnimation) {
                    return InvestorDashboard();
                  },
                  transitionDuration: Duration(milliseconds: 2000),
                  transitionsBuilder:
                      (context, animation, anotherAnimation, child) {
                    animation = CurvedAnimation(
                        curve: Curves.fastLinearToSlowEaseIn,
                        parent: animation);
                    return SlideTransition(
                      position:
                          Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                              .animate(animation),
                      child: child,
                    );
                  }),
              (Route<dynamic> route) => false);
        }
      },
      child: Text("Ok", style: textNormal16(kDarkOrange)),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message),
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
