import 'package:acc/models/kyc/kyc_documents.dart';
import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/document_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class KYCDocumentItems extends StatefulWidget {
  final List<DocumentInfo> uploadedDocuments;
  final Function selectFile;

  KYCDocumentItems(
    this.uploadedDocuments,
    this.selectFile,
  );
  @override
  _KYCDocumentItemsState createState() => _KYCDocumentItemsState();
}

class _KYCDocumentItemsState extends State<KYCDocumentItems> {
  Future _documents;
  var _isInit = true;

  Future<void> _fetchDocuments(BuildContext context) async {
    await Provider.of<KYCDocuments>(context, listen: false)
        .fetchAndSetKYCDocuments();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {});
      _documents = _fetchDocuments(context);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  InkWell _createDocumentCell(OptionsData kycDoc) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => widget.selectFile(context, kycDoc.kycId),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: unselectedGray,
                    borderRadius: BorderRadius.all(
                      const Radius.circular(15.0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Center(
                        child: (widget.uploadedDocuments
                                    .where((doc) => doc.id == kycDoc.kycId)
                                    .length >
                                0)
                            ? Text('Uploaded',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: textNormal(Colors.green, 14))
                            : Text('Upload ${kycDoc.kycDocName}',
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: textNormal(Colors.black, 14))),
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Text(
                  kycDoc.kycDocDesc,
                  style: textNormal(textGrey, 14),
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _documents,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.orange,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
          ));
        } else {
          if (dataSnapshot.error != null) {
            return Center(child: Text("An error occurred!"));
          } else {
            return Consumer<KYCDocuments>(
              builder: (ctx, docData, child) => Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please upload required documents",
                      style: textNormal(textGrey, 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0, right: 15),
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return DocumentCell(
                            widget.uploadedDocuments,
                            docData.documents[index],
                            widget.selectFile,
                          );
                        },
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: docData.documents.length,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
