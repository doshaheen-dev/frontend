class VerifyPhoneNumber {
  final bool type;
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
      data: json["data"],
    );
  }

  factory VerifyPhoneNumber.fromJson(Map<String, dynamic> json) {
    return VerifyPhoneNumber(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: json["data"],
    );
  }
}

class PhoneData {
  final int id;

  PhoneData(this.id);

  factory PhoneData.fromMap(Map<String, dynamic> json) {
    return PhoneData(json['id']);
  }
  factory PhoneData.fromJson(Map<String, dynamic> json) {
    return PhoneData(json['id']);
  }
}
