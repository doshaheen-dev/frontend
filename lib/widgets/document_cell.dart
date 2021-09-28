import 'package:acc/models/kyc/kyc_documents.dart';
// import 'package:acc/providers/kyc_docs_provider.dart';
import 'package:acc/screens/fundraiser/dashboard/create_funds_continue.dart';
import 'package:acc/utilites/app_colors.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class DocumentCell extends StatefulWidget {
  final List<DocumentInfo> uploadedDocuments;
  final OptionsData kycDoc;
  final Function selectFile;

  DocumentCell(
    this.uploadedDocuments,
    this.kycDoc,
    this.selectFile,
  );
  @override
  _DocumentCellState createState() => _DocumentCellState();
}

class _DocumentCellState extends State<DocumentCell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => {
        FocusScope.of(context).requestFocus(FocusNode()),
        widget.selectFile(context, widget.kycDoc.kycId)
      },
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: unselectedGray,
                  borderRadius: BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                      child: (widget.uploadedDocuments
                                  .where((doc) => doc.id == widget.kycDoc.kycId)
                                  .length >
                              0)
                          ? Text('Uploaded',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: textNormal(Colors.green, 14))
                          : Text('Upload ${widget.kycDoc.kycDocName}',
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
                widget.kycDoc.kycDocDesc,
                style: textNormal(textGrey, 14),
                textAlign: TextAlign.right,
              )),
        ],
      ),
    );
  }
}
