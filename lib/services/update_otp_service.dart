import 'dart:convert';

import 'package:acc/models/authentication/otp_response.dart';
import 'package:acc/models/default.dart';
import 'package:http/http.dart';
import 'package:acc/models/authentication/verify_phone_signin.dart';

import 'http_service.dart';

class UpdateProfileOtpService {
  //GET OTP
  static Future<VerificationIdSignIn> getOtp(
      String text, String otpType) async {
    final url = Uri.parse("${ApiServices.baseUrl}/user/send_otp");
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}"
    };

    var _body = '{"$otpType": "$text"}';
    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerificationIdSignIn userDetails = VerificationIdSignIn.from(valueMap);
    return userDetails;
  }

  static Future<Default> verifyOtp(
      String verificationId, String smsCode) async {
    final url = Uri.parse("${ApiServices.baseUrl}/user/verify_otp");
    final headers = {
      "Content-type": "application/json",
      "authorization": "Bearer ${UserData.instance.userInfo.token}"
    };
    final _body =
        '{"verificationId": "$verificationId", "smsCode": "$smsCode"}';
    // make POST request
    print(_body);
    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    print(responseBody);
    Map valueMap = jsonDecode(responseBody);
    return Default.from(valueMap);
  }

  // VERIFY OTP FOR SIGN IN
  static Future<UserSignIn> verifyUserByServer(
    String token,
    String phoneNumber,
    String verificationId,
    String smsCode,
    String inputType,
  ) async {
    final url = Uri.parse("${ApiServices.baseUrl}/sign-in/verify_otp");
    final headers = {"Content-type": "application/json"};
    var _body;
    if (inputType == "email") {
      _body =
          '{"email_id": "$phoneNumber", "idToken": "$token","verificationId": "$verificationId", "smsCode": "$smsCode"}';
    } else {
      _body =
          '{"mobile_no": "$phoneNumber", "idToken": "$token","verificationId": "$verificationId", "smsCode": "$smsCode"}';
    }

    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    UserSignIn userDetails = UserSignIn.from(valueMap);
    return userDetails;
  }

  // SEND OTP TO MOBILE AND EMAIL
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

  //Sign up verify otp - Investor
  static Future<SignUpInvestor> getVerifySignUpOtp(
      String phoneNumber, String verificationId, String otpCode) async {
    final url = Uri.parse("${ApiServices.baseUrl}/sign-up/verify_otp");
    final headers = {
      "Content-type": "application/json",
      "Charset": "utf-8",
    };

    var _body =
        '{"mobile_no": "$phoneNumber", "verificationId" : "$verificationId", "smsCode" : "$otpCode"}';
    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    SignUpInvestor userDetails = SignUpInvestor.from(valueMap);
    return userDetails;
  }
}
