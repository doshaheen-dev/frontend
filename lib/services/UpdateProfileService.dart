import 'dart:async';
import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/default.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class UpdateProfileService {
  static Future<Default> updateUserInfo(Map<String, dynamic> requestMap) async {
    final url = Uri.parse("${ApiServices.baseUrl}/user/update");
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}"
    };

    final response =
        await http.post(url, headers: headers, body: json.encode(requestMap));
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    Default userDetails = Default.from(valueMap);
    return userDetails;
  }
}
