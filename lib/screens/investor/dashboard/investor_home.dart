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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  bool isRecommendationNavigation = false;
  bool isFundsNavigation = false;

  // Recommendations List
  num _recommendationPageSize = 10;
  num totalItems = 0;
  var recommendationPageNo = 0;
  List<investorProvider.FundsInfo> recommendList = [];
  final PagingController<int, investorProvider.FundsInfo> _recPagingController =
      PagingController(firstPageKey: 0);

  // Funds List
  num _fundsPageSize = 10;
  num fundsTotalItems = 0;
  var fundsPageNo = 0;
  List<investorProvider.FundsInfo> fundsList = [];
  final PagingController<int, investorProvider.FundsInfo>
      _intFundsPagingController = PagingController(firstPageKey: 0);

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

  // Future<void> _fetchRecommendation(BuildContext context) async {
  //   await Provider.of<investorProvider.InvestorHome>(context, listen: false)
  //       .fetchAndSetRecommendations(UserData.instance.userInfo.token,
  //           recommendationPageNo, _recommendationPageSize); //_userData.token
  // }

  // Future<void> _fetchInterestedFunds(BuildContext context) async {
  //   await Provider.of<investorProvider.InvestorHome>(context, listen: false)
  //       .fetchAndSetInterestedFunds(UserData.instance.userInfo.token,
  //           fundPageNo, _fundsPageSize); //widget.userData.token
  // }

  void clearAll() {
    Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .clearRecommendations();
    Provider.of<investorProvider.InvestorHome>(context, listen: false)
        .clearInterestedFunds();
  }

  Future<void> _fetchRecPage(int pageKey) async {
    try {
      final invHomePvdr =
          Provider.of<investorProvider.InvestorHome>(context, listen: false);
      invHomePvdr
          .fetchAndSetRecommendations(UserData.instance.userInfo.token,
              recommendationPageNo, _recommendationPageSize)
          .then((_) {
        final list = invHomePvdr.recommended;
        print('List: ${list.length}');
        recommendList.addAll(list);
        print('RecList: ${recommendList.length}');
        setState(() {
          final isLastPage = list.length < _recommendationPageSize;
          if (isLastPage) {
            _recPagingController.appendLastPage(list);
          } else {
            final nextPageKey = pageKey + list.length;
            recommendationPageNo++;
            _recPagingController.appendPage(list, nextPageKey);
          }
        });
      });
    } catch (error) {
      print("RefreshErr: ${error.toString()}");
      _recPagingController.error = error;
    }
  }

  Future<void> _fetchInterestedFundsPage(int pageKey) async {
    try {
      final invHomePvdr =
          Provider.of<investorProvider.InvestorHome>(context, listen: false);
      invHomePvdr
          .fetchAndSetInterestedFunds(
              UserData.instance.userInfo.token, fundPageNo, _fundsPageSize)
          .then((_) {
        final list = invHomePvdr.interestedFundsData;
        print('FList: ${list.length}');
        fundsList.addAll(list);
        print('IFList: ${fundsList.length}');
        setState(() {
          final isLastPage = list.length < _fundsPageSize;
          if (isLastPage) {
            _intFundsPagingController.appendLastPage(list);
          } else {
            final nextPageKey = pageKey + list.length;
            fundPageNo++;
            _intFundsPagingController.appendPage(list, nextPageKey);
          }
        });
      });
    } catch (error) {
      print("RefreshErr: ${error.toString()}");
      _intFundsPagingController.error = error;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _recPagingController.addPageRequestListener((pageKey) {
        _fetchRecPage(pageKey);
      });
      _intFundsPagingController.addPageRequestListener((pageKey) {
        _fetchInterestedFundsPage(pageKey);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getRecommendationListSize();
    getFundsListSize();
    clearAll();
    super.initState();
  }

  @override
  void dispose() {
    _recPagingController.dispose();
    _intFundsPagingController.dispose();
    super.dispose();
  }

  void getFundsListSize() {
    Future<Funds> fundsInfo = InvestorHomeService.fetchInterestedFunds(
        UserData.instance.userInfo.token, fundPageNo, _fundsPageSize);
    fundsInfo.then((result) {
      setState(() {
        fundsTotalItems = result.data.totalCount;
        if (fundsTotalItems == 0) {
          displayInterestedFunds(false);
        } else {
          displayInterestedFunds(true);
        }
      });
    });
  }

  void getRecommendationListSize() {
    var recommendationInfo = InvestorHomeService.fetchRecommendation(
        UserData.instance.userInfo.token,
        recommendationPageNo,
        _recommendationPageSize);
    recommendationInfo.then((result) {
      setState(() {
        totalItems = result.data.totalCount;
        if (totalItems == 0) {
          displayRecommendations(false);
        } else {
          displayRecommendations(true);
        }
      });
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
                    Visibility(
                      visible: isFundsPresent,
                      child: fundsUI(),
                    ),
                  ])),
        ));
  }

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
              Text("You Recently Liked these Funds",
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
                child: setInterestedFund(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget setInterestedFund() {
    return Container(
      height: 150.0,
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _intFundsPagingController.refresh(),
        ),
        color: Colors.orange,
        child: PagedListView<int, investorProvider.FundsInfo>.separated(
          pagingController: _intFundsPagingController,
          scrollDirection: Axis.horizontal,
          builderDelegate:
              PagedChildBuilderDelegate<investorProvider.FundsInfo>(
            animateTransitions: true,
            firstPageProgressIndicatorBuilder: (ctx) => Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            ),
            firstPageErrorIndicatorBuilder: (ctx) => Center(
              child: Text("An error occurred!"),
            ),
            itemBuilder: (context, item, index) => Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
              width: MediaQuery.of(context).size.width * 0.3,
              child: _buildFundsList(context, index, item),
            ),
          ),
          separatorBuilder: (context, index) => const Divider(
            color: Colors.transparent,
          ),
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _buildFundsList(BuildContext context, int index, interestedFundsData) {
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
                    child: CachedNetworkImage(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: interestedFundsData.fundLogo,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Image(
                    //   image: interestedFundsData.fundLogo != ""
                    //       ? NetworkImage(interestedFundsData.fundLogo)
                    //       : AssetImage("assets/images/dummy/investment1.png"),
                    //   height: 80.0,
                    //   width: MediaQuery.of(context).size.width * 0.5,
                    //   fit: BoxFit.fill,
                    // ),
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
            ],
          ),
        ),
      ],
    ));
  }

  Widget setRecommendations() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _recPagingController.refresh(),
      ),
      color: Colors.orange,
      child: PagedListView<int, investorProvider.FundsInfo>.separated(
        pagingController: _recPagingController,
        scrollDirection: Axis.horizontal,
        builderDelegate: PagedChildBuilderDelegate<investorProvider.FundsInfo>(
          animateTransitions: true,
          firstPageProgressIndicatorBuilder: (ctx) => Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orange,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
          firstPageErrorIndicatorBuilder: (ctx) => Center(
            child: Text("An error occurred!"),
          ),
          itemBuilder: (context, item, index) => Container(
            width: (MediaQuery.of(context).size.width - 40),
            child: _buildRecommendationList(context, index, item),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(
          color: Colors.transparent,
        ),
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildRecommendationList(
      BuildContext context, int index, investorProvider.FundsInfo recommended) {
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
                      child: CachedNetworkImage(
                        height: 200.0,
                        imageUrl: recommended.fundLogo,
                        // fit: BoxFit.cover,
                        // placeholder: (context, url) =>
                        //     CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      // Image(
                      //   image: recommended.fundLogo != ""
                      //       ? NetworkImage(recommended.fundLogo)
                      //       : AssetImage("assets/images/dummy/investment1.png"),
                      //   height: 200,
                      //   fit: BoxFit.fill,
                      // ),
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
  // ------------------------------- end of recommendations -------------------------- //
}
