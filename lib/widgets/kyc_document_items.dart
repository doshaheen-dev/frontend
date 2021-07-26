import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/widgets/document_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
