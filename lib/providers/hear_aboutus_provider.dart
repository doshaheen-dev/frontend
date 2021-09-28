import 'package:acc/models/investor/hearaboutus.dart';
import 'package:acc/services/InvestmentInfoService.dart';
import 'package:flutter/foundation.dart';

class HearAboutUsProvider with ChangeNotifier {
  List<Options> _foundUs = [];

  List<Options> get data {
    return [..._foundUs];
  }

  Future<void> fetchAppPlatforms() async {
    clear();
    final List<Options> loadedFoundUs = [];
    final HearAboutUs extractedData =
        await InvestmentInfoService.hearAboutUsInfo();
    if (extractedData == null) {
      return;
    }
    loadedFoundUs.addAll(extractedData.data.options);

    _foundUs = loadedFoundUs.toList();
    notifyListeners();
  }

  void clear() {
    _foundUs = [];
    notifyListeners();
  }
}
