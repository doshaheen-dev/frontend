import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class UpdateBasicDetails {
  final String type;
  final int status;
  final String message;
  final ResponseData data;

  UpdateBasicDetails({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory UpdateBasicDetails.fromMap(Map<String, dynamic> json) {
    return UpdateBasicDetails(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  factory UpdateBasicDetails.fromJson(Map<String, dynamic> json) {
    return UpdateBasicDetails(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  static UpdateBasicDetails from(Map valueMap) {
    return UpdateBasicDetails(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ResponseData.fromJson(valueMap["data"]),
    );
  }
}

class ResponseData {
  final int id;

  ResponseData(this.id);

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    return ResponseData(json['id']);
  }
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(json['id']);
  }
}
