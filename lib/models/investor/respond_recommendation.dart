class RespondRecommendation {
  String type;
  int status;
  String message;
  Data data;

  RespondRecommendation({this.type, this.status, this.message, this.data});

  RespondRecommendation.from(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    message = json['message'];
    // data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  RespondRecommendation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    message = json['message'];
    // data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data.toJson();
    // }
    return data;
  }
}

class Data {
  //int fundTxnId;

  // Data({this.fundTxnId});

  // Data.fromJson(Map<String, dynamic> json) {
  //   fundTxnId = json['fund_txn_id'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['fund_txn_id'] = this.fundTxnId;
  //   return data;
  // }
}
