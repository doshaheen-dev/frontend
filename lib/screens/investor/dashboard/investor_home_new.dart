import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/investor/funds.dart';
import 'package:acc/providers/investor_home_provider.dart';
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
import 'package:acc/models/investor/recommendation.dart' as recommendation;

class NewInvestorHome extends StatefulWidget {
  @override
  _NewInvestorHomeState createState() => _NewInvestorHomeState();
}

class _NewInvestorHomeState extends State<NewInvestorHome> {
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
  bool isRecommendationNavigation = false;
  bool isFundsNavigation = false;

  // Recommendations List
  num _recommendationPageSize = 1;
  num totalItems = 0;
  var tempRecommendationSizeList = 0;
  var recommendationPageNo = 0;

  // Funds List
  num _fundsPageSize = 5;
  num fundsTotalItems = 10;
  var tempFundsSizeList = 0;
  var fundsPageNo = 0;

  num totalRecommendationItems = 0;
  num itemsPerPage = 0;
  var recommendationTotalPages = 0;

  List<FundsInfo> localRecommended = [];
  var localRecommendedList;
  List<recommendation.Option> recommendationList = [];

  void displayRecommendations(bool value) {
    setState(() {
      isRecommendationPresent = value;
    });
  }

  void displayRecommendationNavigation(bool value) {
    setState(() {
      isRecommendationNavigation = value;
    });
  }

  void displayInterestedFunds(bool value) {
    setState(() {
      isFundsPresent = value;
    });
  }

  Future<void> _fetchRecommendation(BuildContext context) async {
    await Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .fetchAndSetRecommendations(UserData.instance.userInfo.token,
            recommendationPageNo, _recommendationPageSize);
  }

  Future<void> _fetchRecommendationInfo(BuildContext context) async {
    await Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .fetchAndSetRecommendations(UserData.instance.userInfo.token,
            recommendationPageNo, _recommendationPageSize);

    var recommendationInfo = InvestorHomeService.fetchRecommendation(
        UserData.instance.userInfo.token,
        recommendationPageNo,
        _recommendationPageSize);
    recommendationInfo.then((result) {
      totalRecommendationItems = result.data.totalCount;
      recommendationTotalPages = recommendationPageSize();
      itemsPerPage = result.data.option.length;
      print(
          "totalPages:- $recommendationTotalPages \n itemsPerPage:- $itemsPerPage");

      if (result.data.option.length == 0) {
        if (totalRecommendationItems <= 0) {
          displayRecommendations(false);
        }
      } else {
        displayRecommendations(true);

        print(_recommendations);
      }
    });
  }

  Future<void> _fetchInterestedFunds(BuildContext context) async {
    await Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .fetchAndSetInterestedFunds(UserData.instance.userInfo.token,
            fundPageNo, _fundsPageSize); //widget.userData.token
  }

  void getFundsListSize() {
    Future<Funds> fundsInfo = InvestorHomeService.fetchInterestedFunds(
        UserData.instance.userInfo.token, fundPageNo, _fundsPageSize);
    fundsInfo.then((result) {
      print("Funds");
      setState(() {
        if (result.data.option.length == 0) {
          displayInterestedFunds(false);
        } else {
          // if (result.data.option.length > 3) {
          //   displayFundsNavigation(true);
          // } else {
          //   displayFundsNavigation(false);
          // }
          tempFundsSizeList = tempFundsSizeList + result.data.option.length;
          displayInterestedFunds(true);
        }
      });
    });
  }

