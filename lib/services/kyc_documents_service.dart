import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/kyc/kyc_documents.dart';

class KYCDocumentService {
  // Fetch Documents
  static Future<KYCDocument> fetchKYCDocuments() async {
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
