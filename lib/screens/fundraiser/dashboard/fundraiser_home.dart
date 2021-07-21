import 'package:acc/screens/fundraiser/dashboard/add_new_funds.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_fund_detail.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';

class FundraiserHome extends StatefulWidget {
  FundraiserHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FundraiserHomeState();
}

bool _fundsAvailable = false;

class _FundraiserHomeState extends State<FundraiserHome> {
  List<SubmittedFunds> fundsList = getSubmittedFundsList();

  @override
  Widget build(BuildContext context) {
    if (fundsList.isEmpty) {
      _fundsAvailable = false;
    } else {
      _fundsAvailable = true;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Column(
            children: [
              Visibility(
                  visible: !_fundsAvailable, child: addNewFundsCell(context)),
              Visibility(
                  visible: _fundsAvailable, child: addSubmittedList(context)),
            ],
          ),
        )));
  }

  Stack addSubmittedList(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: _createHeader(),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return _createCell(fundsList[index], index);
                },
                itemCount: fundsList.length,
                shrinkWrap: true,
              ),
            ),
            Align(
              child: Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Open to add new funds
                      openAddNewFunds();
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
                            child: Text(
                              addNewFunds,
                              style: textWhiteBold18(),
                            ))),
                  )),
            )
          ],
        )
      ],
    );
  }

  InkWell _createCell(SubmittedFunds item, int index) {
    MaterialColor iconColor;
    if (item.type == "Listed") {
      iconColor = Colors.green;
    } else if (item.type == "Under Scrutiny") {
      iconColor = Colors.blue;
    } else if (item.type == "Not Listed") {
      iconColor = Colors.red;
    }

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FundraiserFundDetail(data: fundsList[index])));
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        height: 80,
        decoration: BoxDecoration(
          color: unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: textNormal16(Colors.black)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: Text(
                          "Show Details",
                          style: textNormal12(HexColor("#468FFD")),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        child: Text(
                          "Resubmit",
                          style: textNormal12(HexColor("#FB724C")),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                        child: Text(
                          item.date,
                          style: textNormal12(HexColor("#468FFD")),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              Align(
                child: Icon(Icons.circle, color: iconColor, size: 15.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container addNewFundsCell(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 30.0, left: 30.0),
        child: Column(
          children: [
            Text("You have not adedd any funds yet.",
                style: textBlackNormal16()),
            SizedBox(
              height: 10.0,
            ),
            Container(
                margin: const EdgeInsets.only(
                    top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Open to add new funds
                    openAddNewFunds();
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
                          child: Text(
                            addNewFunds,
                            style: textWhiteBold18(),
                          ))),
                )),
          ],
        ));
  }

  Column _createHeader() {
    return Column(
      children: [
        Text("Select the products you want to raise funds for.",
            style: textNormal(textGrey, 17.0)),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.circle, color: Colors.green, size: 15.0),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Listed", style: textNormal16(HexColor("#2B2B2B")))
                ]),
            SizedBox(
              width: 10,
            ),
            Row(
                // Replace with a Row for horizontal icon + text
                children: <Widget>[
                  Icon(Icons.circle, color: Colors.blue, size: 15.0),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Under Scrutiny",
                      style: textNormal16(HexColor("#2B2B2B")))
                ]),
            SizedBox(
              width: 10,
            ),
            Row(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 15.0,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Not Listed", style: textNormal16(HexColor("#2B2B2B")))
              ],
            )
          ],
        )
      ],
    );
  }

  static List<SubmittedFunds> getSubmittedFundsList() {
    return <SubmittedFunds>[
      const SubmittedFunds(
          "Helion Ventures Partners",
          "Not Listed",
          "21/09/2020",
          "assets/images/dummy/investment1.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Accel Partners",
          "Listed",
          "24/09/2020",
          "assets/images/dummy/funds1.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Big Data Saas Platform",
          "Under Scrutiny",
          "24/09/2020",
          "assets/images/dummy/investment3.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Always Stay Connected",
          "Listed",
          "14/09/2020",
          "assets/images/dummy/investment4.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Cloud Kitchen",
          "Listed",
          "14/09/2020",
          "assets/images/dummy/funds2.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Helion Ventures Partners",
          "Not Listed",
          "21/09/2020",
          "assets/images/dummy/funds3.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Accel Partners",
          "Listed",
          "24/09/2020",
          "assets/images/dummy/funds1.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
      const SubmittedFunds(
          "Big Data Saas Platform",
          "Under Scrutiny",
          "24/09/2020",
          "assets/images/dummy/funds2.png",
          "Pune , India",
          "\$400K-\$500K",
          "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+"),
    ];
  }

  void openAddNewFunds() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return AddNewFunds();
        },
        transitionDuration: Duration(milliseconds: 1000),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation =
              CurvedAnimation(curve: Curves.easeInOutExpo, parent: animation);
          return SlideTransition(
            position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          );
        }));
  }
}

class SubmittedFunds {
  const SubmittedFunds(this.name, this.type, this.date, this.image,
      this.location, this.minimumInvestment, this.description);
  final String name;
  final String type;
  final String date;
  final String image;
  final String location;
  final String minimumInvestment;
  final String description;
}
