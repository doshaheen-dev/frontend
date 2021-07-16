import 'package:acc/utilites/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_flutter/pdf_viewer_flutter.dart';

class PDFViewer extends StatefulWidget {
  final String _pdf;
  const PDFViewer({Key key, String pdf})
      : _pdf = pdf,
        super(key: key);

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  String _pefFilePath;

  @override
  void initState() {
    super.initState();
    _pefFilePath = widget._pdf;
  }

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: kDarkOrange,
          title: Text("PDF Document Name"),
        ),
        path: _pefFilePath);
  }
}
