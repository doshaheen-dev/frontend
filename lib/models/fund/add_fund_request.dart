import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class AddFundRequestModel {
  AddFundRequestModel._privateConstructor();

  static final AddFundRequestModel _instance =
      AddFundRequestModel._privateConstructor();

  static AddFundRequestModel get instance => _instance;

  String firstName;
  String lastName;
  String mobileNo;
  String emailId;
  String countryCode;
  String address;
  String hearAboutUs;
  String referralName;
  String slotId;
  String productIds;
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
        "hear_about_us": this.hearAboutUs,
        "referral_name": this.referralName,
        "slot_id": this.slotId,
        "product_ids": this.productIds,
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
    this.hearAboutUs = '';
    this.referralName = '';
    this.slotId = '';
    this.productIds = '';
    this.userType = '';
    this.designation = '';
    this.companyName = '';
    this.verificationId = '';
  }
}
