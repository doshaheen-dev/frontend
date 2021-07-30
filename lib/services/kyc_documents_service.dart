import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/kyc/kyc_documents.dart';

class KYCDocumentService {
  // Fetch Documents
  static Future<KYCDocument> fetchKYCDocuments() async {
    // UserData.instance.token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJDaFp1bXRFQVNPUXZlWmppQWZQUEx3PT0iLCJlbWFpbF9pZCI6ImUvVTVUaWtzWGV1QjB2WGxndUg1eEhTS2hDSnZsVHczRENpZXY2M2R2WG89IiwiZmlyc3RfbmFtZSI6ImV5ZDJmOE0xb3lUc3h5Y0VRbmRjSGc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiajBtNWg5VE1mWWdKNUxjVktLREdwQT09IiwiaWQiOjEzNywidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpYXQiOjE2MjczMTA3OTN9.sR8LEOCcX39F6QC06Ac9ITFL-spLBb9txPOwyGjXIco";

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final response = await http.get(
        Uri.parse('${ApiServices.baseUrl}/fund/kyc_document/list'),
        headers: headers);
    Map valueMap = jsonDecode(response.body);
    KYCDocument documentResponse = KYCDocument.from(valueMap);
    return documentResponse;
  }
}
