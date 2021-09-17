import 'dart:io';

import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/models/fund/add_fund_response.dart';
import 'package:acc/models/upload/upload_document.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/fund_service.dart';
import 'package:acc/services/upload_document_service.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/hex_color.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_detail_documents.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_detail_overview.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_detail_remarks.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_details_header.dart';
import 'package:acc/widgets/fundraiser/fundDetails/funds_resubmit_header.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'fundraiser_dashboard.dart';

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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: ProgressHUD(
            child: Builder(
          builder: (context) => Scaffold(
            bottomNavigationBar: _createButtonLayout(context),
            backgroundColor: Colors.white,
            body: new GestureDetector(
              onTap: () {
                /*This method here will hide the soft keyboard.*/
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 25.0),
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
                                  visible: isResubmit,
                                  child: FundsResubmitHeader())
                            ],
                          ),
                        ),

                        Divider(color: HexColor("#E8E8E8")),
                        // Fund overview
                        Container(
                          child: _createFundBody(),
                        ),

                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        "\$${_likedFunds.fundNewVal}",
                                        style: textBlackNormal16(),
                                      ),
                                      Text("Target",
                                          style: textNormal16(
                                              Theme.of(context).primaryColor))
                                    ],
                                  )),
                              // Expanded(
                              //     flex: 1,
                              //     child: Column(
                              //       children: [
                              //         Text(
                              //           _likedFunds.minimumInvestment,
                              //           style: textBlackNormal16(),
                              //         ),
                              //         Text("Min Per Investor",
                              //             style: textNormal16(kDarkOrange))
                              //       ],
                              //     ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        )));
  }

  _createButtonLayout(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: isResubmit,
            child: Container(
                margin: const EdgeInsets.only(
                    top: 5.0, left: 20.0, bottom: 20, right: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isButtonDisabled) {
                      if (_newFundValueController.text.isNotEmpty) {
                        if (int.parse(_newFundValueController.text.trim()) >
                                2100000000 ||
                            int.parse(_newFundValueController.text.trim()) <=
                                0) {
                          showSnackBar(context,
                              "Please enter new fund value between 0 and 2100000000");
                          return;
                        }
                      }

                      progress = ProgressHUD.of(context);
                      progress?.showWithText('Submitting Updates...');
                      _performSubmission(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18))),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: !_isButtonDisabled
                            ? LinearGradient(
                                colors: [textLightGrey, textLightGrey])
                            : LinearGradient(colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor
                              ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("Submit", style: textWhiteBold16()),
                    ),
                  ),
                )),
          ),
        ));
  }

  Widget _createFundBody() {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              CreateFundOverview(_likedFunds),
              Visibility(
                visible: !isResubmit,
                child: FundsUploadedDocument(_likedFunds),
              ),
              Visibility(
                  visible: !isResubmit,
                  child: FundsRemark(_likedFunds.fundsRemarks != null
                      ? _likedFunds.fundsRemarks
                      : "Remarks are not available")),
              Visibility(visible: isResubmit, child: _addNewFundValue()),
              Visibility(visible: isResubmit, child: _uploadFundDeck())
            ],
          ),
        ));
  }

  TextField inputTextField(text, hint, _controller) {
    return TextField(
      onChanged: (text) {
        // if value is not empty enable the button
        _changeButtonStatus();
      },
      style: textBlackNormal16(),
      controller: _controller,
      decoration: new InputDecoration(
          contentPadding: EdgeInsets.all(8.0),
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
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget _addNewFundValue() {
    //Fund Name
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          margin: const EdgeInsets.only(
              top: 5.0, bottom: 10, left: 5.0, right: 5.0),
          decoration: BoxDecoration(
              color: unselectedGray,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: textGrey, width: 1)),
          child: inputTextField("New Fund Value",
              "Please enter new fund value here", _newFundValueController),
        ));
  }

  Widget _uploadFundDeck() {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0, right: 15),
          child: _createDocumentUI(context, "Upload Fund Deck document",
              "PDF, JPEG, PNG, JPG, PPT etc."),
        ));
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
                  _selectFile(context, 3), //3 For Fund Deck
                },
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 10, left: 2.0),
                    decoration: BoxDecoration(
                      color: unselectedGray,
                      borderRadius: BorderRadius.all(
                        const Radius.circular(15.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                          child: (_uploadedDocuments
                                      .indexWhere((doc) => doc.id == 3) >=
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
          style: textNormal16(Theme.of(context).primaryColor),
        ));

    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          "Cancel",
          style: textNormal16(Theme.of(context).primaryColor),
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
      } else {
        showSnackBar(context, doc.message);
      }
    } else {
      showSnackBar(context, 'File was corrupt.');
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

  void _performSubmission(BuildContext context) async {
    try {
      final requestModelInstance = AddFundRequestModel.instance;
      String newVal = _newFundValueController.text.trim();

      if (newVal != null && newVal != '') {
        requestModelInstance.fundNewVal = int.parse(newVal);
      }
      requestModelInstance.fundKycDocuments = null;
      if (_uploadedDocuments.isNotEmpty) {
        requestModelInstance.fundKycDocuments = [];
        _uploadedDocuments.forEach((item) {
          requestModelInstance.fundKycDocuments
              .add(DocumentsData(item.id, item.uploadedKey));
        });
      }
      AddFundResponse response = await FundService.updateFund(
          requestModelInstance, _likedFunds.fundTxnId);
      progress.dismiss();
      if (response.type == 'success') {
        // print("ResubmitSuccess");
        requestModelInstance.clear();
        _navigateToFundHome();
      } else {
        showSnackBar(context, response.message);
      }
    } catch (e) {
      if (progress != null) {
        progress.dismiss();
      }
      showSnackBar(context, e.toString());
      // showSnackBar(context, "${e.toString()}");
      // print(e.toString());
    }
  }

  void _navigateToFundHome() {
    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return FundraiserDashboard();
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
            }),
        (Route<dynamic> route) => false);
  }
}
