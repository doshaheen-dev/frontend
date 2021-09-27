import 'package:acc/models/investor/hearaboutus.dart';
import 'package:acc/services/InvestmentInfoService.dart';
import 'package:flutter/foundation.dart';

class HearAboutUsProvider with ChangeNotifier {
  List<Options> _cities = [];

  List<Options> get data {
    return [..._cities];
  }

  Future<void> fetchAppPlatforms() async {
    clear();
    final List<Options> loadedCities = [];
    final HearAboutUs extractedData =
        await InvestmentInfoService.hearAboutUsInfo();
    if (extractedData == null) {
      return;
    }
    loadedCities.addAll(extractedData.data.options);
    // extractedData.data.options.forEach((option) {
    //   loadedCities.add(HearAboutUs(
    //     option.cityId,
    //     option.cityName,
    //   ));
    // });

    _cities = loadedCities.toList();
    notifyListeners();
  }

  void clear() {
    _cities = [];
    notifyListeners();
  }
}
