import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class VerificationIdSignIn {
  final String type;
  final int status;
  final String message;
  final VerificationData data;

  VerificationIdSignIn({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory VerificationIdSignIn.fromMap(Map<String, dynamic> json) {
    return VerificationIdSignIn(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: VerificationData.fromJson(json["data"]),
    );
  }

  factory VerificationIdSignIn.fromJson(Map<String, dynamic> json) {
    return VerificationIdSignIn(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: VerificationData.fromJson(json["data"]),
    );
  }

  static VerificationIdSignIn from(Map valueMap) {
    return VerificationIdSignIn(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: VerificationData.fromJson(valueMap["data"]),
    );
  }
}

class VerificationData {
  final String verificationId;

  VerificationData({this.verificationId});

  factory VerificationData.fromMap(Map<String, dynamic> json) {
    return VerificationData(
      verificationId: json["verificationId"],
    );
  }

  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      verificationId: json["verificationId"],
    );
  }
}
