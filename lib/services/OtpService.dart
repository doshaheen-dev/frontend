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
    // make POST request
    final response = await post(url, headers: headers, body: _body);
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerifyPhoneNumber userDetails = VerifyPhoneNumber.from(valueMap);
    return userDetails;
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

  //Sign up - Investor
  static Future<VerificationIdSignIn> getSignUpOtp(String phoneNumber) async {
    final url = Uri.parse("${ApiServices.baseUrl}/sign-up/send_otp");
    final headers = {
      "Content-type": "application/json",
    };
    var _body = '{"mobile_no": "$phoneNumber"}';
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
