import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class VerifyPhoneNumber {
  final String type;
  final int status;
  final String message;
  final PhoneData data;

  VerifyPhoneNumber({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory VerifyPhoneNumber.fromMap(Map<String, dynamic> json) {
    return VerifyPhoneNumber(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: PhoneData.fromJson(json["data"]),
    );
  }

  factory VerifyPhoneNumber.fromJson(Map<String, dynamic> json) {
    return VerifyPhoneNumber(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: PhoneData.fromJson(json["data"]),
    );
  }

  static VerifyPhoneNumber from(Map valueMap) {
    return VerifyPhoneNumber(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: PhoneData.fromJson(valueMap["data"]),
    );
  }
}

class PhoneData {
  final int id;

  PhoneData({this.id});

  factory PhoneData.fromMap(Map<String, dynamic> json) {
    return PhoneData(
      id: json["id"],
    );
  }

  factory PhoneData.fromJson(Map<String, dynamic> json) {
    return PhoneData(
      id: json["id"],
    );
  }
}
