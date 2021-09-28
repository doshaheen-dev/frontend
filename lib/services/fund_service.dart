import 'dart:async';
import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/models/fund/add_fund_response.dart';
import 'package:acc/models/fund/fund_documents.dart';
import 'package:acc/models/fund/fund_response.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class FundService {
  // Upload Fund Details
  static Future<AddFundResponse> addFund(AddFundRequestModel request) async {
    final url = Uri.parse("${ApiServices.baseUrl}/fund");

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final jsonBody = jsonEncode(request);
    final response = await http.post(url, headers: headers, body: jsonBody);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    print('AddFund Resp: $valueMap');
    AddFundResponse fundTxnDetails = AddFundResponse.from(valueMap);
    return fundTxnDetails;
  }

  static Future<Fund> fetchFunds(
    int pageNo,
    int pageSize,
  ) async {
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final url = Uri.parse(
        '${ApiServices.baseUrl}/fund?pageNo=$pageNo&pageSize=$pageSize');
    final response = await http.get(url, headers: headers);
    // print('resp: ${response.body}');
    Map valueMap = jsonDecode(response.body);
    Fund funds = Fund.from(valueMap);
    return funds;
  }

  static Future<AddFundResponse> updateFund(
    AddFundRequestModel request,
    int fundId,
  ) async {
    final url = Uri.parse("${ApiServices.baseUrl}/fund/$fundId");
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final jsonBody = jsonEncode(request);
    print('ReqBody: $jsonBody');
    final response = await http.put(url, headers: headers, body: jsonBody);
    final responseBody = response.body;
    print('ResBody: $responseBody');
    Map valueMap = jsonDecode(responseBody);
    AddFundResponse fundTxnDetails = AddFundResponse.from(valueMap);
    return fundTxnDetails;
  }

  static Future<FundDocuments> getFundsDocument(int fundId) async {
    final url =
        Uri.parse("${ApiServices.baseUrl}/fund/uploaded/documents/$fundId");
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final response = await http.get(url, headers: headers);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    FundDocuments fundTxnDetails = FundDocuments.from(valueMap);
    return fundTxnDetails;
  }
}
