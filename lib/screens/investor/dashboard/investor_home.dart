import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/investor/funds.dart';
import 'package:acc/models/investor/respond_recommendation.dart';
import 'package:acc/screens/investor/dashboard/fund_detail.dart';
import 'package:acc/screens/investor/dashboard/product_detail.dart';
import 'package:acc/services/investor_home_service.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/widgets/exception_indicators/empty_list_indicator.dart';
import 'package:acc/widgets/exception_indicators/empty_list_text.dart';
import 'package:acc/widgets/exception_indicators/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../../providers/investor_home_provider.dart' as investorProvider;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';

class InvestorHome extends StatefulWidget {
  @override
  _InvestorHomeState createState() => _InvestorHomeState();
}

class _InvestorHomeState extends State<InvestorHome>
    with TickerProviderStateMixin {
  var currentIndex = 0;
  var fundPageNo = 0;
  var _isInit = true;
  int recommendationListSize;
  int interestedFundsSize;
  bool isFundsPresent = false;
  bool isRecommendationPresent = false;
  bool isRecommendationNavigation = false;
  bool isFundsNavigation = false;
  // Recommendations List
  num _recommendationPageSize = 10;
  num totalItems = 0;
  var recommendationPageNo = 0;
  final PagingController<int, investorProvider.FundsInfo> _recPagingController =
      PagingController(firstPageKey: 0);
  // Funds List
  num _fundsPageSize = 10;
  num fundsTotalItems = 0;
  var fundsPageNo = 0;
  final PagingController<int, investorProvider.FundsInfo>
      _intFundsPagingController = PagingController(firstPageKey: 0);
  var progress;
  investorProvider.FundsInfo currentItem;
  num currentItemIndex = 0;

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
              (pageKey ~/ _recommendationPageSize), _recommendationPageSize)
          .then((_) {
        final list = invHomePvdr.recommended;
        print('List: ${list.length}');
        setState(() {
          final isLastPage = list.length < _recommendationPageSize;
          if (isLastPage) {
            _recPagingController.appendLastPage(list);
          } else {
            final nextPageKey = pageKey + list.length;
            _recPagingController.appendPage(list, nextPageKey);
          }
        });
      });
    } catch (error) {
      // print("RefreshErr: ${error.toString()}");
      _recPagingController.error = error;
    }
  }

  Future<void> _fetchInterestedFundsPage(int pageKey) async {
    try {
      final invHomePvdr =
          Provider.of<investorProvider.InvestorHome>(context, listen: false);
      invHomePvdr
          .fetchAndSetInterestedFunds(UserData.instance.userInfo.token,
              (pageKey ~/ _fundsPageSize), _fundsPageSize)
          .then((_) {
        final list = invHomePvdr.interestedFundsData;
        print('FList: ${list.length}');
        setState(() {
          final isLastPage = list.length < _fundsPageSize;
          if (isLastPage) {
            _intFundsPagingController.appendLastPage(list);
          } else {
            final nextPageKey = pageKey + list.length;
            _intFundsPagingController.appendPage(list, nextPageKey);
          }
        });
      });
    } catch (error) {
      //print("RefreshErr: ${error.toString()}");
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
        // if (totalItems == 0) {
        //   displayRecommendations(false);
        // } else {
        //   displayRecommendations(true);
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: Builder(
            builder: (context) => SingleChildScrollView(
              child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        recommendationsUI(context),

                        //FUNDS
                        Visibility(
                          visible: isFundsPresent,
                          child: fundsUI(),
                        ),

                        // Visibility(
                        //     visible:
                        //         !isFundsPresent && !isRecommendationPresent,
                        //     child: EmptyListIndicator())
                      ])),
            ),
          ),
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
                color: Theme.of(context).primaryColor,
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) =>
                Center(child: Text("No items added to this list yet.")),
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
  Container recommendationsUI(BuildContext buildContext) {
    return Container(
        child: Column(
      children: [
        _createRecommendationHeader(),
        SizedBox(
          height: 10.0,
        ),
        Container(
          child: Column(
            children: <Widget>[
              Container(
                //color: Colors.orange,
                height: 300.0,
                child: setRecommendations(buildContext),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: Text(
                  "Swipe Left to Reject and Right to Accept",
                  style: textBold14(selectedOrange),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

  Widget setRecommendations(BuildContext _context) {
    return Stack(children: [
      RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _recPagingController.refresh(),
        ),
        color: Colors.orange,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: PagedListView<int, investorProvider.FundsInfo>.separated(
            pagingController: _recPagingController,
            // scrollDirection: Axis.vertical,
            builderDelegate:
                PagedChildBuilderDelegate<investorProvider.FundsInfo>(
              animateTransitions: true,
              transitionDuration: const Duration(milliseconds: 800),
              firstPageProgressIndicatorBuilder: (ctx) => Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              firstPageErrorIndicatorBuilder: (ctx) => ErrorIndicator(
                error: _recPagingController.error,
                onTryAgain: () => _recPagingController.refresh(),
              ),
              noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
              itemBuilder: (context, item, index) => Container(
                height: 300,
                width: (MediaQuery.of(context).size.width - 40),
                child: AnimatedContainer(
                  curve: Curves.decelerate,
                  // vsync: this,
                  duration: const Duration(seconds: 1),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 80,
                              width: 200,
                              child: Image.asset(
                                'assets/images/app_logo.png',
                              ),
                            ),
                            Text(
                              "Recommended Funds",
                              style: textBold16(headingBlack),
                            )
                          ],
                        ),
                      ),
                      _tinderCard(_context, index, item),
                    ],
                  ),
                ),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(
              color: Colors.transparent,
            ),
            shrinkWrap: true,
          ),
        ),
      ),
    ]);
  }

  Widget _tinderCard(BuildContext _context, int arrIndex,
      investorProvider.FundsInfo recommended) {
    CardController controller;
    return TinderSwapCard(
      swipeUp: false,
      swipeDown: false,
      orientation: AmassOrientation.RIGHT,
      totalNum: 1,
      stackNum: 3,
      swipeEdge: 4.0,
      maxWidth: MediaQuery.of(_context).size.width - 40,
      maxHeight: 280,
      minWidth: MediaQuery.of(_context).size.width - 60,
      minHeight: 200,
      allowVerticalMovement: false,
      cardBuilder: (ctx, idx) =>
          _buildRecommendationList(_context, arrIndex, recommended),
      cardController: controller = CardController(),
      swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
        /// Get swiping card's alignment
        if (align.x < 0) {
          // print(
          //     "Card is LEFT swiping:- $arrIndex, List index: ${recommended.fundTxnId}");
        } else if (align.x > 0) {
          // print("Card is RIGHT swiping");
        }
      },
      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
        currentItemIndex = arrIndex;
        currentItem = _recPagingController.itemList.elementAt(currentItemIndex);
        if (orientation == CardSwipeOrientation.LEFT ||
            orientation == CardSwipeOrientation.RIGHT) {
          setState(() {
            _recPagingController.itemList.removeAt(arrIndex);

            progress = ProgressHUD.of(_context);
            progress?.showWithText('Updating your preference...');
          });
          switch (orientation) {
            case CardSwipeOrientation.LEFT:
              respondRecommendation(recommended.fundTxnId, 0); // reject
              break;
            case CardSwipeOrientation.RIGHT:
              respondRecommendation(recommended.fundTxnId, 1); // accept
              break;
            default:
          }
        }
      },
    );
  }

  Widget _buildRecommendationList(
      BuildContext context, int index, investorProvider.FundsInfo recommended) {
    return GestureDetector(
        onTap: () => {
              //print("Name:- ${recommended.fundName}"),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                          data: recommended, token: UserData.instance.token)))
            },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10.0)),
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
                        //fit: BoxFit.cover,
                        // placeholder: (context, url) =>
                        //     CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
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

  Future<void> respondRecommendation(int fundTxnId, int selection) async {
    Future.delayed(Duration(seconds: 1), () async {
      RespondRecommendation respondRecommendation =
          await InvestorHomeService.acceptRejectRecommendation(
              fundTxnId, selection, UserData.instance.userInfo.token);
      progress.dismiss();
      showSnackBar(context, respondRecommendation.message);
      if (respondRecommendation.type == 'success') {
        _recPagingController.refresh();

        // if empty
        getFundsListSize();
        _intFundsPagingController.refresh();
      } else {
        // re-insert if error occurs
        _recPagingController.itemList.insert(currentItemIndex, currentItem);
      }
    });
  }
  // ------------------------------- end of recommendations -------------------------- //
}
