import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio_management/models/profile/basic_details.dart';
import 'package:portfolio_management/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  // Update basic details
  static Future<UpdateBasicDetails> updateBasicDetails(
    String firstName,
    String lastName,
    String emailId,
    String countryCode,
    String address,
  ) async {
    // set up POST request arguments
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(
        "${ApiServices.baseUrl}/sign-up/basic_detail/${prefs.getInt("userId")}");
    final headers = {"Content-type": "application/json"};
    final _body = {
      "first_name": firstName,
      "last_name": lastName,
      "email_id": emailId,
      "country_code": countryCode,
      "address": address,
    };
    final jsonBody = jsonEncode(_body);

    print('URL: $url');
    print("Body:$jsonBody");

    // make PUT request
    final response = await http.put(url, headers: headers, body: jsonBody);
    // this API passes back the id of the user after updating the details
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    UpdateBasicDetails userDetails = UpdateBasicDetails.from(valueMap);
    return userDetails;
  }
}
