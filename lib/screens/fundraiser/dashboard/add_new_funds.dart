import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/screens/fundraiser/dashboard/create_new_funds.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:acc/providers/product_type_provider.dart' as productProvider;

class AddNewFunds extends StatefulWidget {
  static var placementFee;

  @override
  _AddNewFundsState createState() => _AddNewFundsState();
}

class _AddNewFundsState extends State<AddNewFunds> {
  var _isInit = true;
  Future _futureFundSlots;

  Future<void> _getAllProducts(BuildContext context) async {
    await Provider.of<productProvider.ProductTypes>(context, listen: false)
        .fetchAndSetProductTypes();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _futureFundSlots = _getAllProducts(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  int selectedIndex;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
              Container(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 30),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                  child: Text("Choose your Product",
                      style: textBold(headingBlack, 20.0)),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                  child: Text(
                      "Select the products you want to raise funds for.",
                      style: textNormal(textGrey, 17.0)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0),
                    child: FutureBuilder(
                        future: _futureFundSlots,
                        builder: (ctx, dataSnapshot) {
                          if (dataSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          } else {
                            if (dataSnapshot.error != null) {
                              return Center(child: Text("An error occurred!"));
                            } else {
                              return Consumer<productProvider.ProductTypes>(
                                  builder: (ctx, fundData, child) =>
                                      ListView.builder(
                                        itemBuilder: (ctx, index) {
                                          return _createCell(
                                              fundData.types[index], index);
                                        },
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: fundData.types.length,
                                        shrinkWrap: true,
                                      ));
                            }
                          }
                        }))
              ])
            ]))));
  }

  InkWell _createCell(productProvider.InvestmentLimitItem item, int index) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        setState(() {
          selectedIndex = index;
          AddNewFunds.placementFee = item.placementFee;
          final requestModelInstance = AddFundRequestModel.instance;
          requestModelInstance.productId = item.id;
          openCreateNewFunds();
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        height: 50,
        decoration: BoxDecoration(
          color: selectedIndex == index ? selectedOrange : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
            child: Text(item.name,
                textAlign: TextAlign.start,
                style: textNormal(
                    selectedIndex == index ? Colors.white : Colors.black, 17))),
      ),
    );
  }

  void openCreateNewFunds() {
    Navigator.of(context, rootNavigator: true).push(
      new CupertinoPageRoute<bool>(
        fullscreenDialog: true,
        builder: (BuildContext context) => new CreateNewFunds(),
      ),
    );
  }
}
