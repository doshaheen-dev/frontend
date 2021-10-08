import 'package:acc/constants/font_family.dart';
import 'package:acc/providers/investor_home_provider.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FundDetail extends StatefulWidget {
  final FundsInfo _recommendation;
  const FundDetail({Key key, FundsInfo data})
      : _recommendation = data,
        super(key: key);

  @override
  _FundDetailState createState() => _FundDetailState();
}

class _FundDetailState extends State<FundDetail> {
  FundsInfo _likedFunds;
  bool _isFundOverview = true;
  var _selectedTextColor = Colors.black;

  @override
  void initState() {
    _likedFunds = widget._recommendation;
    super.initState();
  }

  _displayFundOverview() {
    if (_isFundOverview == true) {
      setState(() {
        _isFundOverview = false;
        _selectedTextColor = Colors.black;
      });
    } else {
      setState(() {
        _isFundOverview = true;
        _selectedTextColor = Colors.white;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Image.asset("assets/images/icon_close.png"),
                          onPressed: () => {Navigator.pop(context)},
                        ),
                      ),
                      Center(
                          child: Image(
                        image: _likedFunds.fundLogo != ""
                            ? NetworkImage(_likedFunds.fundLogo)
                            : AssetImage("assets/images/dummy/investment1.png"),
                        height: 250,
                        fit: BoxFit.fitHeight,
                      )),
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
                        margin: EdgeInsets.only(bottom: 10.0),
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
                                    Text("Target",
                                        style: textNormal16(
                                            Theme.of(context).primaryColor))
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ]),
              ),
            )));
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
      ],
    );
  }

  Widget _createFundOverview() {
    return Column(children: [
      Card(
        color:
            _isFundOverview ? Theme.of(context).primaryColor : unselectedGray,
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
                          color: _isFundOverview
                              ? Colors.white
                              : _selectedTextColor,
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
                    color: _isFundOverview ? Colors.white : _selectedTextColor,
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
                      if (_likedFunds.fundRegulated == 1)
                        Container(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 1, child: Text("Fund Regulator")),
                                Expanded(
                                    flex: 1,
                                    child: Text(_likedFunds.fundRegulatorName))
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            )
                          ],
                        )),
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
                    ]))),
          )))
    ]);
  }
}
