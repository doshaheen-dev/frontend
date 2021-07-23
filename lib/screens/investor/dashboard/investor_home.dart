import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/screens/investor/dashboard/fund_detail.dart';
import 'package:acc/screens/investor/dashboard/product_detail.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../providers/investor_home_provider.dart' as investorProvider;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InvestorHome extends StatefulWidget {
  final UserData userData;

  const InvestorHome(UserData userData, {Key key, UserData data})
      : userData = data,
        super(key: key);

  @override
  _InvestorHomeState createState() => _InvestorHomeState();
}

class _InvestorHomeState extends State<InvestorHome> {
  UserData _userData;

  @override
  void initState() {
    _userData = widget.userData;
    super.initState();
  }

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

  Future _recommendations;
  var _isInit = true;

  Future<void> _fetchRecommendation(BuildContext context) async {
    await Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .fetchAndSetRecommendations(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJDaFp1bXRFQVNPUXZlWmppQWZQUEx3PT0iLCJlbWFpbF9pZCI6ImUvVTVUaWtzWGV1QjB2WGxndUg1eEhTS2hDSnZsVHczRENpZXY2M2R2WG89IiwiZmlyc3RfbmFtZSI6ImV5ZDJmOE0xb3lUc3h5Y0VRbmRjSGc9PSIsIm1pZGRsZV9uYW1lIjpudWxsLCJsYXN0X25hbWUiOiJqMG01aDlUTWZZZ0o1TGNWS0tER3BBPT0iLCJpZCI6MTI3LCJ1c2VyX3R5cGUiOiJpbnZlc3RvciIsImlhdCI6MTYyNjk0ODU5NX0.fCfXSWvNLjM3XucvSpmHtYvGfoFUujs2FqhUU7cbjJc");
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _recommendations = _fetchRecommendation(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: FutureBuilder(
                                  future: _recommendations,
                                  builder: (context, dataSnapshot) {
                                    if (dataSnapshot.error != null) {
                                      return Center(
                                          child: Text("An error occurred!"));
                                    } else {
                                      return Consumer<
                                              investorProvider.InvestorHome>(
                                          builder: (context, recommededData,
                                                  child) =>
                                              Container(
                                                  height: 300.0,
                                                  child: ScrollablePositionedList
                                                      .builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemScrollController:
                                                              itemScrollController,
                                                          itemPositionsListener:
                                                              itemPositionsListener,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              recommededData
                                                                  .recommended
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              width: (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  40),
                                                              child: _buildRecommendationList(
                                                                  context,
                                                                  index,
                                                                  recommededData
                                                                          .recommended[
                                                                      index]),
                                                            );
                                                          })));
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 150 / 2,
                                child: IconButton(
                                    padding: EdgeInsets.only(right: 30),
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
                              Positioned(
                                right: 0,
                                top: 150 / 2,
                                child: IconButton(
                                    padding: EdgeInsets.only(left: 30),
                                    icon: Image.asset(
                                        "assets/images/navigation/arrow_right.png"),
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    color: kDarkOrange,
                                    onPressed: () {
                                      setState(() {
                                        if (currentIndex < 10) {
                                          currentIndex++;

                                          print(currentIndex);
                                          itemScrollController.scrollTo(
                                              index: currentIndex,
                                              duration: Duration(seconds: 1),
                                              curve: Curves.easeInOutCubic);
                                        }
                                      });
                                    }),
                              ),
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
                                    fontFamily: FontFamilyMontserrat.name,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("Your Recently Liked these Funds",
                                  style: TextStyle(
                                    color: textGrey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    fontFamily: FontFamilyMontserrat.name,
                                  )),
                            ])),
                    Container(
                      child: new Stack(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            // color: Colors.red,
                            child: Container(
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
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0, vertical: 5.0),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: _buildFundsList(context, index),
                                      );
                                    })),
                          ),
                          Positioned(
                            left: 0,
                            top: 100 / 2,
                            child: IconButton(
                                padding: EdgeInsets.only(right: 30),
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
                          Positioned(
                            right: 0,
                            top: 100 / 2,
                            child: IconButton(
                                padding: EdgeInsets.only(left: 30),
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

  Widget _buildRecommendationList(BuildContext context, int index,
      investorProvider.Recommended recommended) {
    return GestureDetector(
        onTap: () => {
              print("Name:- ${recommended.fundName}"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                          data: recommended, token: _userData.token)))
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
                    child: Image(
                      image: recommended.fundLogo != ""
                          ? NetworkImage("http://${recommended.fundLogo}")
                          : AssetImage("assets/images/dummy/investment1.png"),
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
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
                        Text(recommended.fundName,
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
                fontSize: 18.0,
                fontFamily: FontFamilyMontserrat.name,
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
                fontFamily: FontFamilyMontserrat.name,
              )),
        ],
      ),
    );
  }
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
