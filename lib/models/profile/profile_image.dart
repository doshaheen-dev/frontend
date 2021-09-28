import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class UploadProfileImage {
  final String type;
  final int status;
  final String message;
  final ResponseData data;

  UploadProfileImage({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory UploadProfileImage.fromMap(Map<String, dynamic> json) {
    return UploadProfileImage(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  factory UploadProfileImage.fromJson(Map<String, dynamic> json) {
    return UploadProfileImage(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  static UploadProfileImage from(Map valueMap) {
    return UploadProfileImage(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ResponseData.fromJson(valueMap["data"]),
    );
  }
}

class ResponseData {
  final String userProfileImagePath;

  ResponseData(this.userProfileImagePath);

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    return ResponseData(json['user_profile_image_path']);
  }
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(json['user_profile_image_path']);
  }
}
