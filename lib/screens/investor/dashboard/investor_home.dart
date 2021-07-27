import 'dart:math';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/investor/funds.dart';
import 'package:acc/screens/investor/dashboard/fund_detail.dart';
import 'package:acc/screens/investor/dashboard/product_detail.dart';
import 'package:acc/services/investor_home_service.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../providers/investor_home_provider.dart' as investorProvider;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class InvestorHome extends StatefulWidget {
  @override
  _InvestorHomeState createState() => _InvestorHomeState();
}

class _InvestorHomeState extends State<InvestorHome> {
  var currentIndex = 0;
  var _fundscurrentIndex = 0;
  Future _recommendations;
  Future _interestedFunds;

  var fundPageNo = 0;
  var _isInit = true;
  int recommendationListSize;
  int interestedFundsSize;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final ItemScrollController fundItemScrollController = ItemScrollController();
  final ItemPositionsListener fundIitemPositionsListener =
      ItemPositionsListener.create();

  bool isFundsPresent = false;
  bool isRecommendationPresent = false;
  var token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJDaFp1bXRFQVNPUXZlWmppQWZQUEx3PT0iLCJlbWFpbF9pZCI6ImUvVTVUaWtzWGV1QjB2WGxndUg1eEhTS2hDSnZsVHczRENpZXY2M2R2WG89IiwiZmlyc3RfbmFtZSI6ImV5ZDJmOE0xb3lUc3h5Y0VRbmRjSGc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiajBtNWg5VE1mWWdKNUxjVktLREdwQT09IiwiaWQiOjEzNywidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpYXQiOjE2MjczMTA3OTN9.sR8LEOCcX39F6QC06Ac9ITFL-spLBb9txPOwyGjXIco";

  // Recommendations List
  num _recommendationPageSize = 1;
  num totalItems = 10;
  var tempRecommendationSizeList = 0;
  var recommendationPageNo = 0;

  void displayInterestedFunds(bool value) {
    setState(() {
      isFundsPresent = value;
    });
  }

  void displayRecommendations(bool value) {
    setState(() {
      isRecommendationPresent = value;
    });
  }

  Future<void> _fetchRecommendation(BuildContext context) async {
    UserData.instance.token = token;
    await Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .fetchAndSetRecommendations(UserData.instance.token,
            recommendationPageNo, _recommendationPageSize); //_userData.token
  }

