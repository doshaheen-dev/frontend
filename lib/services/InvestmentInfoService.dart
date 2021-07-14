import 'dart:async';
import 'dart:convert';
import 'package:acc/models/investor/hearaboutus.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class InvestmentInfoService {
  //Get Hear about us list
  static Future<HearAboutUs> hearAboutUsInfo() async {
    final url = Uri.parse("${ApiServices.baseUrl}/sign-up/hear_about_us");
    final headers = {"Content-type": "application/json"};
    final response = await http.get(url, headers: headers);
    final responseBody = response.body;
    print("Response Body: $responseBody");
    Map valueMap = jsonDecode(responseBody);
    HearAboutUs hearAboutUs = HearAboutUs.fromJson(valueMap);

    return hearAboutUs;
  }
}
