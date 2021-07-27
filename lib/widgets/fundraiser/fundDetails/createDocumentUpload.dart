import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/document_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDocumentUpload extends StatefulWidget {
  final SubmittedFunds likedFunds;

  CreateDocumentUpload(
    this.likedFunds,
  );

  @override
  _CreateDocumentUploadState createState() => _CreateDocumentUploadState();
}

class _CreateDocumentUploadState extends State<CreateDocumentUpload> {
  bool _isFundOverview = false;
  var _selectedTextColor = Colors.black;
  var _changeBgColor = unselectedGray;

  _displayFundOverview() {
    if (_isFundOverview == true) {
      setState(() {
        _isFundOverview = false;
        _changeBgColor = unselectedGray;
        _selectedTextColor = Colors.black;
      });
    } else {
      setState(() {
        _isFundOverview = true;
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
                  child: Text("Fund Overview",
                      textAlign: TextAlign.start,
                      style: textBold16(_selectedTextColor))),
              Spacer(),
              IconButton(
                  onPressed: () {
                    _displayFundOverview();
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
          visible: _isFundOverview,
          child: Container(
              child: Card(
            color: unselectedGray,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Regulated")),
                          Expanded(
                              flex: 1,
                              child: Text(widget.likedFunds.fundRegulated == 1
                                  ? "Yes"
                                  : "No"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Regulator")),
                          Expanded(
                              flex: 1,
                              child: Text(widget.likedFunds.fundRegulatorName))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Website Link")),
                          Expanded(
                              flex: 1,
                              child: Text(widget.likedFunds.fundWebsite))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Sponsor")),
                          Expanded(
                              flex: 1,
                              child: Text(widget.likedFunds.fundSponsorName))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Existing Fund")),
                          Expanded(
                              flex: 1,
                              child:
                                  Text("\$${widget.likedFunds.fundExistVal}K"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("New Fund")),
                          Expanded(
                              flex: 1,
                              child: Text("\$${widget.likedFunds.fundNewVal}K"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Product Type")),
                          Expanded(flex: 1, child: Text("Angel Investment"))
                        ],
                      )
                    ]))),
          )))
    ]);
    ;
  }
}
