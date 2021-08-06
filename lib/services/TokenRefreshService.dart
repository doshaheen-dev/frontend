import 'dart:async';
import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/refresh_token.dart';
import 'package:http/http.dart' as http;
import 'package:acc/services/http_service.dart';

class TokenRefreshService {
  static Future<AppToken> refreshToken() async {
    final url = Uri.parse("${ApiServices.baseUrl}/user/refreshToken");
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}"
    };
    final response = await http.get(url, headers: headers);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    AppToken appToken = AppToken.from(valueMap);
    UserData.instance.userInfo.token = appToken.data.token;
    print("New Token:- ${UserData.instance.userInfo.token}");

    return appToken;
  }
}
