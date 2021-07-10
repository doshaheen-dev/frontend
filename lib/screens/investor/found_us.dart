import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio_management/screens/investor/investment_limit.dart';
import 'package:portfolio_management/utilites/app_colors.dart';
import 'package:portfolio_management/utilites/ui_widgets.dart';

class InvestorSearchInfo extends StatefulWidget {
  @override
  _InvestorSearchInfoState createState() => _InvestorSearchInfoState();
}

class _InvestorSearchInfoState extends State<InvestorSearchInfo> {
  @override
  Widget build(BuildContext context) {
    String firstname = "";
    final firstNameController = TextEditingController();

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
                      "How did you find us ?",
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
                  Container(
                    margin: const EdgeInsets.only(
                        top: 30.0, left: 25.0, right: 25.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        shrinkWrap: true,
                        children: List.generate(infoItem.length, (index) {
                          return _createCell(index);
                        })),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                    decoration: customDecoration(),
                    child: TextField(
                      style: _setTextFieldStyle(),
                      controller: firstNameController,
                      onChanged: (value) => {firstname = value},
                      decoration: _setTextFieldDecoration("Name of the person"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          top: 5.0, left: 25.0, bottom: 20, right: 25.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        onTap: () {
                          // on click
                          openInvestmentLimit();
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
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _setTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
        fontFamily: 'Poppins-Regular');
  }

  InputDecoration _setTextFieldDecoration(_text) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10.0),
      labelText: _text,
      labelStyle: new TextStyle(color: Colors.grey[600]),
      border: InputBorder.none,
      focusedBorder: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
        borderRadius: BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
    );
  }

  List<String> infoItemList = [];
  List<InfoItem> infoItem = [
    InfoItem("Internet Search", "assets/images/investor/internet_search.png"),
    InfoItem(
        "Internet Browsing", "assets/images/investor/internet_browsing.png"),
    InfoItem("Referral", "assets/images/investor/referral.png"),
    InfoItem("Social Media", "assets/images/investor/social_media.png"),
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
          // openInvestmentLimit();
        });
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: infoItemList.contains(infoItem[_index].header)
              ? selectedOrange
              : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(infoItem[_index].icon, width: 100.0, height: 100.0),
              SizedBox(
                height: 10.0,
              ),
              Text(infoItem[_index].header,
                  style: TextStyle(
                      color: infoItemList.contains(infoItem[_index].header)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      fontFamily: 'Poppins-Light'))
            ],
          ),
        ),
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

  void openInvestmentLimit() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return InvestmentLimit();
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

class InfoItem {
  final String header;
  final String icon;

  InfoItem(this.header, this.icon);
}
