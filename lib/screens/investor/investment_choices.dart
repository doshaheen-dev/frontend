import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/investor/general_terms_privacy.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/ui_widgets.dart';

class InvestmentChoices extends StatefulWidget {
  @override
  _InvestmentChoicesState createState() => _InvestmentChoicesState();
}

class _InvestmentChoicesState extends State<InvestmentChoices> {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0),
                    child: Text(
                      "Please click on your Investment Choice(s)",
                      style: TextStyle(
                          color: headingBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 28.0,
                          fontFamily: 'Poppins-Light'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      itemCount: infoItem.length,
                      shrinkWrap: true,
                      itemBuilder: _createCell),

                  SizedBox(
                    height: 20,
                  ),

                  //NEXT BUTTON
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        // on click
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GeneralTermsPrivacy()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: appColorButton(),
                        child: Center(
                            child: Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> infoItemList = [];
  List<InvestmentLimitItem> infoItem = [
    InvestmentLimitItem('Angel Funds',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.'),
    InvestmentLimitItem('Venture Capital',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.'),
    InvestmentLimitItem('Listed Equities',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.'),
    InvestmentLimitItem('Fixed Income',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.'),
    InvestmentLimitItem('Structured Products',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.'),
    InvestmentLimitItem('CryptoCurrencies',
        'Angel funds invest in very early-stage businesses providing capital for start up or expansion.'),
  ];

  Widget _createCell(BuildContext context, int _index) {
    return Card(
        color: infoItemList.contains(infoItem[_index].header)
            ? selectedOrange
            : unselectedGray,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin:
            EdgeInsets.only(right: 25.0, top: 10.0, bottom: 10.0, left: 25.0),
        child: InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            print(infoItem[_index].header);
            infoItemList = [];
            infoItemList.add(infoItem[_index].header);
            setState(() {});
          },
          child: Container(
            height: 50,
            child: Row(
              children: [
                Spacer(flex: 3),
                Center(
                    child: Text(infoItem[_index].header,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                infoItemList.contains(infoItem[_index].header)
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            fontFamily: 'Poppins-Light'))),
                new Spacer(
                  flex: 3,
                ), // I just added one line
                InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.navigate_next,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  TextStyle setTextStyle(colors) {
    return TextStyle(color: colors, fontSize: 14, fontWeight: FontWeight.w500);
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
}

class InvestmentLimitItem {
  final String header;
  final String description;

  InvestmentLimitItem(this.header, this.description);
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
