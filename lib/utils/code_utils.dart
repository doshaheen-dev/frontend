import 'dart:convert';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeUtils {
  static bool emailValid(String input) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(input);

  static bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  static Future<bool> syncUserPreferencesWithData(UserData data) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(data);
    return prefs.setString('UserInfo', userJson);
  }

  static Future<UserData> getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userMap;
    final String userStr = prefs.getString('UserInfo');
    if (userStr == null && userStr == "") {
      return null;
    }
    userMap = jsonDecode(userStr) as Map<String, dynamic>;
    UserData userData = UserData.fromNoDecryptionMap(userMap);
    return userData;
  }
}
