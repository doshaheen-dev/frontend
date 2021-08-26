import 'package:acc/models/fund/fund_documents.dart';
import 'package:acc/screens/common/webview_container.dart';
import 'package:acc/services/http_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppWebViewContainer extends StatefulWidget {
  final DocumentsData url;

  InAppWebViewContainer(this.url);

  @override
  createState() => _InAppWebViewContainerState();
}

class _InAppWebViewContainerState extends State<InAppWebViewContainer> {
  bool isPageLoaded = true;
  Future<void> _launched;
  bool launchUrl = false;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
          enableDomStorage: true);
    } else {
      showSnackBar(context, 'Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.url.fundKycDocPath.contains("pdf") ||
        widget.url.fundKycDocPath.contains("ppt")) {
      launchUrl = true;
    } else {
      launchUrl = false;
    }
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.arrow_back, size: 30),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ],
                )),
            Container(
                child: !launchUrl
                    ? Center(
                        child: Image.network(
                          widget.url.fundKycDocPath,
                          fit: BoxFit.fitHeight,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                                child: CircularProgressIndicator(
                              color: selectedOrange,
                            ));
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Some errors occurred!'),
                        ),
                      )
                    : Expanded(
                        child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.url.kycDocName,
                              style: textNormal18(headingBlack),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: () {
                                String url = widget.url.fundKycDocPath;

                                if (widget.url.fundKycDocPath.contains("ppt") ||
                                    widget.url.fundKycDocPath.contains("pdf")) {
                                  String googleLink =
                                      "https://docs.google.com/gview?embedded=true&url=";
                                  String docUrl = widget.url.fundKycDocPath;
                                  url = googleLink + docUrl;
                                } else {
                                  url = widget.url.fundKycDocPath.replaceAll(
                                      "https://funddocuments.s3.ap-south-1.amazonaws.com/",
                                      "${ApiServices.baseUrl}/download/fund/document/");
                                }
                                _launched = _launchInBrowser(url);
                              },
                              child: Text("Open File",
                                  style: textNormal16(Colors.blue)),
                            ),
                          ],
                        ),
                      ))),
            FutureBuilder<void>(future: _launched, builder: _launchStatus),
          ],
        ));
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  void openUrl(String documentsData) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return WebViewContainer(documentsData);
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
}
