import 'dart:io';

import 'package:acc/utilites/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();
  bool isPageLoaded = true;

  _WebViewContainerState(this._url);

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0.0,
          backgroundColor: (Color(0xffffffff)),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        size: 30, color: backButtonColor),
                    onPressed: () => {Navigator.pop(context)},
                  ),
                ],
              )),
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
                  initialUrl: _url,
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
        ]));
  }
}
