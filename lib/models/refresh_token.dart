import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class AppToken {
  final String type;
  final int status;
  final String message;
  final TokenData data;

  AppToken({this.type, this.status, this.message, this.data});

  factory AppToken.fromMap(Map<String, dynamic> json) {
    return AppToken(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: TokenData.fromJson(json["data"]),
    );
  }

  factory AppToken.fromJson(Map<String, dynamic> json) {
    return AppToken(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: TokenData.fromJson(json["data"]),
    );
  }

  static AppToken from(Map valueMap) {
    return AppToken(
        type: valueMap["type"],
        status: valueMap["status"],
        message: valueMap["message"],
        data: TokenData.fromJson(valueMap["data"]));
  }
}

class TokenData {
  final String token;

  TokenData({this.token});

  factory TokenData.fromMap(Map<String, dynamic> json) {
    return TokenData(
      token: json["token"],
    );
  }

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      token: json["token"],
    );
  }
}
