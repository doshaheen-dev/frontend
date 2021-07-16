import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:acc/models/profile/basic_details.dart';
import 'package:acc/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acc/models/authentication/signup_request.dart';

class SignUpService {
  // Upload User Details
  static Future<void> uploadUserDetails(
      InvestorSignupRequestModel request) async {
    // set up POST request arguments
    final prefs = await SharedPreferences.getInstance();
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
    return;
  }
}
