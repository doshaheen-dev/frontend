import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class VerificationIdSignIn {
  final String type;
  final int status;
  final String message;
  final VerificationData data;
  // final String verificationId;

  VerificationIdSignIn({
    this.type,
    this.status,
    this.message,
    this.data,
    //this.verificationId,
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

// factory VerificationIdSignIn.fromMap(Map<String, dynamic> json) {
//   return VerificationIdSignIn(
//     verificationId: json["verificationId"],
//   );
// }

// factory VerificationIdSignIn.fromJson(Map<String, dynamic> json) {
//   return VerificationIdSignIn(
//     verificationId: json["verificationId"],
//   );
// }

// static VerificationIdSignIn from(Map valueMap) {
//   return VerificationIdSignIn(verificationId: valueMap["verificationId"]);
// }

@JsonSerializable(nullable: false)
class VerifyPhoneNumberSignIn {
  final String type;
  final int status;
  final String message;
  final Data data;

  VerifyPhoneNumberSignIn({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory VerifyPhoneNumberSignIn.fromMap(Map<String, dynamic> json) {
    return VerifyPhoneNumberSignIn(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: Data.fromJson(json["data"]),
    );
  }

  factory VerifyPhoneNumberSignIn.fromJson(Map<String, dynamic> json) {
    return VerifyPhoneNumberSignIn(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: Data.fromJson(json["data"]),
    );
  }

  static VerifyPhoneNumberSignIn from(Map valueMap) {
    return VerifyPhoneNumberSignIn(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: Data.fromJson(valueMap["data"]),
    );
  }
}

class Data {
  final String token;

  Data({this.token});

  factory Data.fromMap(Map<String, dynamic> json) {
    return Data(
      token: json["token"],
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json["token"],
    );
  }
}
