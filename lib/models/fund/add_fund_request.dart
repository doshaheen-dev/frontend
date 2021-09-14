import 'package:json_annotation/json_annotation.dart';
import '../../utils/crypt_utils.dart';

@JsonSerializable(nullable: true, explicitToJson: true)
class AddFundRequestModel {
  AddFundRequestModel._privateConstructor();

  static final AddFundRequestModel _instance =
      AddFundRequestModel._privateConstructor();

  static AddFundRequestModel get instance => _instance;

  int productId;
  int slotId;
  String fundSponsorName;
  String fundName;
  String countryCode;
  int cityId;
  bool fundRegulated;
  String regulatorName;
  String fundInvstmtObj;
  int fundExistVal;
  String fundLogo;
  int fundNewVal;
  String fundWebsite;
  String termsAgreedTimestamp;
  List<DocumentsData> fundKycDocuments;

  Map<String, dynamic> toJson() => {
        "product_id": this.productId,
        "slot_id": this.slotId,
        "fund_sponsor_name": CryptUtils.encryption(this.fundSponsorName),
        "fund_name": this.fundName,
        "fund_country_code": this.countryCode,
        "fund_city_id": this.cityId,
        "fund_regulated": this.fundRegulated,
        "fund_regulator_name": this.regulatorName,
        "fund_invstmt_obj": this.fundInvstmtObj,
        "fund_exist_val": this.fundExistVal,
        "fund_logo": this.fundLogo,
        "fund_new_val": this.fundNewVal,
        "fund_website": this.fundWebsite,
        "fund_terms_agreed_date_time": this.termsAgreedTimestamp,
        "fund_kyc_documents": this.fundKycDocuments,
      };

  void clear() {
    this.productId = null;
    this.slotId = null;
    this.fundSponsorName = '';
    this.fundName = '';
    this.countryCode = '';
    this.cityId = null;
    this.fundRegulated = false;
    this.regulatorName = '';
    this.fundInvstmtObj = '';
    this.fundExistVal = null;
    this.fundLogo = '';
    this.fundNewVal = null;
    this.fundWebsite = '';
    this.termsAgreedTimestamp = '';
    this.fundKycDocuments = [];
  }
}

class DocumentsData {
  final int fundKycId;
  final String fundKycDocPath;

  DocumentsData(
    this.fundKycId,
    this.fundKycDocPath,
  );

  Map<String, dynamic> toJson() => {
        "fund_kyc_id": this.fundKycId,
        "fund_kyc_doc_path": this.fundKycDocPath,
      };
}
