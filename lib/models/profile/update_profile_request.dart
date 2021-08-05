import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class UpdateProfileRequestModel {
  UpdateProfileRequestModel._privateConstructor();

  static final UpdateProfileRequestModel _instance =
      UpdateProfileRequestModel._privateConstructor();

  static UpdateProfileRequestModel get instance => _instance;

  String firstName;
  String lastName;
  String countryCode;
  String address;
  String mobileNo;
  String emailId;
  String mobileVerificationId;
  String emailVerificationId;

  Map<String, dynamic> toJson() => {
        "first_name": this.firstName,
        "last_name": this.lastName,
        "country_code": this.countryCode,
        "address": this.address,
        "mobile_no": this.mobileNo,
        "email_id": this.emailId,
        "mobile_verificationId": this.mobileVerificationId,
        "email_verificationId": this.emailVerificationId,
      };

  void clear() {
    this.firstName = '';
    this.lastName = '';
    this.mobileNo = '';
    this.emailId = '';
    this.countryCode = '';
    this.address = '';
    this.mobileVerificationId = '';
    this.emailVerificationId = '';
  }
}
