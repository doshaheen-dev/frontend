import 'package:acc/models/fund/fund_response.dart';
import 'package:acc/screens/fundraiser/dashboard/fundraiser_home.dart';
import 'package:acc/services/fund_service.dart';
import 'package:flutter/foundation.dart';

class FundProvider with ChangeNotifier {
  List<SubmittedFunds> _funds = [];

  List<SubmittedFunds> get funds {
    return [..._funds];
  }

  Future<void> fetchAndSetFunds() async {
    final List<SubmittedFunds> loadedFunds = [];
    final Fund extractedData = await FundService.fetchFunds();
    print('fund: ${extractedData.data.length}');
    if (extractedData == null) {
      return;
    }
    extractedData.data.forEach((option) {
      loadedFunds.add(SubmittedFunds(option.fundName, option.fundStatus, 
      option.termsAgreedTimestamp, option.fundLogo, '${option.fundCityId}, ${option.fundCountryCode}', 
      '${option.slotId}', option.fundInvstmtObj));
    });

    _funds = loadedFunds.toList();
    notifyListeners();
  }
}