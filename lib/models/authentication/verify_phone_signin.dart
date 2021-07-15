import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class SignUpInvestor {
  final String type;
  final int status;
  final String message;
  final SignUpData data;

  SignUpInvestor({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory SignUpInvestor.fromMap(Map<String, dynamic> json) {
    return SignUpInvestor(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: SignUpData.fromJson(json["data"]),
    );
  }

  factory SignUpInvestor.fromJson(Map<String, dynamic> json) {
    return SignUpInvestor(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: SignUpData.fromJson(json["data"]),
    );
  }

  static SignUpInvestor from(Map valueMap) {
    return SignUpInvestor(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: SignUpData.fromJson(valueMap["data"]),
    );
  }
}

class SignUpData {
  // final String verificationId;

  SignUpData();

  factory SignUpData.fromMap(Map<String, dynamic> json) {
    return SignUpData();
  }

  factory SignUpData.fromJson(Map<String, dynamic> json) {
    return SignUpData();
  }
}

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

@JsonSerializable(nullable: false)
class UserSignIn {
  final String type;
  final int status;
  final String message;
  final UserData data;
  // final String verificationId;

  UserSignIn({
    this.type,
    this.status,
    this.message,
    this.data,
    //this.verificationId,
  });

  factory UserSignIn.fromMap(Map<String, dynamic> json) {
    return UserSignIn(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: UserData.fromJson(json["data"]),
    );
  }

  factory UserSignIn.fromJson(Map<String, dynamic> json) {
    return UserSignIn(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: UserData.fromJson(json["data"]),
    );
  }

  static UserSignIn from(Map valueMap) {
    return UserSignIn(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: UserData.fromJson(valueMap["data"]),
    );
  }
}

class UserData {
  final String token;
  final String userId;
  final String firstName;
  final String middleName;
  final String lastName;
  final String mobileNo;
  final String emaiId;
  final String userType;
  final String profileImageUrl;

  UserData({
    this.token,
    this.userId,
    this.firstName,
    this.middleName,
    this.lastName,
    this.mobileNo,
    this.emaiId,
    this.userType,
    this.profileImageUrl,
  });

  factory UserData.fromMap(Map<String, dynamic> json) {
    return UserData(
      token: json["token"],
      userId: json["user_id"],
      firstName: json["first_name"],
      middleName: json["middle_name"],
      lastName: json["last_name"],
      mobileNo: json["mobile_no"],
      emaiId: json["email_id"],
      userType: json["user_type"],
      profileImageUrl: json["profile_image_url"],
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      token: json["token"],
      userId: json["user_id"],
      firstName: json["first_name"],
      middleName: json["middle_name"],
      lastName: json["last_name"],
      mobileNo: json["mobile_no"],
      emaiId: json["email_id"],
      userType: json["user_type"],
      profileImageUrl: json["profile_image_url"],
    );
  }
}

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
