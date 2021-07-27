import 'dart:io';

import 'package:acc/models/upload/upload_document.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/upload_document_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class FundraiserFundDetail extends StatefulWidget {
  final SubmittedFunds _recommendation;
  final bool _fundDetailType;
  const FundraiserFundDetail(
      {Key key, SubmittedFunds data, bool isResubmission})
      : _recommendation = data,
        _fundDetailType = isResubmission,
        super(key: key);

  @override
  _FundraiserFundDetailState createState() => _FundraiserFundDetailState();
}

class _FundraiserFundDetailState extends State<FundraiserFundDetail> {
  final _newFundValueController = TextEditingController();
  var progress;
  List<DocumentInfo> _uploadedDocuments = [];
  SubmittedFunds _likedFunds;
  bool isResubmit = false;
  bool _isFundOverview = false;
  var _changeBgColor = unselectedGray;

  var _selectedTextColor = Colors.black;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    _likedFunds = widget._recommendation;
    isResubmit = widget._fundDetailType;
    disableElevatedButton();
    super.initState();
  }

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

  //  bool _isFundDeck = false;
  //  var _changeFundDeckBgColor = unselectedGray;
  // var _selectedFundDeckTextColor = Colors.black;
  // _displayFundDeck() {
  //   if (_isFundDeck == true) {
  //     setState(() {
  //       _isFundDeck = false;
  //       _changeFundDeckBgColor = unselectedGray;
  //       _selectedFundDeckTextColor = Colors.black;
  //     });
  //   } else {
  //     setState(() {
  //       _isFundDeck = true;
  //       _changeFundDeckBgColor = kDarkOrange;
  //       _selectedFundDeckTextColor = Colors.white;
  //     });
  //   }
  // }

  void _changeButtonStatus() {
    setState(() {
      _isButtonDisabled = true;
    });
  }

  disableElevatedButton() {
    setState(() {
      _isButtonDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 40.0, left: 15.0, right: 25.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Image.asset("assets/images/icon_close.png"),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                  ),
                  Image.asset(
                    _likedFunds.image,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: _createFundHeader(),
                  ),

                  Divider(color: HexColor("#E8E8E8")),
                  // Fund overview
                  Container(
                    child: _createFundBody(),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "\$15,000,000",
                                  style: textBlackNormal16(),
                                ),
                                Text("Target", style: textNormal16(kDarkOrange))
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "\$15,000,000",
                                  style: textBlackNormal16(),
                                ),
                                Text("Min Per Investor",
                                    style: textNormal16(kDarkOrange))
                              ],
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Visibility(
                    visible: isResubmit,
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 5.0, left: 5.0, bottom: 20, right: 5.0),
                        child: ElevatedButton(
                          onPressed:
                              !_isButtonDisabled ? null : _performSubmission,
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: !_isButtonDisabled
                                    ? LinearGradient(
                                        colors: [textLightGrey, textLightGrey])
                                    : LinearGradient(
                                        colors: [kDarkOrange, kLightOrange]),
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              alignment: Alignment.center,
                              child: Text("Submit", style: textWhiteBold16()),
                            ),
                          ),
                        )),
                  )
                ]),
          ),
        ));
  }

  Widget _createFundHeader() {
    MaterialColor iconColor;
    if (_likedFunds.type == "Listed") {
      iconColor = Colors.green;
    } else if (_likedFunds.type == "Under Scrutiny") {
      iconColor = Colors.blue;
    } else if (_likedFunds.type == "Not Listed") {
      iconColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _likedFunds.name,
          style: textBold18(headingBlack),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.circle,
              color: iconColor,
              size: 15.0,
            ),
            SizedBox(
              width: 5,
            ),
            Text(_likedFunds.type, style: textNormal16(HexColor("#2B2B2B")))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/map.png",
              height: 30,
              width: 30,
            ),
            Text(
              _likedFunds.location,
              style: textNormal(HexColor("#404040"), 12.0),
            )
          ],
        ),
        Text(
          "Minimum Investment : ${_likedFunds.minimumInvestment}",
          style: textNormal(HexColor("#404040"), 12.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          _likedFunds.description,
          style: textNormal(HexColor("#3A3B3F"), 14.0),
        )
      ],
    );
  }

  Widget _createFundBody() {
    return Column(
      children: [_createFundOverview(), _addNewFundValue(), _uploadFundDeck()],
    );
  }

  Widget _createFundOverview() {
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
                          Expanded(flex: 1, child: Text("Yes"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Regulator")),
                          Expanded(flex: 1, child: Text("Rahul Roy"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Website Link")),
                          Expanded(flex: 1, child: Text("www.exportbus.com"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Fund Sponsor")),
                          Expanded(flex: 1, child: Text("Alok Mittal"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("Existing Fund")),
                          Expanded(flex: 1, child: Text("\$300K"))
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: Text("New Fund")),
                          Expanded(flex: 1, child: Text("\$200K"))
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
  }

  TextField inputTextField(text, hint, _controller) {
    return TextField(
        onChanged: (text) {
          // if value is not empty enable the button
          if (text.length != 0) {
            print("true");
            _changeButtonStatus();
          } else {
            print("false");
            disableElevatedButton();
          }
        },
        style: textBlackNormal16(),
        controller: _controller,
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            labelText: text,
            hintText: hint,
            hintMaxLines: 2,
            labelStyle: new TextStyle(color: Colors.grey),
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2.0),
                borderRadius: BorderRadius.all(
                  const Radius.circular(10.0),
                ))));
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: unselectedGray,
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  Widget _addNewFundValue() {
    //Fund Name
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 10),
      decoration: BoxDecoration(
        color: unselectedGray,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: inputTextField("New Fund Value",
          "Please enter new fund value here", _newFundValueController),
    );
  }

  Widget _uploadFundDeck() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0, right: 15),
      child: _createDocumentUI(context, "Upload Fund Deck document",
          "PDF, JPEG, PNG, JPG, PPT etc."),
    );
  }

  Widget _createDocumentUI(
    BuildContext ctx,
    String labelText,
    String description,
  ) {
    return ProgressHUD(
      child: Builder(
        builder: (context) => InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => {
                  _selectFile(context, 0),
                },
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: unselectedGray,
                      borderRadius: BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                          child: (_uploadedDocuments
                                      .indexWhere((doc) => doc.id == 0) >=
                                  0)
                              ? Text('Uploaded',
                                  textAlign: TextAlign.center,
                                  style: textNormal(Colors.green, 14))
                              : Text(labelText,
                                  textAlign: TextAlign.center,
                                  style: textNormal(Colors.black, 14))),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      description,
                      style: textNormal(textGrey, 14),
                    )),
              ],
            )),
      ),
    );
  }

  Future<void> _selectFile(BuildContext context, int kycDocId) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // print('Path: ${result.files.single.path}');
      // print('Name: ${result.files.single.name}');
      String fileName = result.files.single.name;
      File file = File(result.files.single.path);
      _openDialogToUploadFile(context, kycDocId, file, fileName);
      // enable button if file is selected
      _changeButtonStatus();
    } else {
      showSnackBar(context, "No file selected.");
    }
  }

  _openDialogToUploadFile(
      BuildContext context, int kycDocId, File file, String fileName) {
    // set up the buttons
    Widget positiveButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          _uploadFile(context, kycDocId, file, fileName);
        },
        child: Text(
          "Ok",
          style: textNormal16(Color(0xff00A699)),
        ));

    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: textNormal16(Color(0xff00A699)),
        ));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text('Do you want to upload the file?'),
      actions: [
        positiveButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _uploadFile(
      BuildContext context, int kycDocId, File file, String fileName) async {
    progress = ProgressHUD.of(context);
    progress?.showWithText('Uploading File...');
    if (file != null) {
      UploadDocument doc =
          await UploadDocumentService.uploadDocument(file, fileName);
      if (doc != null) {
        _updateUploadedDocs(DocumentInfo(kycDocId, doc.data.fundKYCDocPath));
      }
    } else {
      showSnackBar(context, 'Something went wrong.');
    }
    progress.dismiss();
    setState(() {});
  }

  void _updateUploadedDocs(DocumentInfo docInfo) {
    final docIndex =
        _uploadedDocuments.indexWhere((doc) => doc.id == docInfo.id);
    if (docIndex >= 0) {
      _uploadedDocuments[docIndex] = docInfo;
      return;
    }
    _uploadedDocuments.add(docInfo);
  }

  _performSubmission() {
    print("CLICKED");
  }
}
