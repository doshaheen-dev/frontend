import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class FundsResubmitHeader extends StatefulWidget {
  @override
  _FundsResubmitHeaderState createState() => _FundsResubmitHeaderState();
}

class _FundsResubmitHeaderState extends State<FundsResubmitHeader> {
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: Builder(
            builder: (context) => Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => {Navigator.pop(context)},
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: 10.0, left: 25.0, right: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              'Hello Fundraiser',
                              style: textBold26(headingBlack),
                            )),
                            Image.asset(
                                'assets/images/investor/icon_investor.png'),
                          ],
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        "Review and Resubmit your Fund",
                        style: textBold18(headingBlack),
                      ),
                    )
                  ],
                )))));
  }
}
