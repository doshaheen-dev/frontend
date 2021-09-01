import 'package:acc/providers/fund_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/add_new_funds.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_fund_detail.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/app_strings.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FundraiserHome extends StatefulWidget {
  FundraiserHome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FundraiserHomeState();
}

bool _fundsAvailable = true;

class _FundraiserHomeState extends State<FundraiserHome> {
  List<SubmittedFunds> fundsList = [];
  static const fundPageSize = 10;
  var pageNo = 0;
  final PagingController<int, SubmittedFunds> _pagingController =
      PagingController(firstPageKey: 0);

  Future<void> _fetchPage(int pageKey) async {
    try {
      // print('Page: $pageKey');
      final fundPvdr = Provider.of<FundProvider>(context, listen: false);
      fundPvdr.fetchAndSetFunds(pageNo, fundPageSize).then((result) {
        final funds = fundPvdr.funds;
        // print('Funds: ${funds.length}');
        fundsList.addAll(funds);
        // print('FundsList: ${fundsList.length}');
        setState(() {
          if (funds.isEmpty) {
            _fundsAvailable = false;
          } else {
            _fundsAvailable = true;
          }

          final isLastPage = funds.length < fundPageSize;
          if (isLastPage) {
            _pagingController.appendLastPage(funds);
            _fundsAvailable = true;
          } else {
            final nextPageKey = pageKey + funds.length;
            pageNo++;
            _pagingController.appendPage(funds, nextPageKey);
          }
        });
      });
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          margin: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: _createHeader(),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Scrollbar(isAlwaysShown: true, child: addFundsView(context)),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        child: Visibility(
          visible: _fundsAvailable,
          child: FloatingActionButton.extended(
            onPressed: () {
              openAddNewFunds();
            },
            label: const Text('Add Funds'),
            icon: const Icon(Icons.add),
            backgroundColor: kDarkOrange,
          ),
        ),
      ),
    );
  }

  Widget addFundsView(BuildContext context) {
    return Stack(
      children: [
        Visibility(visible: !_fundsAvailable, child: addNewFundsCell(context)),
        Visibility(
            visible: _fundsAvailable,
            child: RefreshIndicator(
                onRefresh: () => Future.sync(() => {
                      // pageNo = 0,
                      _pagingController.refresh()
                    }),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: PagedListView<int, SubmittedFunds>.separated(
                    //    physics: NeverScrollableScrollPhysics(),
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<SubmittedFunds>(
                      animateTransitions: true,
                      itemBuilder: (context, item, index) =>
                          _createCell(item, index),
                    ),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.transparent,
                    ),
                    shrinkWrap: true,
                  ),
                )))
      ],
    );
  }

  Widget _createCell(SubmittedFunds item, int index) {
    MaterialColor iconColor;
    if (item.type == "Approve") {
      iconColor = Colors.green;
    } else if (item.type == "UnderScrutiny") {
      iconColor = Colors.blue;
    } else if (item.type == "Reject") {
      iconColor = Colors.red;
    }

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 8.0,
          left: 25.0,
          right: 25.0,
        ),
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
                        onTap: () {
                          print(_pagingController.itemList[index].name);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundraiserFundDetail(
                                      data: _pagingController.itemList[index],
                                      isResubmission: false)));
                        },
                        child: Text(
                          "Show Details",
                          style: textNormal12(HexColor("#468FFD")),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      if (item.type == "Reject")
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FundraiserFundDetail(
                                        data: _pagingController.itemList[index],
                                        isResubmission: true)));
                          },
                          child: Text(
                            "Resubmit",
                            style: textNormal12(HexColor("#FB724C")),
                          ),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: Text(
                          DateUtilsExt.dateFromUTCToLocal(item.date),
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

  Widget _createHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Select the products you want to raise funds for.",
            style: textNormal(textGrey, 17.0)),
        SizedBox(
          height: 30,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(

              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(Icons.circle, color: Colors.green, size: 15.0),
                SizedBox(
                  width: 5,
                ),
                Text("Listed", style: textNormal14(HexColor("#2B2B2B")))
              ]),
          // SizedBox(
          //   width: 10,
          // ),
          Row(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(Icons.circle, color: Colors.blue, size: 15.0),
                SizedBox(
                  width: 5,
                ),
                Text("Under Scrutiny", style: textNormal14(HexColor("#2B2B2B")))
              ]),

          Row(
            children: <Widget>[
              Icon(
                Icons.circle,
                color: Colors.red,
                size: 15.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text("Not Listed", style: textNormal14(HexColor("#2B2B2B")))
            ],
          ),
        ]),
      ],
    );
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
  final int fundTxnId;
  final int userId;
  final int productId;
  final int slotId;
  final String fundSponsorName;
  final String name;
  final String fundCountryName;
  final String fundCityName;
  final int fundRegulated;
  final String fundRegulatorName;
  final String fundInvstmtObj;
  final int fundExistVal;
  final int fundNewVal;
  final String fundWebsite;
  final String fundLogo;
  final String type;
  final String date;
  final String minimumInvestment;
  final String fundsRemarks;

  const SubmittedFunds(
      this.fundTxnId,
      this.userId,
      this.productId,
      this.slotId,
      this.fundSponsorName,
      this.name,
      this.fundCountryName,
      this.fundCityName,
      this.fundRegulated,
      this.fundRegulatorName,
      this.fundInvstmtObj,
      this.fundExistVal,
      this.fundNewVal,
      this.fundWebsite,
      this.fundLogo,
      this.type,
      this.date,
      this.minimumInvestment,
      this.fundsRemarks);
}
