class Funds {
  String type;
  int status;
  String message;
  Data data;

  Funds({this.type, this.status, this.message, this.data});

  Funds.from(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Option> option;
  int pageNo;
  int totalCount;

  Data({this.option, this.pageNo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['option'] != null) {
      option = [];
      json['option'].forEach((v) {
        option.add(new Option.fromJson(v));
      });
    }
    pageNo = json['pageNo'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.option != null) {
      data['option'] = this.option.map((v) => v.toJson()).toList();
    }
    data['pageNo'] = this.pageNo;
    data['totalCount'] = this.totalCount;
    return data;
  }
}

class Option {
  int fundTxnId;
  int userId;
  int productId;
  int slotId;
  String fundSponsorName;
  String fundTermsAgreedDateTime;
  String fundName;
  int fundCountryId;
  int fundCityId;
  int fundRegulated;
  String fundRegulatorName;
  String fundInvstmtObj;
  String fundExistVal;
  String fundNewVal;
  String fundWebsite;
  String fundLogo;
  String fundStatus;
  String fundInternalApproved;
  String city_name;
  String country_name;
  String minimumInvestment;
  String product_name;

  Option(
      {this.fundTxnId,
      this.userId,
      this.productId,
      this.slotId,
      this.fundSponsorName,
      this.fundTermsAgreedDateTime,
      this.fundName,
      this.fundCountryId,
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
      this.city_name,
      this.country_name,
      this.minimumInvestment,
      this.product_name});

  Option.fromJson(Map<String, dynamic> json) {
    fundTxnId = json['fund_txn_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    slotId = json['slot_id'];
    fundSponsorName = json['fund_sponsor_name'];
    fundTermsAgreedDateTime = json['fund_terms_agreed_date_time'];
    fundName = json['fund_name'];
    fundCountryId = json['fund_country_id'];
    fundCityId = json['fund_city_id'];
    fundRegulated = json['fund_regulated'];
    fundRegulatorName = json['fund_regulator_name'];
    fundInvstmtObj = json['fund_invstmt_obj'];
    fundExistVal = json['fund_exist_val'];
    fundNewVal = json['fund_new_val'];
    fundWebsite = json['fund_website'];
    fundLogo = json['fund_logo'];
    fundStatus = json['fund_status'];
    fundInternalApproved = json['fund_internal_approved'];
    city_name = json['city_name'];
    country_name = json['country_name'];
    minimumInvestment = json['min_per_investor'];
    product_name = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fund_txn_id'] = this.fundTxnId;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['slot_id'] = this.slotId;
    data['fund_sponsor_name'] = this.fundSponsorName;
    data['fund_terms_agreed_date_time'] = this.fundTermsAgreedDateTime;
    data['fund_name'] = this.fundName;
    data['fund_country_id'] = this.fundCountryId;
    data['fund_city_id'] = this.fundCityId;
    data['fund_regulated'] = this.fundRegulated;
    data['fund_regulator_name'] = this.fundRegulatorName;
    data['fund_invstmt_obj'] = this.fundInvstmtObj;
    data['fund_exist_val'] = this.fundExistVal;
    data['fund_new_val'] = this.fundNewVal;
    data['fund_website'] = this.fundWebsite;
    data['fund_logo'] = this.fundLogo;
    data['fund_status'] = this.fundStatus;
    data['fund_internal_approved'] = this.fundInternalApproved;
    data['city_name'] = this.city_name;
    data['country_name'] = this.country_name;
    data['min_per_investor'] = this.minimumInvestment;
    data['product_name'] = this.product_name;
    return data;
  }
}
