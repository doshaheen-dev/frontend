import 'package:acc/screens/investor/dashboard/fund_detail.dart';
import 'package:acc/screens/investor/dashboard/product_detail.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InvestorHome extends StatefulWidget {
  InvestorHome({Key key}) : super(key: key);

  @override
  _InvestorHomeState createState() => _InvestorHomeState();
}

class _InvestorHomeState extends State<InvestorHome> {
  List<Recommendations> recommendationList = <Recommendations>[
    const Recommendations(
        "Helion Venture Partners", "assets/images/dummy/investment1.png", null),
    const Recommendations(
        "Sequoia Capital Funds", "assets/images/dummy/investment2.png", null),
    const Recommendations(
        "Big Data Saas Platform", "assets/images/dummy/investment3.png", null),
    const Recommendations(
        "Always Stay Connected", "assets/images/dummy/investment4.png", null),
  ];

  List<LikedFunds> fundsList = <LikedFunds>[
    const LikedFunds(
        "Accel Partners",
        "assets/images/dummy/funds1.png",
        "Pune , India",
        "\$400K-\$500K",
        "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+",
        null),
    const LikedFunds(
        "Accel Partners",
        "assets/images/dummy/funds2.png",
        "Pune , India",
        "\$400K-\$500K",
        "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+",
        null),
    const LikedFunds(
        "Accel Partners",
        "assets/images/dummy/funds3.png",
        "Pune , India",
        "\$400K-\$500K",
        "Elite Specia; Exporter & supplier engaged in offering a varied range of quality products; Already exported 26+ containers valued at \$170k+; Imported Kiwis & Apples valued at \$200k+; Strong sales team in the Middle East; Already raised Rs. 5mn+",
        null),
  ];

  var currentIndex = 0;
  var _fundscurrentIndex = 0;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController fundItemScrollController = ItemScrollController();
  final ItemPositionsListener fundIitemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Column(
                      children: [
                        _createRecommendationHeader(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          child: new Stack(
                            children: <Widget>[
                              Container(
                                  height: 300.0,
                                  child: ScrollablePositionedList.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemScrollController:
                                          itemScrollController,
                                      itemPositionsListener:
                                          itemPositionsListener,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recommendationList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: _buildRecommendationList(
                                              context, index),
                                        );
                                      })),
                              Align(
                                alignment: Alignment.centerLeft,
                                heightFactor: 4,
                                child: IconButton(
                                    icon: Image.asset(
                                        "assets/images/navigation/arrow_left.png"),
                                    iconSize: 20,
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: kDarkOrange,
                                    onPressed: () {
                                      setState(() {
                                        print(currentIndex);
                                        print(itemPositionsListener
                                            .itemPositions);
                                        if (currentIndex > 0) {
                                          currentIndex--;
                                          itemScrollController.scrollTo(
                                              index: currentIndex,
                                              duration: Duration(seconds: 1),
                                              curve: Curves.easeInOutCubic);
                                        }
                                      });
                                    }),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                heightFactor: 4,
                                child: IconButton(
                                    icon: Image.asset(
                                        "assets/images/navigation/arrow_right.png"),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: kDarkOrange,
                                    onPressed: () {
                                      setState(() {
                                        if (currentIndex <
                                            recommendationList.length) {
                                          currentIndex++;

                                          print(currentIndex);
                                          itemScrollController.scrollTo(
                                              index: currentIndex,
                                              duration: Duration(seconds: 1),
                                              curve: Curves.easeInOutCubic);
                                        }
                                      });
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),

                    //FUNDS
                    Container(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 25.0, right: 25.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Your Interests",
                                  style: TextStyle(
                                    color: headingBlack,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontFamily: 'Poppins-Light',
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("Your Recently Liked these Funds",
                                  style: TextStyle(
                                    color: textGrey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins-Light',
                                  )),
                            ])),
                    Container(
                      child: new Stack(
                        children: <Widget>[
                          Container(
                              height: 150.0,
                              child: ScrollablePositionedList.builder(
                                  //shrinkWrap: true,
                                  padding: const EdgeInsets.all(0.0),
                                  itemScrollController:
                                      fundItemScrollController,
                                  itemPositionsListener:
                                      fundIitemPositionsListener,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: fundsList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.all(5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: _buildFundsList(context, index),
                                    );
                                  })),
                          Align(
                            alignment: Alignment.centerLeft,
                            heightFactor: 3,
                            child: IconButton(
                                icon: Image.asset(
                                    "assets/images/navigation/arrow_left.png"),
                                iconSize: 20,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                color: kDarkOrange,
                                onPressed: () {
                                  setState(() {
                                    print(_fundscurrentIndex);
                                    print(fundIitemPositionsListener
                                        .itemPositions);
                                    if (_fundscurrentIndex > 0) {
                                      _fundscurrentIndex--;
                                      fundItemScrollController.scrollTo(
                                          index: _fundscurrentIndex,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.easeInOutCubic);
                                    }
                                  });
                                }),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            heightFactor: 3,
                            child: IconButton(
                                icon: Image.asset(
                                    "assets/images/navigation/arrow_right.png"),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                color: kDarkOrange,
                                onPressed: () {
                                  setState(() {
                                    if (_fundscurrentIndex < fundsList.length) {
                                      _fundscurrentIndex++;

                                      print(_fundscurrentIndex);
                                      fundItemScrollController.scrollTo(
                                          index: _fundscurrentIndex,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.easeInOutCubic);
                                    }
                                  });
                                }),
                          )
                        ],
                      ),
                    ),
                  ])),
        ));
  }

  Widget _buildRecommendationList(BuildContext context, int index) {
    return GestureDetector(
        onTap: () => {
              print("Name:- ${recommendationList[index].name}"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductDetail(data: recommendationList[index])))
            },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.asset(
                        recommendationList[index].image,
                        height: 200.0,
                        fit: BoxFit.fill,
                      )),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Click on the image to accept or reject",
                            style: textNormal(kDarkOrange, 13.0)),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(recommendationList[index].name,
                            style: textBold16(headingBlack)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildFundsList(BuildContext context, int index) {
    return GestureDetector(
        onTap: () => {
              print("Name:- ${fundsList[index].name}"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FundDetail(data: fundsList[index])))
            },
        child: Card(
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.asset(
                        fundsList[index].image,
                        height: 80.0,
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 5.0,
                  ),
                  Center(
                    child: Text(fundsList[index].name,
                        style: textBold(headingBlack, 12.0)),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget _createRecommendationHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Recommendations",
              style: TextStyle(
                color: headingBlack,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'Poppins-Light',
              )),
          SizedBox(
            height: 10.0,
          ),
          Text(
              "Here are investment products specially curated for you based on your preferences",
              style: TextStyle(
                color: textGrey,
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                fontFamily: 'Poppins-Light',
              )),
        ],
      ),
    );
  }
}

class Recommendations {
  const Recommendations(this.name, this.image, this.description);
  final String name;
  final String image;
  final RecommendationData description;
}

class RecommendationData {
  const RecommendationData(this.headerName, this.data);
  final String headerName;
  final String data;
}

class LikedFunds {
  const LikedFunds(this.name, this.image, this.location, this.minimumInvestment,
      this.description, this.data);
  final String name;
  final String image;
  final String location;
  final String minimumInvestment;
  final String description;
  final FundsData data;
}

class FundsData {}
