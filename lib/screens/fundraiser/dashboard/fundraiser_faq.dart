import 'package:acc/screens/common/webview_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FundraiserFaq extends StatefulWidget {
  @override
  _FundraiserFaqState createState() => _FundraiserFaqState();
}

class _FundraiserFaqState extends State<FundraiserFaq> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      child: WebViewContainer(""),
    );
  }
}
