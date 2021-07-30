import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/profile/profile_image.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:acc/models/profile/basic_details.dart';
import 'package:acc/services/http_service.dart';
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
    final headers = {
      "Content-type": "application/json",
      "authorization": UserData.instance.userInfo.token
    };
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

// Upload Profile Image
  static Future<UploadProfileImage> uploadProfileImage(
      File file, String fileName) async {
    // set up POST request arguments
    final url = Uri.parse("${ApiServices.baseUrl}/user/user-profile");
    // print('URL: $url');
    var request = http.MultipartRequest('POST', url);
    request.headers["authorization"] =
        "Bearer ${UserData.instance.userInfo.token}";
    request.files.add(http.MultipartFile(
        'profilepic', file.readAsBytes().asStream(), file.lengthSync(),
        filename: fileName));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    // print('ProfPicResp: $responseBody');
    Map valueMap = jsonDecode(responseBody);
    UploadProfileImage imgResponse = UploadProfileImage.from(valueMap);
    return imgResponse;
  }
}
