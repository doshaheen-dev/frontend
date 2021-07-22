import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:acc/models/upload/upload_document.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class UploadDocumentService {
  // Upload Document
  static Future<UploadDocument> uploadDocument(File file, String fileName) async {
    // set up POST request arguments
    final url = Uri.parse("${ApiServices.baseUrl}/upload");
    print('URL: $url');
    var request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile(
        'document', file.readAsBytes().asStream(), file.lengthSync(),
        filename: fileName));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('FileUpload Resp: $responseBody');
    Map valueMap = jsonDecode(responseBody);
    UploadDocument document = UploadDocument.from(valueMap);
    return document;
  }
}
