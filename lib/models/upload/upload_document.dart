import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class UploadDocument {
  final String type;
  final int status;
  final String message;
  final ResponseData data;

  UploadDocument({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory UploadDocument.fromMap(Map<String, dynamic> json) {
    return UploadDocument(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  factory UploadDocument.fromJson(Map<String, dynamic> json) {
    return UploadDocument(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  static UploadDocument from(Map valueMap) {
    return UploadDocument(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ResponseData.fromJson(valueMap["data"]),
    );
  }
}

class ResponseData {
  final String fundKYCDocPath;

  ResponseData(this.fundKYCDocPath);

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    return ResponseData(json['fund_kyc_doc_path']);
  }
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(json['fund_kyc_doc_path']);
  }
}
