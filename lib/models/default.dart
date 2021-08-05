import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Default {
  final String type;
  final int status;
  final String message;

  Default({
    this.type,
    this.status,
    this.message,
  });

  factory Default.fromMap(Map<String, dynamic> json) {
    return Default(
      type: json["type"],
      status: json["status"],
      message: json["message"],
    );
  }

  factory Default.fromJson(Map<String, dynamic> json) {
    return Default(
      type: json["type"],
      status: json["status"],
      message: json["message"],
    );
  }

  static Default from(Map valueMap) {
    return Default(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
    );
  }
}
