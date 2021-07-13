import 'dart:convert';

import 'package:http/http.dart';
import 'package:acc/models/authentication/verify_phone.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';

import 'http_service.dart';

class OtpService {
  static Future<VerifyPhoneNumber> verifyUser(
      String token, String phoneNumber) async {
    final url =
        Uri.parse("${ApiServices.baseUrl}/sign-up/verify/firebase/mobile_no");
    final headers = {"Content-type": "application/json"};
    final _body = '{"mobile_no": "$phoneNumber", "idToken": "$token"}';
    print("Body:${_body}");

    // make POST request
    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerifyPhoneNumber userDetails = VerifyPhoneNumber.from(valueMap);
    return userDetails;
  }

  // Get otp from backend
  static Future<VerifyPhoneNumberSignIn> verifyUserByServer(
      String token,
      String phoneNumber,
      String verificationId,
      String smsCode,
      String inputType,
      String requesterType) async {
    final url = Uri.parse("${ApiServices.baseUrl}/sign-in/verify_otp");
    final headers = {
      "Content-type": "application/json",
      "x-auth-service-type": "$requesterType"
    };
    var _body;
    if (inputType == "email") {
      _body =
          '{"email_id": "$phoneNumber", "idToken": "$token","verificationId": "$verificationId", "smsCode": "$smsCode"}';
    } else {
      _body =
          '{"mobile_no": "$phoneNumber", "idToken": "$token","verificationId": "$verificationId", "smsCode": "$smsCode"}';
    }
    print("Body:${_body}");

    // make POST request
    final response = await post(url, headers: headers, body: _body);
    print("response:${response.body}");
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerifyPhoneNumberSignIn userDetails =
        VerifyPhoneNumberSignIn.from(valueMap);
    return userDetails;
  }

  // Get otp from backend
  static Future<VerificationIdSignIn> getVerificationFromTwillio(
      String phoneNumber, String inputType, String requesterType) async {
    final url = Uri.parse("${ApiServices.baseUrl}/sign-in/send_otp");
    final headers = {
      "Content-type": "application/json",
      "x-auth-service-type": "$requesterType"
    };
    var _body;
    if (inputType == "mobile") {
      _body = '{"mobile_no": "$phoneNumber"}';
    } else {
      _body = '{"email_id": "$phoneNumber"}';
    }
    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerificationIdSignIn userDetails = VerificationIdSignIn.from(valueMap);
    return userDetails;
  }
}
