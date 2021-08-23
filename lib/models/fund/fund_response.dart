import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Fund {
  final String type;
  final int status;
  final String message;
  final FundData data;

  Fund({
    this.type,
    this.status,
    this.message,
    this.data,
  });

  factory Fund.fromMap(Map<String, dynamic> json) {
    return Fund(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: FundData.fromJson(json["data"]),
    );
  }

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: FundData.fromJson(json["data"]),
    );
  }

  static Fund from(Map valueMap) {
    return Fund(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: FundData.fromJson(valueMap["data"]),
    );
  }
}

class FundData {
  final List<OptionsData> options;
  final int pageNo;
  final int totalCount;

  FundData(
    this.options,
    this.pageNo,
    this.totalCount,
  );

  factory FundData.fromMap(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['option'] != null) {
      for (Map map in json['option']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return FundData(
      optionsData,
      json['pageNo'],
      json['totalCount'],
    );
  }

  factory FundData.fromJson(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['option'] != null) {
      for (Map map in json['option']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return FundData(
      optionsData,
      json['pageNo'],
      json['totalCount'],
    );
  }
}

class OptionsData {
  final int fundTxnId;
  final int userId;
  final int productId;
  final int slotId;
  final String fundSponsorName;
  final String fundName;
  final String fundCountryCode;
  final int fundCityId;
  final int fundRegulated;
  final String fundRegulatorName;
  final String fundInvstmtObj;
  final int fundExistVal;
  final int fundNewVal;
  final String fundWebsite;
  final String fundLogo;
  final String fundStatus;
  final String fundInternalApproved;
  final String termsAgreedTimestamp;
  final String fundRange;
  final String minPerInvestor;
  final String countryName;
  final String cityName;
  final String fundsRemarks;

  OptionsData(
    this.fundTxnId,
    this.userId,
    this.productId,
    this.slotId,
    this.fundSponsorName,
    this.fundName,
    this.fundCountryCode,
    this.fundCityId,
    this.fundRegulated,
    this.fundRegulatorName,
    this.fundInvstmtObj,
    this.fundExistVal,
    this.fundNewVal,
    this.fundWebsite,
    this.fundLogo,
    this.fundStatus,
    this.fundInternalApproved,
    this.termsAgreedTimestamp,
    this.fundRange,
    this.minPerInvestor,
    this.countryName,
    this.cityName,
    this.fundsRemarks,
  );

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(
      json["fund_txn_id"],
      json["user_id"],
      json["product_id"],
      json["slot_id"],
      json["fund_sponsor_name"],
      json["fund_name"],
      json["fund_country_code"],
      json["fund_city_id"],
      json["fund_regulated"],
      json["fund_regulator_name"],
      json["fund_invstmt_obj"],
      json["fund_exist_val"],
      json["fund_new_val"],
      json["fund_website"],
      json["fund_logo"],
      json["fund_status"],
      json["fund_internal_approved"],
      json["fund_terms_agreed_date_time"],
      json["fund_range"],
      json["min_per_investor"],
      json["country_name"],
      json["city_name"],
      json['fund_internal_approved_remarks'],
    );
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(
      json["fund_txn_id"],
      json["user_id"],
      json["product_id"],
      json["slot_id"],
      json["fund_sponsor_name"],
      json["fund_name"],
      json["fund_country_code"],
      json["fund_city_id"],
      json["fund_regulated"],
      json["fund_regulator_name"],
      json["fund_invstmt_obj"],
      json["fund_exist_val"],
      json["fund_new_val"],
      json["fund_website"],
      json["fund_logo"],
      json["fund_status"],
      json["fund_internal_approved"],
      json["fund_terms_agreed_date_time"],
      json["fund_range"],
      json["min_per_investor"],
      json["country_name"],
      json["city_name"],
      json['fund_internal_approved_remarks'],
    );
  }
}
