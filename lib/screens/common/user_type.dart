import 'package:acc/models/country/country.dart';
import 'package:acc/services/country_service.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/screens/common/authentication/signup_otp.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/models/local_countries.dart' as localCountry;

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  bool pressAttention = true;
  bool fundRaiserClick = true;
  List<localCountry.Countries> countryList = [];

  @override
  void initState() {
    super.initState();
    getAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Color(0xffffffff),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          size: 30, color: backButtonColor),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Material(
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              margin: const EdgeInsets.only(left: 25.0),
                              child: Text(
                                "I am".toUpperCase(),
                                style:
                                    textBold(Theme.of(context).accentColor, 30),
                              ),
                            ),
                            // Container(
                            //   margin:
                            //       const EdgeInsets.only(top: 5.0, left: 25.0),
                            //   child: Text(
                            //     "Please choose your appropiate type",
                            //     style: textNormal(textGrey, 16.0),
                            //   ),
                            // ),
                            Center(
                              child: header(),
                            )
                          ])),
                ],
              ),
            ))));
  }

  List<String> selectedCategory = [];
  String investor = 'investor';
  String fundraiser = 'fundraiser';

  Widget header() {
    return Column(children: [
      // INVESTOR
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          selectedCategory = [];
          selectedCategory.add(investor);
          setState(() {
            openSignUp("Investor");
          });
        },
        child: Container(
            margin: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            // width: 160,
            // height: 160,
            child: selectedCategory.contains(investor)
                ? Image.asset(
                    "assets/images/user_type/acc_investor_selected.png",
                  )
                : Image.asset(
                    "assets/images/user_type/acc_investor.png",
                  )),
      ),

      SizedBox(
        height: 10.0,
      ),

      // FUND RAISER
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          selectedCategory = [];
          selectedCategory.add(fundraiser);
          setState(() {
            openSignUp("Fundraiser");
          });
        },
        child: Container(
            margin: const EdgeInsets.only(top: 10.0, left: 35.0, right: 35.0),
            // width: 160,
            // height: 160,
            child: selectedCategory.contains(fundraiser)
                ? Image.asset(
                    "assets/images/user_type/acc_fundraiser_selected.png",
                  )
                : Image.asset(
                    "assets/images/user_type/acc_fundraiser.png",
                  )),
      ),
    ]);
  }

  void openSignUp(String userType) {
    print(countryList.length);
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SignUpOTP(userType: userType, countryList: countryList);
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

  Future<void> getAllCountries() async {
    final Country extractedData = await CountryService.fetchCountries();
    if (extractedData.type == "success") {
      if (extractedData.data.options.length != 0) {
        countryList.clear();
        for (int i = 0; i < extractedData.data.options.length; i++) {
          var value = extractedData.data.options[i];
          countryList.add(localCountry.Countries(
              value.countryName,
              value.countryAbbr,
              int.parse(
                  value.countryPhCode.replaceAll(new RegExp(r'[^0-9]'), '')),
              value.maxLength));
        }
      }
    }
  }
}
