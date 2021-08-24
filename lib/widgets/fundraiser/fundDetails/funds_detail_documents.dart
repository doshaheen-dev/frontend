import 'package:acc/models/fund/fund_documents.dart';
import 'package:acc/providers/fund_provider.dart';
import 'package:acc/screens/common/webview_container.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/http_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
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

  Future<void> getAllDocuments(BuildContext context) async {
    Provider.of<FundProvider>(context, listen: false)
        .getFundsDocument(widget.likedFunds.fundTxnId);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _fundDocumentList = getAllDocuments(context);
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  List<String> litems = ["1", "2", "Third", "4"];

  _displayFundsDocument() {
    if (_isFundDcoumentVisible == true) {
      setState(() {
        _isFundDcoumentVisible = false;
        _changeBgColor = unselectedGray;
        _selectedTextColor = Colors.black;
      });
    } else {
      setState(() {
        _isFundDcoumentVisible = true;
        _changeBgColor = kDarkOrange;
        _selectedTextColor = Colors.white;
      });
    }
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
            String url = documentsData.fundKycDocPath;
            if (documentsData.fundKycDocPath.contains("ppt") ||
                documentsData.fundKycDocPath.contains("pdf")) {
              String googleLink = "https://docs.google.com/viewer?url=";
              String docUrl = documentsData.fundKycDocPath;
              url = googleLink + docUrl;
            } else {
              url = documentsData.fundKycDocPath.replaceAll(
                  "https://funddocuments.s3.ap-south-1.amazonaws.com/",
                  "${ApiServices.baseUrl}/download/fund/document/");
            }
            openUrl(url);
          },
          child: Text("View File", style: textNormal14(selectedOrange)),
        )
      ],
    );
  }

  void openUrl(String url) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return WebViewContainer(url);
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
