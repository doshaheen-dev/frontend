import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FundraiserFaq extends StatefulWidget {
  @override
  _FundraiserFaqState createState() => _FundraiserFaqState();
}

class _FundraiserFaqState extends State<FundraiserFaq> {
  final _key = UniqueKey();
  bool isPageLoaded = true;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
            backgroundColor: Color(0xffffffff),
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0.0,
              backgroundColor: (Color(0xffffffff)),
            ),
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Stack(children: [
                Visibility(
                    visible: isPageLoaded,
                    child: Container(
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl:
                          "http://ami-corp-admin-portal.s3-website.ap-south-1.amazonaws.com/onboarding/fundraiser-faq",
                      onPageStarted: (value) {
                        setState(() {
                          isPageLoaded = true;
                        });
                      },
                      onPageFinished: (value) {
                        setState(() {
                          isPageLoaded = false;
                        });
                      },
                    ))
              ]))
            ])));
  }
}
