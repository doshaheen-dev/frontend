import 'package:acc/utils/crypt_utils.dart';
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

  UserSignIn({
    this.type,
    this.status,
    this.message,
    this.data,
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

@JsonSerializable(nullable: false, explicitToJson: true)
class UserData {
  String token;
  String firstName;
  String middleName;
  String lastName;
  String mobileNo;
  String emailId;
  String userType;

  UserData._privateConstructor();

  static final UserData _instance = UserData._privateConstructor();

  static UserData get instance => _instance;

  UserData(this.token, this.firstName, this.middleName, this.lastName,
      this.mobileNo, this.emailId, this.userType);

  Map<String, dynamic> toJson() => {
        "token": this.token,
        "first_name": this.firstName,
        "middle_name": this.middleName,
        "last_name": this.lastName,
        "email_id": this.emailId,
        "mobile_no": this.mobileNo,
        "user_type": this.userType,
      };

  factory UserData.fromMap(Map<String, dynamic> json) {
    return UserData(
        json['token'],
        CryptUtils.decryption(json['first_name']),
        CryptUtils.decryption(json['middle_name']),
        CryptUtils.decryption(json['last_name']),
        CryptUtils.decryption(json['mobile_no']),
        CryptUtils.decryption(json['email_id']),
        json['user_type']);
  }
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        json['token'],
        CryptUtils.decryption(json['first_name']),
        CryptUtils.decryption(json['middle_name']),
        CryptUtils.decryption(json['last_name']),
        CryptUtils.decryption(json['mobile_no']),
        CryptUtils.decryption(json['email_id']),
        json['user_type']);
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
