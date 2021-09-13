import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class AppPDFViewer extends StatefulWidget {
  final String _pdf;
  const AppPDFViewer({Key key, String pdf})
      : _pdf = pdf,
        super(key: key);

  @override
  _AppPDFViewerState createState() => _AppPDFViewerState();
}

class _AppPDFViewerState extends State<AppPDFViewer> {
  PDFDocument document;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPdfDocument(widget._pdf);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                body: Center(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : PDFViewer(document: document),
                ))));
  }

  Future<void> loadPdfDocument(String pdf) async {
    document = await PDFDocument.fromURL(pdf);
    setState(() => _isLoading = false);
  }
}
