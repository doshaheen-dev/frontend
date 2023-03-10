import 'package:acc/models/fund/fund_documents.dart';
import 'package:acc/models/fund/fund_response.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/fund_service.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:flutter/foundation.dart';

class FundProvider with ChangeNotifier {
  List<SubmittedFunds> _funds = [];
  List<DocumentsData> _documentsData = [];

  int totalDocuments = 0;

  List<SubmittedFunds> get funds {
    return [..._funds];
  }

  List<DocumentsData> get documentsData {
    return [..._documentsData];
  }

  Future<void> fetchAndSetFunds(
    int pageNo,
    int pageSize,
  ) async {
    final List<SubmittedFunds> loadedFunds = [];
    final Fund extractedData = await FundService.fetchFunds(pageNo, pageSize);
    if (extractedData == null) {
      return;
    }

    extractedData.data.options.forEach((option) {
      loadedFunds.add(SubmittedFunds(
        option.fundTxnId,
        option.userId,
        option.productId,
        option.slotId,
        CryptUtils.decryption(option.fundSponsorName),
        option.fundName,
        option.countryName,
        option.cityName,
        option.fundRegulated,
        option.fundRegulatorName,
        option.fundInvstmtObj,
        option.fundExistVal,
        option.fundNewVal,
        option.fundWebsite,
        option.fundLogo,
        option.fundInternalApproved,
        option.termsAgreedTimestamp,
        option.minPerInvestor,
        option.fundsRemarks,
      ));
    });

    _funds = loadedFunds.toList();
    notifyListeners();
  }

  Future<void> getFundsDocument(int fundId) async {
    final List<DocumentsData> documentsList = [];
    final FundDocuments extractedData =
        await FundService.getFundsDocument(fundId);
    if (extractedData == null) {
      return;
    }
    totalDocuments = extractedData.data.records.length;

    extractedData.data.records.forEach((record) {
      documentsList.add(DocumentsData(record.kycDocName, record.fundTxnId,
          record.fundKycId, record.fundKycDocPath));
    });

    _documentsData = documentsList.toList();
    notifyListeners();
  }
}
