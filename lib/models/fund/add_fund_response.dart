import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class AddFundResponse {
  final String type;
  final int status;
  final String message;
  final ResponseData data;

  AddFundResponse({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory AddFundResponse.fromMap(Map<String, dynamic> json) {
    return AddFundResponse(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  factory AddFundResponse.fromJson(Map<String, dynamic> json) {
    return AddFundResponse(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  static AddFundResponse from(Map valueMap) {
    return AddFundResponse(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ResponseData.fromJson(valueMap["data"]),
    );
  }
}

class ResponseData {
  final int fundTxnId;

  ResponseData(this.fundTxnId);

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    return ResponseData(json['fund_txn_id']);
  }
  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(json['fund_txn_id']);
  }
}
