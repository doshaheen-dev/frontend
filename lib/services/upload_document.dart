import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class UploadDocumentService {
  // Upload Document
  static Future<void> uploadDocument(File file, String fileName) async {
    // set up POST request arguments
    final url = Uri.parse("${ApiServices.baseUrl}/upload");
    print('URL: $url');
    var request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile(
        'document', file.readAsBytes().asStream(), file.lengthSync(),
        filename: fileName));
    final response = await request.send();
    final statusCode = response.statusCode;
    final responseBody = await response.stream.bytesToString();
    print('FileUpload Code: $statusCode');
    print('FileUpload Resp: $responseBody');
  }
}
