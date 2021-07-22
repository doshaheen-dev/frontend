import 'dart:async';

import 'package:acc/constants/font_family.dart';
import 'package:acc/providers/fund_slot_provider.dart';
import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/providers/product_type_provider.dart';
import 'package:acc/providers/country_provider.dart';
import 'package:acc/providers/city_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/add_new_funds.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/services/AuthenticationService.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
          create: (ctx) => KYCDocuments(),
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
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OnBoarding())));
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
}
