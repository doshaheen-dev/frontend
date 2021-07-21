import 'package:acc/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'package:acc/screens/investor/investment_choices.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:provider/provider.dart';

// import '../../models/fundslot/fundslot.dart';
// import '../../services/fund_slot_service.dart';
import '../../providers/fund_slot_provider.dart' as slotProvider;
import 'package:acc/models/authentication/signup_request.dart';

class InvestmentLimit extends StatefulWidget {
  @override
  _InvestmentLimitState createState() => _InvestmentLimitState();
}

class _InvestmentLimitState extends State<InvestmentLimit> {
  var _isInit = true;
  Future _fundSlots;

  Future<void> _fetchFundSlots(BuildContext context) async {
    await Provider.of<slotProvider.FundSlots>(context, listen: false)
        .fetchAndSetSlots();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _fundSlots = _fetchFundSlots(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget fundSlotWidget() {
    return SafeArea(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                  child: Text(
                    "How much are you looking to invest?",
                    style: TextStyle(
                        color: headingBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                        fontFamily: FontFamilyMontserrat.name),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0),
                    child: Image.asset(
                      'assets/images/investor/investment_limit.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin:
                      const EdgeInsets.only(top: 30.0, left: 25.0, right: 25.0),
                  child: FutureBuilder(
                    future: _fundSlots,
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.orange,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.amber),
                        ));
                      } else {
                        if (dataSnapshot.error != null) {
                          return Center(child: Text("An error occurred!"));
                        } else {
                          return Consumer<slotProvider.FundSlots>(
                            builder: (ctx, slotData, child) => GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 30.0,
                              shrinkWrap: true,
                              childAspectRatio:
                                  (MediaQuery.of(context).size.width / 2 / 65),
                              children: List.generate(
                                slotData.slotLineItems.length,
                                (index) {
                                  return _createCell(
                                      slotData.slotLineItems[index]);
                                },
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Color(0xffffffff),
      ),
      bottomNavigationBar: BottomAppBar(),
      backgroundColor: Colors.white,
      body: fundSlotWidget(),
    );
  }

  List<String> infoItemList = [];

  InkWell _createCell(slotProvider.InvestmentLimitItem item) {
    return InkWell(
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        print(item.header);
        infoItemList = [];
        infoItemList.add(item.header);
        final requestModelInstance = InvestorSignupRequestModel.instance;
        requestModelInstance.slotId = '${item.id}';
        setState(() {
          openInvestmentChoices();
        });
      },
      child: Container(
        width: 10,
        height: 70,
        decoration: BoxDecoration(
          color: infoItemList.contains(item.header)
              ? selectedOrange
              : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
            child: Text(item.header,
                style: TextStyle(
                    color: infoItemList.contains(item.header)
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0,
                    fontFamily: FontFamilyMontserrat.name))),
      ),
    );
  }

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 10, fontWeight: FontWeight.w500);
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[200],
        )
      ],
    );
  }

  void openInvestmentChoices() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return InvestmentChoices();
        },
        transitionDuration: Duration(milliseconds: 2000),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn, parent: animation);
          return SlideTransition(
            position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation),
            child: child,
          );
        }));
  }
}
