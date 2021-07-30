import 'package:acc/models/fund/fund_response.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/fund_service.dart';
import 'package:acc/utils/crypt_utils.dart';
import 'package:flutter/foundation.dart';

class FundProvider with ChangeNotifier {
  List<SubmittedFunds> _funds = [];

  List<SubmittedFunds> get funds {
    return [..._funds];
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
    // extractedData.data.forEach((option) {
    //   loadedFunds.add(SubmittedFunds(option.fundName, option.fundStatus,
    //   option.termsAgreedTimestamp, option.fundLogo, '${option.fundCityId}, ${option.fundCountryCode}',
    //   '${option.slotId}', option.fundInvstmtObj));
    // });

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
      ));
    });

    _funds = loadedFunds.toList();
    notifyListeners();
  }
}
