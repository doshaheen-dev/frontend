import 'package:acc/screens/common/webview_container.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';

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
          child: Container(
              child: Card(
                  color: unselectedGray,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return _createDocumentCell();
                        },
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: litems.length,
                        shrinkWrap: true,
                      )))))
    ]);
  }

  Widget _createDocumentCell() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                "Document Name",
                style: textNormal(textGrey, 14),
              )),
          InkWell(
            onTap: () {
              openUrl(
                  "http://ec2-65-2-69-222.ap-south-1.compute.amazonaws.com:3000/api/download/fund/document/2d0eb779-e1da-4255-b531-ef5be446df08-Screenshot_20210810-183114.jpg#toolbar=0&navpanes=0&scrollbar=0");
            },
            child: Text("View File", style: textNormal14(selectedOrange)),
          )
        ],
      ),
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
