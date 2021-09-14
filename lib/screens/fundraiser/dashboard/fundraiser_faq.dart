import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FundraiserFaq extends StatefulWidget {
  @override
  _FundraiserFaqState createState() => _FundraiserFaqState();
}

class _FundraiserFaqState extends State<FundraiserFaq> {
  bool isPageLoaded = false;
  WebViewController _webViewController;

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
          body: Builder(builder: (BuildContext context) {
            return new Stack(
              children: <Widget>[
                new WebView(
                  initialUrl:
                      'http://ami-corp-admin-portal.s3-website.ap-south-1.amazonaws.com/onboarding/faq/fundraiser',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onPageFinished: (url) {
                    _webViewController.evaluateJavascript("javascript:(function() { " +
                        "var head = document.getElementsByClassName('mat-toolbar mat-white mat-toolbar-single-row')[0].style.display='none'; " +
                        "var foot = document.getElementsByClassName('mat-toolbar sectionfooter mat-toolbar-single-row')[0].style.display='none'; "
                            "})()");
                    setState(() {
                      isPageLoaded = true;
                    });
                  },
                ),
                isPageLoaded == false
                    ? new Center(
                        child: new CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : new Container(),
              ],
            );
          }),
        ));
  }
}
