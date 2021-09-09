import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class InvestorSignupBasicInfo {
  InvestorSignupBasicInfo._privateConstructor();

  static final InvestorSignupBasicInfo _instance =
      InvestorSignupBasicInfo._privateConstructor();

  static InvestorSignupBasicInfo get instance => _instance;

  String firstName;
  String lastName;
  String mobileNo;
  String emailId;
  String countryCode;
  String address;
  String userType;
  String designation;
  String companyName;
  String verificationId;

  Map<String, dynamic> toJson() => {
        "first_name": this.firstName,
        "last_name": this.lastName,
        "mobile_no": this.mobileNo,
        "email_id": this.emailId,
        "country_code": this.countryCode,
        "address": this.address,
        "user_type": this.userType,
        "designation": this.designation,
        "company_name": this.companyName,
        "verificationId": this.verificationId,
      };

  void clear() {
    this.firstName = '';
    this.lastName = '';
    this.mobileNo = '';
    this.emailId = '';
    this.countryCode = '';
    this.address = '';
    this.userType = '';
    this.designation = '';
    this.companyName = '';
    this.verificationId = '';
  }
}
