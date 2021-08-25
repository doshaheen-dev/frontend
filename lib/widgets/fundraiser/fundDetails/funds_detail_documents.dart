import 'dart:io';

import 'package:acc/models/fund/fund_documents.dart';
import 'package:acc/providers/fund_provider.dart';
import 'package:acc/screens/common/inapp_webview.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/screens/investor/dashboard/pdf_viewer.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FundsUploadedDocument extends StatefulWidget {
  final SubmittedFunds likedFunds;

  FundsUploadedDocument(
    this.likedFunds,
  );

  @override
  _FundsUploadedDocumentState createState() => _FundsUploadedDocumentState();
}

class _FundsUploadedDocumentState extends State<FundsUploadedDocument> {
  bool _isFundDcoumentVisible = false;
  var _selectedTextColor = Colors.black;
  var _changeBgColor = unselectedGray;
  var _isInit = true;
  Future _fundDocumentList;
  List<DocumentsData> documentList;
  String _pefFilePath = "";

  Future<void> getAllDocuments(BuildContext context) async {
    final provider = Provider.of<FundProvider>(context, listen: false);
    provider.getFundsDocument(widget.likedFunds.fundTxnId).then((_) {
      documentList = provider.documentsData;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fundDocumentList = getAllDocuments(context);
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  _displayFundsDocument() {
    if (_isFundDcoumentVisible == true) {
      setState(() {
        _isFundDcoumentVisible = false;
        _changeBgColor = unselectedGray;
        _selectedTextColor = Colors.black;
      });
    } else {
      setState(() {
        if (documentList.isEmpty) {
          showSnackBar(context, "No documents uploaded yet.");
          return;
        }
        _isFundDcoumentVisible = true;
        _changeBgColor = kDarkOrange;
        _selectedTextColor = Colors.white;
      });
    }
  }

//   _createPath(String url) {
//  createFileOfPdfUrl(url).then((file) {
//       setState(() {
//         _pefFilePath = file.path;
//         print(_pefFilePath);
//       });
//     });
//   }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        color: _changeBgColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Documents Uploaded",
                      textAlign: TextAlign.start,
                      style: textBold16(_selectedTextColor))),
              Spacer(),
              IconButton(
                  onPressed: () {
                    _displayFundsDocument();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    "assets/images/icon_down.png",
                    color: _selectedTextColor,
                  ))
            ],
          ),
        ),
      ),
      Visibility(
        visible: _isFundDcoumentVisible,
        child: Card(
          color: unselectedGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: FutureBuilder(
            future: _fundDocumentList,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("An error occurred!"));
              } else {
                return Consumer<FundProvider>(
                    builder: (ctx, data, child) => MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: 20.0,
                                    left: 10.0,
                                    right: 10.0,
                                    top: 20.0),
                                child: _createDocumentCell(
                                    data.documentsData[index]),
                              );
                            },
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: data.documentsData.length,
                            shrinkWrap: true,
                          ),
                        ));
              }
            },
          ),
        ),
      )
    ]);
  }

  Widget _createDocumentCell(DocumentsData documentsData) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(
              documentsData.kycDocName,
              style: textNormal(headingBlack, 14),
            )),
        InkWell(
          onTap: () {
            openUrl(documentsData);
          },
          child: Text("View File", style: textNormal14(selectedOrange)),
        ),
      ],
    );
  }

  void openUrl(DocumentsData documentsData) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return InAppWebViewContainer(documentsData);
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

  // Future<File> createFileOfPdfUrl(String _url) async {
  //   final url = _url;
  //   final filename = url.substring(url.lastIndexOf("/") + 1);
  //   var request = await HttpClient().getUrl(Uri.parse(url));
  //   var response = await request.close();
  //   var bytes = await consolidateHttpClientResponseBytes(response);
  //   String dir = (await getApplicationDocumentsDirectory()).path;
  //   File file = new File('$dir/$filename');
  //   await file.writeAsBytes(bytes);
  //   return file;
  // }
}
