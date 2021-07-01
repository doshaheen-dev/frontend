import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/investor/investment_choices.dart';
import 'package:portfolio_management/utilites/app_colors.dart';

class InvestmentLimit extends StatefulWidget {
  @override
  _InvestmentLimitState createState() => _InvestmentLimitState();
}

class _InvestmentLimitState extends State<InvestmentLimit> {
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
                      "How much are you looking to invest?",
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
                    margin: const EdgeInsets.only(
                        top: 30.0, left: 25.0, right: 25.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 30.0,
                        shrinkWrap: true,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / 2 / 65),
                        children: List.generate(infoItem.length, (index) {
                          return _createCell(index);
                        })),
                  ),
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
    InvestmentLimitItem('50k\$ - 100K\$'),
    InvestmentLimitItem('100K\$-200K\$'),
    InvestmentLimitItem('200k\$ - 300K\$'),
    InvestmentLimitItem('300k\$ - 400K\$'),
    InvestmentLimitItem('400k\$ - 500K\$'),
    InvestmentLimitItem('Above 500K\$'),
  ];

  InkWell _createCell(int _index) {
    return InkWell(
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        print(infoItem[_index].header);
        infoItemList = [];
        infoItemList.add(infoItem[_index].header);
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => InvestmentChoices()));
        });
      },
      child: Container(
        width: 10,
        height: 70,
        decoration: BoxDecoration(
          color: infoItemList.contains(infoItem[_index].header)
              ? selectedOrange
              : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
            child: Text(infoItem[_index].header,
                style: TextStyle(
                    color: infoItemList.contains(infoItem[_index].header)
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0,
                    fontFamily: 'Poppins-Light'))),
      ),
    );
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

  InvestmentLimitItem(this.header);
}
