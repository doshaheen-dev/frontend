import 'package:acc/providers/fund_slot_provider.dart';
import 'package:acc/providers/product_type_provider.dart';
import 'package:acc/screens/investor/investment_limit.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:acc/screens/common/onboarding.dart';
import 'package:acc/services/AuthenticationService.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kLightOrange,
          accentColor: kDarkOrange,
          fontFamily: 'Poppins-Regular',
        ),
        home: StartPage(),
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final firebaseUser = context.watch<User>();
    // if (firebaseUser != null) {
    //   return Home();
    // }
    // return InvestmentLimit();
    return OnBoarding();
  }
}
