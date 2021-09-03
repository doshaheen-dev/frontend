import 'dart:io';

import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/models/fund/add_fund_response.dart';
import 'package:acc/models/upload/upload_document.dart';
import 'package:acc/providers/fund_slot_provider.dart' as slotProvider;
import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/success_fund_submit.dart';
import 'package:acc/services/fund_service.dart';
import 'package:acc/services/upload_document_service.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/date_utils.dart';
import 'package:acc/widgets/kyc_document_items.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

class CreateFundsContinue extends StatefulWidget {
  @override
  _CreateFundsContinueState createState() => _CreateFundsContinueState();
}

class _CreateFundsContinueState extends State<CreateFundsContinue> {
  int selectedIndex;
  final _fundSponsorNameController = TextEditingController();
  var progress;
  bool _isTermsCheck = false;
  List<DocumentInfo> _uploadedDocuments = [];
  var _isInit = true;
  var slotId = 0;

  Future _fundSlots;
  Future<void> _fetchFundSlots(BuildContext context) async {
    await Provider.of<slotProvider.FundSlots>(context, listen: false)
        .fetchAndSetSlots();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _fundSlots = _fetchFundSlots(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _fundSponsorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Color(0xffffffff)));

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
        backgroundColor: Color(0xffffffff),
      ),
      bottomNavigationBar: BottomAppBar(),
      backgroundColor: Colors.white,
      body: ProgressHUD(
          child: Builder(
              builder: (context) => SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back, size: 30),
                                  onPressed: () => {Navigator.pop(context)},
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Tell us about your fund",
                                            style: textBold(headingBlack, 20)),
                                        Text(
                                            "What is the Minimum Investment from an investor",
                                            style: textNormal(textGrey, 14))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: FutureBuilder(
                                      future: _fundSlots,
                                      builder: (ctx, dataSnapshot) {
                                        if (dataSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: CircularProgressIndicator(
                                            backgroundColor: Colors.orange,
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(Colors.amber),
                                          ));
                                        } else {
                                          if (dataSnapshot.error != null) {
                                            return Center(
                                                child:
                                                    Text("An error occurred!"));
                                          } else {
                                            return Consumer<
                                                slotProvider.FundSlots>(
                                              builder: (ctx, slotData, child) =>
                                                  GridView.count(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 10.0,
                                                mainAxisSpacing: 10.0,
                                                shrinkWrap: true,
                                                childAspectRatio:
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 /
                                                        65),
                                                children: List.generate(
                                                  slotData.slotLineItems.length,
                                                  (index) {
                                                    return _createCell(
                                                        slotData.slotLineItems[
                                                            index],
                                                        index);
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),

                                  //Fund  General Partner / Managing Partner (GP)
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 20.0, bottom: 20),
                                    decoration: customDecoration(),
                                    child: inputTextField(
                                        "Fund  General Partner / Managing Partner (GP)",
                                        "Please enter general partner here",
                                        _fundSponsorNameController),
                                  ),
                                  KYCDocumentItems(
                                      _uploadedDocuments, _selectFile),

                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom: 10.0, right: 15),
                                    child: _createDocumentUI(
                                        context,
                                        "Upload Fund Brand Image",
                                        "JPEG, PNG, JPG."),
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        "Matchmaker fee for Amicorp",
                                        style: textNormal(textGrey, 12),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "5%",
                                        style: textNormal(selectedOrange, 18),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Colors
                                              .white, // color of tick Mark
                                          activeColor: kDarkOrange,
                                          value: _isTermsCheck,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isTermsCheck = value;
                                            });
                                          }),
                                      Flexible(
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text:
                                                  "By signing in, I agree with ",
                                              style:
                                                  textNormal(textLightGrey, 14),
                                              children: [
                                                TextSpan(
                                                    text: "Terms of Use ",
                                                    style: textNormal(
                                                        Colors.black, 14),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {}),
                                                TextSpan(
                                                  text: "and ",
                                                  style: textNormal(
                                                      textLightGrey, 14),
                                                ),
                                                TextSpan(
                                                    text: "Privacy Poicy",
                                                    style: textNormal(
                                                        Colors.black, 14),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {})
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //NEXT BUTTON
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 20,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (slotId <= 0) {
                                          showSnackBar(context,
                                              "Please select minimum investment.");
                                          return;
                                        }
                                        if (_fundSponsorNameController
                                            .text.isEmpty) {
                                          showSnackBar(context,
                                              "Please enter the partner name.");
                                          return;
                                        }
                                        final docData =
                                            Provider.of<KYCDocuments>(context,
                                                    listen: false)
                                                .documents;
                                        print('DocData Len: ${docData.length}');
                                        var documentsMsg = '';
                                        docData.reversed.forEach((option) {
                                          if (_uploadedDocuments
                                              .indexWhere((doc) =>
                                                  doc.id == option.kycId)
                                              .isNegative) {
                                            documentsMsg =
                                                'Please upload the ${option.kycDocName}';
                                          }
                                        });
                                        if (documentsMsg.isNotEmpty) {
                                          showSnackBar(context, documentsMsg);
                                          return;
                                        }
                                        if (_uploadedDocuments
                                            .indexWhere((doc) => doc.id == 0)
                                            .isNegative) {
                                          showSnackBar(context,
                                              "Please upload the fund brand image.");
                                          return;
                                        }
                                        if (!_isTermsCheck) {
                                          showSnackBar(context,
                                              "Please accept the Terms and Privacy Policy.");
                                          return;
                                        }
                                        progress = ProgressHUD.of(context);
                                        progress?.showWithText(
                                            'Uploading Fund Details...');
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        final fundLogo = _uploadedDocuments
                                            .where((doc) => doc.id == 0)
                                            .first;
                                        uploadFundTxnDetails(
                                          _fundSponsorNameController.text
                                              .trim(),
                                          fundLogo.uploadedKey,
                                          DateUtilsExt.currentDateWithFormat(
                                              "yyyy-MM-dd HH:mm:ss"),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(0.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18))),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              kDarkOrange,
                                              kLightOrange
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: Text("Submit",
                                              style: textWhiteBold18()),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ))),
    );
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

  Future<void> _uploadFile(
      BuildContext context, int kycDocId, File file, String fileName) async {
    progress = ProgressHUD.of(context);
    progress?.showWithText('Uploading File...');
    try {
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
    } catch (e) {
      showSnackBar(context, e.toString());
      if (progress != null) {
        progress.dismiss();
      }
      setState(() {});
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

  Future<void> _selectFile(BuildContext context, int kycDocId) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String fileName = result.files.single.name;
      File file = File(result.files.single.path);
      _openDialogToUploadFile(context, kycDocId, file, fileName);
    } else {
      showSnackBar(context, "No file selected.");
    }
  }

  TextField inputTextField(text, hint, _controller) {
    return TextField(
        onChanged: (text) {},
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

  InkWell _createCell(
      slotProvider.InvestmentLimitItem slotLineItem, int index) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          slotId = slotLineItem.id;
          selectedIndex = index;
        });
      },
      child: Container(
        width: 10,
        height: 30,
        decoration: BoxDecoration(
          color: selectedIndex == index ? selectedOrange : unselectedGray,
          borderRadius: BorderRadius.all(
            const Radius.circular(15.0),
          ),
        ),
        child: Center(
            child: Text(slotLineItem.header,
                style: textNormal(
                    selectedIndex == index ? Colors.white : Colors.black, 14))),
      ),
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
            onTap: () => _selectFile(context, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: unselectedGray,
                        borderRadius: BorderRadius.all(
                          const Radius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child: Center(
                            child: (_uploadedDocuments
                                        .indexWhere((doc) => doc.id == 0) >=
                                    0)
                                ? Text('Uploaded',
                                    style: textNormal(Colors.green, 14))
                                : Text(
                                    labelText,
                                    style: textNormal(Colors.black, 14),
                                    textAlign: TextAlign.center,
                                  )),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: textNormal(textGrey, 14),
                    )),
              ],
            )),
      ),
    );
  }

  BoxDecoration customDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(const Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          color: Colors.grey[200],
        )
      ],
    );
  }

  void uploadFundTxnDetails(
    String sponsor,
    String logoPath,
    String timestamp,
  ) async {
    try {
      final requestModelInstance = AddFundRequestModel.instance;
      requestModelInstance.slotId = slotId;
      requestModelInstance.fundSponsorName = sponsor;
      requestModelInstance.fundLogo = logoPath;
      requestModelInstance.termsAgreedTimestamp = timestamp;
      requestModelInstance.fundKycDocuments = [];
      _uploadedDocuments.forEach((item) {
        requestModelInstance.fundKycDocuments
            .add(DocumentsData(item.id, item.uploadedKey));
      });
      AddFundResponse response =
          await FundService.addFund(requestModelInstance);
      progress.dismiss();
      if (response.type == 'success') {
        requestModelInstance.clear();
        openSuccesssFundSubmitted();
      } else {
        showSnackBar(context, response.message);
      }
    } catch (e) {
      progress.dismiss();
      showSnackBar(context, e.toString());
    }
  }

  void openSuccesssFundSubmitted() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, anotherAnimation) {
          return SuccesssFundSubmitted();
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

class InvestmentLimitItem {
  final String header;

  InvestmentLimitItem(this.header);
}

class DocumentInfo {
  const DocumentInfo(
    this.id,
    this.uploadedKey,
  );
  final int id;
  final String uploadedKey;
}
