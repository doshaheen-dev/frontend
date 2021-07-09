class UpdateBasicDetails {
  final bool type;
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
      data: json["data"],
    );
  }

  factory UpdateBasicDetails.fromJson(Map<String, dynamic> json) {
    return UpdateBasicDetails(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: json["data"],
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
