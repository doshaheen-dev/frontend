import 'dart:async';
import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/fund/add_fund_request.dart';
import 'package:acc/models/fund/add_fund_response.dart';
import 'package:acc/models/fund/fund_response.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class FundService {
  // Upload Fund Details
  static Future<AddFundResponse> addFund(AddFundRequestModel request) async {
    final url = Uri.parse("${ApiServices.baseUrl}/fund");
    // UserData.instance.token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiI1MGl5NnJMZCtyenRERmt0L2hqaHJnPT0iLCJlbWFpbF9pZCI6ImFKakp2UGUvQUhUaHREV2tLYjZaalB4MG9MVzNkOXdyNi9KSUpoMlZTeGs9IiwiZmlyc3RfbmFtZSI6IkNQMmFxMmVZVEdtTjJXWkMvbmdUdXc9PSIsIm1pZGRsZV9uYW1lIjpudWxsLCJsYXN0X25hbWUiOiJVZ3dYTmR5NGNmaDNFUXVUQThSaHhBPT0iLCJpZCI6MTQ5LCJ1c2VyX3R5cGUiOiJmdW5kcmFpc2VyIiwiaWF0IjoxNjI3Mzk5NDU0fQ.SqlBLUSp5etHMC-DiOXJ0eHdEG_KoQGPWMTlQ0Vl0ws";

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final jsonBody = jsonEncode(request);

    // print('URL: $url');
    // print("Body:$jsonBody");

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
    // UserData.instance.token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiI1MGl5NnJMZCtyenRERmt0L2hqaHJnPT0iLCJlbWFpbF9pZCI6ImFKakp2UGUvQUhUaHREV2tLYjZaalB4MG9MVzNkOXdyNi9KSUpoMlZTeGs9IiwiZmlyc3RfbmFtZSI6IkNQMmFxMmVZVEdtTjJXWkMvbmdUdXc9PSIsIm1pZGRsZV9uYW1lIjpudWxsLCJsYXN0X25hbWUiOiJVZ3dYTmR5NGNmaDNFUXVUQThSaHhBPT0iLCJpZCI6MTQ5LCJ1c2VyX3R5cGUiOiJmdW5kcmFpc2VyIiwiaWF0IjoxNjI3Mzk5NDU0fQ.SqlBLUSp5etHMC-DiOXJ0eHdEG_KoQGPWMTlQ0Vl0ws";

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
    // UserData.instance.token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiI1MGl5NnJMZCtyenRERmt0L2hqaHJnPT0iLCJlbWFpbF9pZCI6ImFKakp2UGUvQUhUaHREV2tLYjZaalB4MG9MVzNkOXdyNi9KSUpoMlZTeGs9IiwiZmlyc3RfbmFtZSI6IkNQMmFxMmVZVEdtTjJXWkMvbmdUdXc9PSIsIm1pZGRsZV9uYW1lIjpudWxsLCJsYXN0X25hbWUiOiJVZ3dYTmR5NGNmaDNFUXVUQThSaHhBPT0iLCJpZCI6MTQ5LCJ1c2VyX3R5cGUiOiJmdW5kcmFpc2VyIiwiaWF0IjoxNjI3Mzk5NDU0fQ.SqlBLUSp5etHMC-DiOXJ0eHdEG_KoQGPWMTlQ0Vl0ws";

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}",
    };
    final jsonBody = jsonEncode(request);
    // print('URL: $url');
    // print("Body:$jsonBody");
    final response = await http.put(url, headers: headers, body: jsonBody);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    print('UpdateFund Resp: $valueMap');
    AddFundResponse fundTxnDetails = AddFundResponse.from(valueMap);
    return fundTxnDetails;
  }
}
