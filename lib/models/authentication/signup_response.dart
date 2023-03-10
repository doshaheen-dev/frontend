import 'package:json_annotation/json_annotation.dart';
import '../../utils/crypt_utils.dart';

@JsonSerializable(nullable: false)
class User {
  final String type;
  final int status;
  final String message;
  final ResponseData data;

  User({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  static User from(Map valueMap) {
    return User(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ResponseData.fromJson(valueMap["data"]),
    );
  }
}

class ResponseData {
  final String token;
  final int id;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final String emailId;
  final String countryCode;
  final String address;
  final String hearAboutUs;
  final String referralName;
  final int slotId;
  final String productIds;
  final String userType;
  final String mobileNoVerifiedTimestamp;
  final int mobileNoVerified;
  final String profileImagePath;
  final String designation;
  final String companyName;
  final int emailVerified;

  ResponseData(
    this.token,
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.emailId,
    this.countryCode,
    this.address,
    this.hearAboutUs,
    this.referralName,
    this.slotId,
    this.productIds,
    this.userType,
    this.mobileNoVerifiedTimestamp,
    this.mobileNoVerified,
    this.profileImagePath,
    this.designation,
    this.companyName,
    this.emailVerified,
  );

  Map<String, dynamic> toJson() => {
        "token": this.token,
        "id": this.id,
        "first_name": this.firstName,
        "last_name": this.lastName,
        "mobile_no": this.mobileNo,
        "email_id": this.emailId,
        "country_name": this.countryCode,
        "address": this.address,
        "hear_about_us": this.hearAboutUs,
        "referral_name": this.referralName,
        "slot_id": this.slotId,
        "product_ids": this.productIds,
        "user_type": this.userType,
        "mobile_no_verified_timestamp": this.mobileNoVerifiedTimestamp,
        "mobile_no_verified": this.mobileNoVerified,
      };

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    return ResponseData(
      json['token'],
      json['id'],
      CryptUtils.decryption(json['first_name']),
      CryptUtils.decryption(json['last_name']),
      CryptUtils.decryption(json['mobile_no']),
      CryptUtils.decryption(json['email_id']),
      json['country_name'],
      json['address'],
      json['hear_about_us'],
      json['referral_name'],
      json['slot_id'],
      json['product_ids'],
      json['user_type'],
      json['mobile_no_verified_timestamp'],
      json['mobile_no_verified'],
      json['user_profile_image_path'],
      json['designation'],
      json['company_name'],
      json['email_verified'],
    );
  }
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      json['token'],
      json['id'],
      CryptUtils.decryption(json['first_name']),
      CryptUtils.decryption(json['last_name']),
      CryptUtils.decryption(json['mobile_no']),
      CryptUtils.decryption(json['email_id']),
      json['country_name'],
      json['address'],
      json['hear_about_us'],
      json['referral_name'],
      json['slot_id'],
      json['product_ids'],
      json['user_type'],
      json['mobile_no_verified_timestamp'],
      json['mobile_no_verified'],
      json['user_profile_image_path'],
      json['designation'],
      json['company_name'],
      json['email_verified'],
    );
  }
}
