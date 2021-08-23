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

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 30),
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    child: WebView(
                        key: _key,
                        userAgent: "random",
                        javascriptMode: JavascriptMode.unrestricted,
                        initialUrl: _url)))
          ],
        ));
  }
}
