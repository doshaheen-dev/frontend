import 'package:acc/models/investor/recommendation.dart';
import 'package:acc/services/investor_home_service.dart';
import 'package:flutter/foundation.dart';

class InvestorHome with ChangeNotifier {
  List<Recommended> recommended;

  Future<void> fetchAndSetRecommendations(String token) async {
    final List<Recommended> loadedRecommendations = [];
    final Recommendations extractedData =
        await InvestorHomeService.fetchRecommendation(token);
    if (extractedData == null) {
      return;
    }
    extractedData.data.option.forEach((option) {
      loadedRecommendations.add(Recommended(
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
}

class Recommended {
  final String fundName;
  final String fundLogo;
  final int fundExistVal;
  final int fundNewVal;
  final int fundTxnId;
  final String fundSponsorName;
  final int fundRegulated;
  final String fundRegulatorName;
  final String fundWebsite;

  Recommended(
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
