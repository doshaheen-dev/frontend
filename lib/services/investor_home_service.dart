import 'dart:convert';

import 'package:acc/models/investor/recommendation.dart';
import 'package:acc/models/investor/respond_recommendation.dart';
import 'package:http/http.dart' as http;

import 'http_service.dart';

class InvestorHomeService {
  // Fetch Recommendations
  static Future<Recommendations> fetchRecommendation(String token) async {
    final url = Uri.parse(
        '${ApiServices.baseUrl}/fund/recommendation?pageNo=2&pageSize=20');
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer $token"
    };

    final response = await http.get(url, headers: headers);
    Map valueMap = jsonDecode(response.body);
    Recommendations recommendations = Recommendations.from(valueMap);
    return recommendations;
  }

  // Show interest - Recommendations
  static Future<RespondRecommendation> acceptRejectRecommendation(
      int fundTxnId, int userInterested, String token) async {
    final url = Uri.parse('${ApiServices.baseUrl}/fund/user_interest');
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer $token"
    };
    final _body =
        '{"fund_txn_id": "$fundTxnId", "user_interested": "$userInterested"}';
    print("valueMap: $_body");
    final response = await http.post(url, headers: headers, body: _body);
    Map valueMap = jsonDecode(response.body);
    print("valueMap: $valueMap");
    RespondRecommendation recommendations =
        RespondRecommendation.from(valueMap);
    print("recommendations: $recommendations");
    return recommendations;
  }
}
