import 'dart:io';

import 'package:acc/models/upload/upload_document.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/upload_document_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_detail_overview.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_details_header.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_resubmit_header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isButtonDisabled = false;
  var _changeFundDeckBgColor = unselectedGray;
  var _selectedFundDeckTextColor = Colors.black;
  var _pefFilePath;

  bool isDocumentUploaded = false;

  @override
  void initState() {
    _likedFunds = widget._recommendation;
    isResubmit = widget._fundDetailType;
    _changeButtonStatus();
    super.initState();
  }

  void _changeButtonStatus() {
    setState(() {
      if (_newFundValueController.text.trim().length != 0 ||
          isDocumentUploaded) {
        _isButtonDisabled = true;
      } else {
        _isButtonDisabled = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 40.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !isResubmit,
                            child: FundsDetailHeader(_likedFunds)),
                        Visibility(
                            visible: isResubmit, child: FundsResubmitHeader())
                      ],
                    ),
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
                            top: 5.0, left: 20.0, bottom: 20, right: 20.0),
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

  Widget _createFundBody() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          CreateFundOverview(_likedFunds),
          Visibility(visible: !isResubmit, child: _createDocumentUpload()),
          Visibility(visible: !isResubmit, child: _createRemarks()),
          Visibility(visible: isResubmit, child: _addNewFundValue()),
          Visibility(visible: isResubmit, child: _uploadFundDeck())
        ],
      ),
    );
  }

  Widget _createDocumentUpload() {
    return Column(children: [
      Card(
        color: _changeFundDeckBgColor,
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
                      style: textBold16(_selectedFundDeckTextColor))),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    "assets/images/icon_down.png",
                    color: _selectedFundDeckTextColor,
                  ))
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _createRemarks() {
    return Column(children: [
      Card(
        color: _changeFundDeckBgColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Remarks (By Amicorp)",
                      textAlign: TextAlign.start,
                      style: textBold16(_selectedFundDeckTextColor))),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset(
                    "assets/images/icon_down.png",
                    color: _selectedFundDeckTextColor,
                  ))
            ],
          ),
        ),
      ),
    ]);
  }

  TextField inputTextField(text, hint, _controller) {
    return TextField(
      onChanged: (text) {
        // if value is not empty enable the button
        // if (text.length != 0) {
        //   print("true");
        //   _changeButtonStatus();
        // } else {
        //   print("false");
        //   _changeButtonStatus();
        // }
        _changeButtonStatus();
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
              ))),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _addNewFundValue() {
    //Fund Name
    return Container(
      margin: const EdgeInsets.only(top: 5.0, bottom: 10),
      decoration: BoxDecoration(
          color: unselectedGray,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: textGrey, width: 1)),
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
                  FocusScope.of(context).requestFocus(FocusNode()),
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
          style: textNormal16(selectedOrange),
        ));

    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: textNormal16(selectedOrange),
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
    isDocumentUploaded = true;
    // enable button if file is selected
    _changeButtonStatus();
  }

  _performSubmission() {
    print("CLICKED");
  }
}
