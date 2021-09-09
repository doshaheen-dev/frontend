import 'dart:async';
import 'dart:convert';

import 'package:acc/models/authentication/signup_request_basicinfo.dart';
import 'package:acc/models/authentication/signup_request_preferences.dart';
import 'package:acc/models/authentication/signup_response.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';
import 'package:acc/models/authentication/signup_request.dart';

class SignUpService {
  // Upload User Details
  static Future<User> uploadUserDetails(
      InvestorSignupRequestModel request) async {
    // set up POST request arguments
    final url = Uri.parse("${ApiServices.baseUrl}/sign-up/user");
    final headers = {"Content-type": "application/json"};
    final jsonBody = jsonEncode(request);

    print('URL: $url');
    print("Body:$jsonBody");

    final response = await http.post(url, headers: headers, body: jsonBody);
    // this API passes back the id of the user after updating the details
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    print('Signup Resp: $valueMap');
    User userDetails = User.from(valueMap);
    return userDetails;
  }

// To upload basic info for signup investor
  static Future<User> uploadBasicUserDetails(
      InvestorSignupBasicInfo request) async {
    // set up POST request arguments
    final url = Uri.parse("${ApiServices.baseUrl}/sign-up/user");
    final headers = {"Content-type": "application/json"};
    final jsonBody = jsonEncode(request);

    print('URL: $url');
    print("Body:$jsonBody");

    final response = await http.post(url, headers: headers, body: jsonBody);
    // this API passes back the id of the user after updating the details
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    print('Signup Resp: $valueMap');
    User userDetails = User.from(valueMap);
    return userDetails;
  }

// To update investors preference on signup
  static Future<User> updateUserPreferences(
      InvestorSignupPreferences request) async {
    // set up POST request arguments
    final url = Uri.parse("${ApiServices.baseUrl}/user/update ");
    final headers = {"Content-type": "application/json"};
    final jsonBody = jsonEncode(request);

    print('URL: $url');
    print("Body:$jsonBody");

    final response = await http.post(url, headers: headers, body: jsonBody);
    // this API passes back the id of the user after updating the details
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    print('Signup Resp: $valueMap');
    User userDetails = User.from(valueMap);
    return userDetails;
  }
}