  Future<void> _fetchInterestedFunds(BuildContext context) async {
    UserData.instance.token = token;
    await Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .fetchAndSetInterestedFunds(
            UserData.instance.token, fundPageNo); //widget.userData.token
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _recommendations = _fetchRecommendation(context);
      _interestedFunds = _fetchInterestedFunds(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    UserData.instance.token = token;
    getRecommendationListSize();

    Future<Funds> fundsInfo =
        InvestorHomeService.fetchInterestedFunds(UserData.instance.token, 0);
    fundsInfo.then((result) {
      print("Funds");
      setState(() {
        if (result.data.option.length == 0) {
          displayInterestedFunds(false);
        } else {
          displayInterestedFunds(true);
        }
      });
    });
    super.initState();
  }

  void getRecommendationListSize() {
    if (recommendationPageNo <= (totalItems - 1)) {
      var recommendationInfo = InvestorHomeService.fetchRecommendation(
          UserData.instance.token,
          recommendationPageNo,
          _recommendationPageSize);
      recommendationInfo.then((result) {
        setState(() {
          if (result.data.option.length == 0) {
            displayRecommendations(false);
          } else {
            tempRecommendationSizeList =
                tempRecommendationSizeList + result.data.option.length;
            displayRecommendations(true);
          }
        });
      });
    }
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
                    Visibility(
                      visible: isRecommendationPresent,
                      child: recommendationsUI(),
                    ),

                    //FUNDS
                    Visibility(visible: isFundsPresent, child: fundsUI())
                  ])),
        ));
  }

  // ------------------------------- Interested funds -------------------------- //

  Column fundsUI() {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                child: setInterestedFund(),
              ),
              Positioned(
                left: 0,
                top: 100 / 2,
                child: IconButton(
                    padding: EdgeInsets.only(right: 30),
                    icon:
                        Image.asset("assets/images/navigation/arrow_left.png"),
                    iconSize: 20,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: kDarkOrange,
                    onPressed: () {
                      setState(() {
                        print(_fundscurrentIndex);
                        print(fundIitemPositionsListener.itemPositions);
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
                    icon:
                        Image.asset("assets/images/navigation/arrow_right.png"),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: kDarkOrange,
                    onPressed: () {
                      setState(() {
                        if (_fundscurrentIndex < interestedFundsSize) {
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
      ],
    );
  }

  Container setInterestedFund() {
    return Container(
        height: 150.0,
        child: FutureBuilder(
          future: _interestedFunds,
          builder: (context, dataSnapshot) {
            if (dataSnapshot.error != null) {
              return Center(child: Text("An error occurred!"));
            } else {
              return Consumer<investorProvider.InvestorHome>(
                builder: (context, fundsData, child) => Container(
                  height: 300.0,
                  child: ScrollablePositionedList.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemScrollController: fundItemScrollController,
                      itemPositionsListener: fundIitemPositionsListener,
                      scrollDirection: Axis.horizontal,
                      itemCount: fundsData.interestedFundsData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 5.0),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: _buildFundsList(
                              context,
                              index,
                              fundsData.interestedFundsData[index],
                              fundsData.interestedFundsData.length),
                        );
                      }),
                ),
              );
            }
          },
        ));
  }

  Widget _buildFundsList(
      BuildContext context, int index, interestedFundsData, length) {
    interestedFundsSize = length;
    if (length == 0) {
      setState(() {
        isFundsPresent = false;
      });
    } else {
      setState(() {
        isFundsPresent = true;
      });
    }
    return GestureDetector(
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FundDetail(data: interestedFundsData)))
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
                        interestedFundsData.image,
                        height: 80.0,
                        width: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 5.0,
                  ),
                  Center(
                    child: Text(interestedFundsData.name,
                        style: textBold(headingBlack, 12.0)),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  // ------------------------------- end of interested funds -------------------------- //

  // ------------------------------- Recommendation funds -------------------------- //

  Container recommendationsUI() {
    return Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: setRecommendations(),
              ),
              Positioned(
                left: 0,
                top: 150 / 2,
                child: IconButton(
                    padding: EdgeInsets.only(right: 30),
                    icon:
                        Image.asset("assets/images/navigation/arrow_left.png"),
                    iconSize: 20,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: kDarkOrange,
                    onPressed: () {
                      setState(() {
                        if (currentIndex >= 1) {
                          recommendationPageNo--;
                          _recommendations = _fetchRecommendation(context);
                          tempRecommendationSizeList =
                              tempRecommendationSizeList -
                                  _recommendationPageSize;
                          if (tempRecommendationSizeList == 0) {
                            getRecommendationListSize();
                          }
                          currentIndex--;
                          itemScrollController.scrollTo(
                              index: currentIndex,
                              duration: Duration(seconds: 2),
                              curve: Curves.easeInOutCubic);
                        } else {
                          showSnackBar(
                              context, "Start of recommendation items");
                        }
                      });
                    }),
              ),
              Positioned(
                right: 0,
                top: 150 / 2,
                child: IconButton(
                    padding: EdgeInsets.only(left: 30),
                    icon:
                        Image.asset("assets/images/navigation/arrow_right.png"),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: kDarkOrange,
                    onPressed: () {
                      setState(() {
                        if ((totalItems - 1) > (tempRecommendationSizeList)) {
                          if ((currentIndex + 1) == _recommendationPageSize) {
                            recommendationPageNo++;
                            _recommendations = _fetchRecommendation(context);
                            increaseIndex();
                          } else if ((currentIndex + 1) >
                              _recommendationPageSize) {
                            recommendationPageNo++;
                            _recommendations = _fetchRecommendation(context);
                            getRecommendationListSize();
                            increaseIndex();
                          } else {
                            increaseIndex();
                          }
                        } else {
                          showSnackBar(context, "End of recommendation list");
                        }
                      });
                    }),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  FutureBuilder<dynamic> setRecommendations() {
    return FutureBuilder(
      future: _recommendations,
      builder: (context, dataSnapshot) {
        if (dataSnapshot.error != null) {
          return Center(child: Text("An error occurred!"));
        } else {
          return Consumer<investorProvider.InvestorHome>(
            builder: (context, recommededData, child) => Container(
              height: 300.0,
              // child: ScrollablePositionedList.builder(
              //     physics: NeverScrollableScrollPhysics(),
              //     itemScrollController: itemScrollController,
              //     itemPositionsListener: itemPositionsListener,
              //     scrollDirection: Axis.horizontal,
              //     itemCount: recommededData.recommended.length,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         width: (MediaQuery.of(context).size.width - 40),
              //         child: _buildRecommendationList(
              //             context,
              //             index,
              //             recommededData.recommended[index],
              //             recommededData.recommended.length),
              //       );
              //     }),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  // itemScrollController: itemScrollController,
                  // itemPositionsListener: itemPositionsListener,
                  scrollDirection: Axis.horizontal,
                  itemCount: recommededData.recommended.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: (MediaQuery.of(context).size.width - 40),
                      child: _buildRecommendationList(
                          context,
                          index,
                          recommededData.recommended[index],
                          recommededData.recommended.length),
                    );
                  }),
            ),
          );
        }
      },
    );
  }

  Widget _buildRecommendationList(BuildContext context, int index,
      investorProvider.FundsInfo recommended, int length) {
    recommendationListSize = length;

    return GestureDetector(
        onTap: () => {
              print("Name:- ${recommended.fundName}"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                          data: recommended, token: UserData.instance.token)))
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
                    child: Center(
                      child: Image(
                        image: recommended.fundLogo != ""
                            ? NetworkImage(recommended.fundLogo)
                            : AssetImage("assets/images/dummy/investment1.png"),
                        height: 200,
                        fit: BoxFit.fill,
                      ),
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

  void increaseIndex() {
    currentIndex++;

    itemScrollController.scrollTo(
        index: currentIndex,
        duration: Duration(seconds: 3),
        curve: Curves.easeInOutCubic);
  }
  // ------------------------------- end of recommendations -------------------------- //
}
