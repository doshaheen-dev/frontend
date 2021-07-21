import 'package:acc/screens/fundraiser/dashboard/create_new_funds.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/investor/general_terms_privacy.dart';
import 'package:acc/utilites/app_colors.dart';

class AddNewFunds extends StatefulWidget {
  @override
  _AddNewFundsState createState() => _AddNewFundsState();
}

class _AddNewFundsState extends State<AddNewFunds> {
  List<LikedFunds> fundsList = <LikedFunds>[
    const LikedFunds("Angel Investment"),
    const LikedFunds("Venture Capital"),
    const LikedFunds("Private Equity"),
    const LikedFunds("Listed Equities"),
    const LikedFunds("Fixed Income"),
    const LikedFunds("Structured Products"),
    const LikedFunds("Digital Crypto Products"),
  ];

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0),
                    child: Text("Choose your Product",
                        style: textBold(headingBlack, 20.0)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, left: 25.0, right: 25.0),
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
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return _createCell(fundsList[index], index);
                      },
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: fundsList.length,
                      shrinkWrap: true,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _createCell(LikedFunds item, int index) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        setState(() {
          selectedIndex = index;
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

  void openGeneralTermsPrivacy() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return GeneralTermsPrivacy();
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

class LikedFunds {
  const LikedFunds(this.name);
  final String name;
}
