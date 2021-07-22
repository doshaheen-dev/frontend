import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class KYCDocument {
  final String type;
  final int status;
  final String message;
  final ResponseData data;

  KYCDocument({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory KYCDocument.fromMap(Map<String, dynamic> json) {
    return KYCDocument(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  factory KYCDocument.fromJson(Map<String, dynamic> json) {
    return KYCDocument(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ResponseData.fromJson(json["data"]),
    );
  }

  static KYCDocument from(Map valueMap) {
    return KYCDocument(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ResponseData.fromJson(valueMap["data"]),
    );
  }
}

class ResponseData {
  final List<OptionsData> options;

  ResponseData(this.options);

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return ResponseData(optionsData);
  }

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return ResponseData(optionsData);
  }
}

class OptionsData {
  final int kycId;
  final String kycDocName;
  final String kycDocDesc;

  OptionsData(
    this.kycId,
    this.kycDocName,
    this.kycDocDesc,
  );

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(
      json['kyc_id'],
      json['kyc_doc_name'],
      json['kyc_doc_desc'],
    );
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(
      json['kyc_id'],
      json['kyc_doc_name'],
      json['kyc_doc_desc'],
    );
  }
}
