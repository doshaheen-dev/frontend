import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false, explicitToJson: true)
class InvestorSignupRequestModel {
  InvestorSignupRequestModel._privateConstructor();

  static final InvestorSignupRequestModel _instance =
      InvestorSignupRequestModel._privateConstructor();

  static InvestorSignupRequestModel get instance => _instance;

  int id;
  String firstName;
  String middleName;
  String lastName;
  String emailId;
  String countryCode;
  String address;
  String hearAboutUs;
  String referralName;
  int slotId;
  List<int> productIds;
  String userType;
  String designation;
  String companyName;

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "first_name": this.firstName,
        "middle_name": this.middleName,
        "last_name": this.lastName,
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
      };
}
