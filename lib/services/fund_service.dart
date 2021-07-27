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
    UserData.instance.token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJDaFp1bXRFQVNPUXZlWmppQWZQUEx3PT0iLCJlbWFpbF9pZCI6ImUvVTVUaWtzWGV1QjB2WGxndUg1eEhTS2hDSnZsVHczRENpZXY2M2R2WG89IiwiZmlyc3RfbmFtZSI6ImV5ZDJmOE0xb3lUc3h5Y0VRbmRjSGc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiajBtNWg5VE1mWWdKNUxjVktLREdwQT09IiwiaWQiOjEzNywidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpYXQiOjE2MjczMTA3OTN9.sR8LEOCcX39F6QC06Ac9ITFL-spLBb9txPOwyGjXIco";

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.token}",
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

  static Future<Fund> fetchFunds() async {
    UserData.instance.token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJDaFp1bXRFQVNPUXZlWmppQWZQUEx3PT0iLCJlbWFpbF9pZCI6ImUvVTVUaWtzWGV1QjB2WGxndUg1eEhTS2hDSnZsVHczRENpZXY2M2R2WG89IiwiZmlyc3RfbmFtZSI6ImV5ZDJmOE0xb3lUc3h5Y0VRbmRjSGc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiajBtNWg5VE1mWWdKNUxjVktLREdwQT09IiwiaWQiOjEzNywidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpYXQiOjE2MjczMTA3OTN9.sR8LEOCcX39F6QC06Ac9ITFL-spLBb9txPOwyGjXIco";

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.token}",
    };
    final response = await http.get(Uri.parse('${ApiServices.baseUrl}/fund'),
        headers: headers);
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
    UserData.instance.token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVfbm8iOiJDaFp1bXRFQVNPUXZlWmppQWZQUEx3PT0iLCJlbWFpbF9pZCI6ImUvVTVUaWtzWGV1QjB2WGxndUg1eEhTS2hDSnZsVHczRENpZXY2M2R2WG89IiwiZmlyc3RfbmFtZSI6ImV5ZDJmOE0xb3lUc3h5Y0VRbmRjSGc9PSIsIm1pZGRsZV9uYW1lIjoiIiwibGFzdF9uYW1lIjoiajBtNWg5VE1mWWdKNUxjVktLREdwQT09IiwiaWQiOjEzNywidXNlcl90eXBlIjoiaW52ZXN0b3IiLCJpYXQiOjE2MjczMTA3OTN9.sR8LEOCcX39F6QC06Ac9ITFL-spLBb9txPOwyGjXIco";

    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.token}",
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
