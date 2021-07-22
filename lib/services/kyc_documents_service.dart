import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/kyc/kyc_documents.dart';

class KYCDocumentService {
  // Fetch Documents
  static Future<KYCDocument> fetchKYCDocuments() async {
    final headers = {
      "Content-type": "application/json",
      "authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJQQ1h0eXBXL1hhbUVHSkRjdnhKMEx3PT0iLCJlbWFpbF9pZCI6IndNYjdidUtyaTc4MFFkQ0Rka0RTRm5PVDExNDBwbk9LQ2U2eFFSd3FZbk09IiwiZmlyc3RfbmFtZSI6IlRiLytrOU96TmxUUHdZRWt2TUdMQmc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiaUViaCt0aGJOcE1HZzdkdU40WnM5dz09IiwidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpZCI6NTgsImlhdCI6MTYyNjY4OTY3M30.EkrjAjCAXaUhlfraUtZCts9tV1MJpiwO7zMKfxQDDis",
    };
    final response = await http.get(
        Uri.parse('${ApiServices.baseUrl}/fund/kyc_document/list'),
        headers: headers);
    Map valueMap = jsonDecode(response.body);
    KYCDocument documentResponse = KYCDocument.from(valueMap);
    return documentResponse;
  }
}
