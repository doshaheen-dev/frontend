import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class FundDocuments {
  final String type;
  final int status;
  final String message;
  final DocumentsInfo data;

  FundDocuments({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory FundDocuments.fromMap(Map<String, dynamic> json) {
    return FundDocuments(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: DocumentsInfo.fromJson(json["data"]),
    );
  }

  factory FundDocuments.fromJson(Map<String, dynamic> json) {
    return FundDocuments(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: DocumentsInfo.fromJson(json["data"]),
    );
  }

  static FundDocuments from(Map valueMap) {
    return FundDocuments(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: DocumentsInfo.fromJson(valueMap["data"]),
    );
  }
}

class DocumentsInfo {
  final List<DocumentsData> records;

  DocumentsInfo(
    this.records,
  );

  factory DocumentsInfo.fromMap(Map<String, dynamic> json) {
    List<DocumentsData> documentsData = [];
    if (json['records'] != null) {
      for (Map map in json['records']) {
        documentsData.add(DocumentsData.fromMap(map));
      }
    }
    return DocumentsInfo(
      documentsData,
    );
  }

  factory DocumentsInfo.fromJson(Map<String, dynamic> json) {
    List<DocumentsData> documentsData = [];
    if (json['records'] != null) {
      for (Map map in json['records']) {
        documentsData.add(DocumentsData.fromMap(map));
      }
    }
    return DocumentsInfo(
      documentsData,
    );
  }
}

class DocumentsData {
  final String kycDocName;
  final int fundTxnId;
  final int fundKycId;
  final String fundKycDocPath;

  DocumentsData(
      this.kycDocName, this.fundTxnId, this.fundKycId, this.fundKycDocPath);

  factory DocumentsData.fromMap(Map<String, dynamic> json) {
    return DocumentsData(json["kyc_doc_name"], json["fund_txn_id"],
        json["fund_kyc_id"], json["fund_kyc_doc_path"]);
  }
  factory DocumentsData.fromJson(Map<String, dynamic> json) {
    return DocumentsData(json["kyc_doc_name"], json["fund_txn_id"],
        json["fund_kyc_id"], json["fund_kyc_doc_path"]);
  }
}
