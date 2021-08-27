import 'dart:async';
import 'dart:convert';

import 'package:acc/constants/font_family.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/refresh_token.dart';
import 'package:acc/providers/fund_provider.dart';
import 'package:acc/providers/fund_slot_provider.dart';
import 'package:acc/providers/investor_home_provider.dart';
import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/providers/product_type_provider.dart';
import 'package:acc/providers/country_provider.dart';
import 'package:acc/providers/city_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_dashboard.dart';
import 'package:acc/screens/investor/dashboard/investor_dashboard.dart';
import 'package:acc/services/TokenRefreshService.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utils/class_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/services/AuthenticationService.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarColor: HexColor("#114069")));

    return MultiProvider(
      providers: [
        Provider<Authentication>(
          create: (_) => Authentication(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<Authentication>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => FundSlots(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProductTypes(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Countries(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cities(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InvestorHome(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => KYCDocuments(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FundProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kLightOrange,
          accentColor: kDarkOrange,
          fontFamily: FontFamilyMontserrat.name,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    getUserInfo();

    // Timer(
    //     Duration(seconds: 3),
    //     () => Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => OnBoarding())));
  }

  // Get store data and redirect to view.
  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap;
    final String userStr = prefs.getString('UserInfo');
    if (userStr != null && userStr != "") {
      userMap = jsonDecode(userStr) as Map<String, dynamic>;
      UserData userData = UserData.fromNoDecryptionMap(userMap);
      UserData.instance.userInfo = userData;
      print("Token: ${UserData.instance.userInfo.token}");

      if (userData != null) {
        AppToken token = await TokenRefreshService.refreshToken();
        if (token.status != 200) {
          _openDialog(
              context, "Your session has expired. Please Sign In again.");
          return;
        }
        openHome(userData);
      } else {
        Timer(
            Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => OnBoarding())));
      }
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OnBoarding())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#114069"),
      body: Center(
        child: Image.asset(
          'assets/images/company_logo/app_logo_vertical.png',
          height: 350.0,
          width: 200.0,
        ),
      ),
    );
  }

  void openHome(UserData data) {
    if (data.userType == "Investor" ||
        data.userType == "investor" ||
        data.userType == "") {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: (context, animation, anotherAnimation) {
                return InvestorDashboard(
                  userData: data,
                );
              },
              transitionDuration: Duration(milliseconds: 2000),
              transitionsBuilder:
                  (context, animation, anotherAnimation, child) {
                animation = CurvedAnimation(
                    curve: Curves.fastLinearToSlowEaseIn, parent: animation);
                return SlideTransition(
                  position:
                      Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                  child: child,
                );
              }),
          (Route<dynamic> route) => false);
    } else if (data.userType == "Fundraiser" || data.userType == "fundraiser") {
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: (context, animation, anotherAnimation) {
                return FundraiserDashboard();
              },
              transitionDuration: Duration(milliseconds: 2000),
              transitionsBuilder:
                  (context, animation, anotherAnimation, child) {
                animation = CurvedAnimation(
                    curve: Curves.fastLinearToSlowEaseIn, parent: animation);
                return SlideTransition(
                  position:
                      Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                  child: child,
                );
              }),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnBoarding()));
    }
  }

  _openDialog(BuildContext context, String message) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('UserInfo', '');
          Navigation.openOnBoarding(context);
        },
        child: Text(
          "Login",
          style: textNormal16(selectedOrange),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(message, style: textNormal18(headingBlack)),
      actions: [
        positiveButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
