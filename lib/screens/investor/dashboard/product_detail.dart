import 'package:acc/screens/investor/dashboard/investor_home.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final Recommendations _recommendation;
  const ProductDetail({Key key, Recommendations data})
      : _recommendation = data,
        super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Recommendations _recommendation;
  bool _isFundOverview = false;
  var _changeBgColor = unselectedGray;
  var _selectedTextColor = Colors.black;

  @override
  void initState() {
    _recommendation = widget._recommendation;
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 40.0, left: 15.0, right: 25.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Container(
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset("assets/images/icon_close.png"),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              Image.asset(
                _recommendation.image,
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: Text(
                _recommendation.name,
                style: textBold18(headingBlack),
              )),
              Divider(color: HexColor("#E8E8E8")),
              // Fund overview
              Container(
                child: Card(
                  color: _changeBgColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
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
                                    fontFamily: 'Poppins-Light'))),
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
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text("Fund Regulated")),
                                  Expanded(flex: 1, child: Text("Yes"))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text("Fund Regulator")),
                                  Expanded(flex: 1, child: Text("Rahul Roy"))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text("Website Link")),
                                  Expanded(
                                      flex: 1, child: Text("www.exportbus.com"))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text("Fund Sponsor")),
                                  Expanded(flex: 1, child: Text("Alok Mittal"))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text("Existing Fund")),
                                  Expanded(flex: 1, child: Text("\$300K"))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(flex: 1, child: Text("New Fund")),
                                  Expanded(flex: 1, child: Text("\$200K"))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1, child: Text("Product Type")),
                                  Expanded(
                                      flex: 1, child: Text("Angel Investment"))
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
                              "\$15,000,000",
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
                              "\$15,000,000",
                              style: textBlackNormal16(),
                            ),
                            Text("Min Per Investor",
                                style: textNormal16(kDarkOrange))
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
                            top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                        child: ElevatedButton(
                          onPressed: () {},
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
                                height: 50,
                                alignment: Alignment.center,
                                child: Text("Reject",
                                    style: textWhiteNormal(16.0))),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                          child: ElevatedButton(
                            onPressed: () {},
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
                                height: 50,
                                alignment: Alignment.center,
                                child: Text("Show Interest",
                                    style: textWhiteNormal(16.0)),
                              ),
                            ),
                          )))
                ],
              )
            ]),
          ),
        ));
  }
}