  void _addNewItem() {
    setState(() {
      print("TIME TO ADD NEW ITEM");
      recommendationPageNo++;
      var recommendationInfo = InvestorHomeService.fetchRecommendation(
          UserData.instance.userInfo.token,
          recommendationPageNo,
          _recommendationPageSize);
      recommendationInfo.then((result) async {
        if (result.data.option.length != 0) {
          itemsPerPage = result.data.option.length;
          print("new item: itemsPerPage $itemsPerPage");

          _recommendations = _fetchRecommendation(context);
        } else {
          showSnackBar(context, "END");
        }
      });
    });
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {});
  //     _recommendations = _fetchRecommendation(context);
  //     _fetchRecommendationInfo(context);
  //   }
  //   // _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      _recommendations = _fetchRecommendation(context);
      _interestedFunds = _fetchInterestedFunds(context);
      _fetchRecommendationInfo(context);
      getFundsListSize();
    });
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
                      icon: Image.asset(
                          "assets/images/navigation/arrow_left.png"),
                      iconSize: 20,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      color: kDarkOrange,
                      onPressed: () {
                        setState(() {
                          print(
                              "currentIndex: ${itemPositionsListener.itemPositions.value.first.index}");
                          var index = itemPositionsListener
                              .itemPositions.value.first.index;
                        });
                      })),
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
                          print(
                              "CLICK: ${itemPositionsListener.itemPositions.value.first.index}");
                          if (recommendationPageNo !=
                              recommendationTotalPages) {
                            var index = itemPositionsListener
                                .itemPositions.value.first.index;

                            if ((index + 1) == itemsPerPage) {
                              print(
                                  "if currentIndex: $index itemsPerPage: $itemsPerPage");
                              // add NEW PAGE
                              _addNewItem();
                              // index++;
                              // itemScrollController.scrollTo(
                              //     index: index,
                              //     duration: Duration(seconds: 1),
                              //     curve: Curves.easeInOutCubic);
                            } else {
                              print(
                                  "else currentIndex: $index itemsPerPage: $itemsPerPage");
                              index++;
                              itemScrollController.scrollTo(
                                  index: index,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeInOutCubic);
                            }
                            print("out: $index itemsPerPage: $itemsPerPage");
                          } else {
                            showSnackBar(context, "FINISH");
                          }
                        });
                      })),
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
        switch (dataSnapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (dataSnapshot.hasError)
              return Center(child: Text("An error occurred!"));
            else
              return Consumer<investorProvider.InvestorHome>(
                builder: (context, recommededData, child) {
                  return Container(
                    height: 300.0,
                    child: ScrollablePositionedList.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
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
                  );
                },
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

  num recommendationPageSize() {
    num totalPages = 0;
    // print(
    //     "quotient: ${(totalRecommendationItems / _recommendationPageSize).floor()}");
    // print("remainder: ${totalRecommendationItems % _recommendationPageSize}");
    totalPages = (totalRecommendationItems / _recommendationPageSize).floor();

    if ((totalRecommendationItems % _recommendationPageSize) >= 1) {
      totalPages = totalPages + 1;
    }
    return totalPages;
  }

  // ------------------------------- end of recommendations -------------------------- //

  // ------------------------------- Interested funds -------------------------- //

  Column fundsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                child:
                    // Visibility(
                    //   visible: isFundsNavigation,
                    //   child:
                    IconButton(
                        padding: EdgeInsets.only(right: 30),
                        icon: Image.asset(
                            "assets/images/navigation/arrow_left.png"),
                        iconSize: 20,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        color: kDarkOrange,
                        onPressed: () {
                          setState(() {
                            if (_fundscurrentIndex >= 1) {
                              fundsPageNo--;
                              _interestedFunds = _fetchInterestedFunds(context);
                              tempFundsSizeList =
                                  tempFundsSizeList - _fundsPageSize;
                              if (tempFundsSizeList == 0) {
                                getFundsListSize();
                              }
                              _fundscurrentIndex = _fundscurrentIndex - 3;
                              fundItemScrollController.scrollTo(
                                  index: currentIndex,
                                  duration: Duration(seconds: 2),
                                  curve: Curves.easeInOutCubic);
                            } else {
                              showSnackBar(context, "Start of funds items");
                            }
                          });
                        }),
              ),
              //   ),
              Positioned(
                  right: 0,
                  top: 100 / 2,
                  child:
                      // Visibility(
                      //     visible: isFundsNavigation,
                      //     child:
                      IconButton(
                          padding: EdgeInsets.only(left: 30),
                          icon: Image.asset(
                              "assets/images/navigation/arrow_right.png"),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          color: kDarkOrange,
                          onPressed: () {
                            setState(() {
                              if ((fundsTotalItems - 3) > (tempFundsSizeList)) {
                                if ((_fundscurrentIndex + 3) ==
                                    tempFundsSizeList) {
                                  fundPageNo++;
                                  _interestedFunds =
                                      _fetchInterestedFunds(context);
                                  _fundscurrentIndex++;

                                  fundItemScrollController.scrollTo(
                                      index: _fundscurrentIndex,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOutCubic);
                                } else if ((_fundscurrentIndex + 3) >
                                    _fundsPageSize) {
                                  fundsPageNo++;
                                  _interestedFunds =
                                      _fetchInterestedFunds(context);
                                  getFundsListSize();
                                  _fundscurrentIndex = _fundscurrentIndex + 3;

                                  fundItemScrollController.scrollTo(
                                      index: _fundscurrentIndex,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOutCubic);
                                } else {
                                  _fundscurrentIndex = _fundscurrentIndex + 3;

                                  fundItemScrollController.scrollTo(
                                      index: _fundscurrentIndex,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.easeInOutCubic);
                                }
                              } else {
                                showSnackBar(context, "End of funds list");
                              }
                            });
                          })),
              // )
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

    // setState(() {
    //   if (length == 0) {
    //     isFundsPresent = false;
    //   } else {
    //     isFundsPresent = true;
    //   }
    // });
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
                    child: Image(
                      image: interestedFundsData.fundLogo != ""
                          ? NetworkImage(interestedFundsData.fundLogo)
                          : AssetImage("assets/images/dummy/investment1.png"),
                      height: 80.0,
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Center(
                    child: Text(interestedFundsData.fundName,
                        textAlign: TextAlign.center,
                        style: textBold(headingBlack, 12.0)),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  // ------------------------------- end of interested funds -------------------------- //
}
