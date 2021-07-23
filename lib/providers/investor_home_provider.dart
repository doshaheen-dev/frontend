import 'package:acc/models/investor/recommendation.dart';
import 'package:acc/models/investor/funds.dart';

import 'package:acc/services/investor_home_service.dart';
import 'package:flutter/foundation.dart';

class InvestorHome with ChangeNotifier {
  List<FundsInfo> recommended;

  var interestedFundsData;

  Future<void> fetchAndSetRecommendations(String token, int pageNo) async {
    final List<FundsInfo> loadedRecommendations = [];
    final Recommendations extractedData =
        await InvestorHomeService.fetchRecommendation(token, pageNo);
    if (extractedData == null) {
      return;
    }
    extractedData.data.option.forEach((option) {
      loadedRecommendations.add(FundsInfo(
          option.fundName,
          option.fundLogo,
          option.fundExistVal,
          option.fundNewVal,
          option.fundTxnId,
          option.fundSponsorName,
          option.fundRegulated,
          option.fundRegulatorName,
          option.fundWebsite));
    });

    recommended = loadedRecommendations.toList();
    notifyListeners();
  }

  Future<void> fetchAndSetInterestedFunds(String token, int pageNo) async {
    final List<FundsInfo> loadedFunds = [];
    final Funds extractedData =
        await InvestorHomeService.fetchInterestedFunds(token, pageNo);
    if (extractedData == null) {
      return;
    }
    extractedData.data.option.forEach((option) {
      loadedFunds.add(FundsInfo(
          option.fundName,
          option.fundLogo,
          option.fundExistVal,
          option.fundNewVal,
          option.fundTxnId,
          option.fundSponsorName,
          option.fundRegulated,
          option.fundRegulatorName,
          option.fundWebsite));
    });

    interestedFundsData = loadedFunds.toList();
    notifyListeners();
  }
}

class FundsInfo {
  final String fundName;
  final String fundLogo;
  final int fundExistVal;
  final int fundNewVal;
  final int fundTxnId;
  final String fundSponsorName;
  final int fundRegulated;
  final String fundRegulatorName;
  final String fundWebsite;

  FundsInfo(
      this.fundName,
      this.fundLogo,
      this.fundExistVal,
      this.fundNewVal,
      this.fundTxnId,
      this.fundSponsorName,
      this.fundRegulated,
      this.fundRegulatorName,
      this.fundWebsite);
}
