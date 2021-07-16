import 'package:acc/models/city/city.dart';
import 'package:flutter/foundation.dart';
import '../services/city_service.dart';

class Cities with ChangeNotifier {
  List<CityInfo> _cities = [];

  List<CityInfo> get cities {
    return [..._cities];
  }

  Future<void> fetchAndSetCities() async {
    clear();
    final List<CityInfo> loadedCities = [];
    final City extractedData = await CityService.fetchCities('');
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      loadedCities.add(CityInfo(
        option.cityId,
        option.cityName,
      ));
    });

    _cities = loadedCities.toList();
    notifyListeners();
  }

  Future<void> fetchAndSetCitiesByCountry(String countryCode) async {
    clear();
    final List<CityInfo> loadedCities = [];
    final City extractedData = await CityService.fetchCities(countryCode);
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      loadedCities.add(CityInfo(
        option.cityId,
        option.cityName,
      ));
    });

    _cities = loadedCities.toList();
    notifyListeners();
  }

  void clear() {
    _cities = [];
    notifyListeners();
  }
}

class CityInfo {
  final int id;
  final String name;

  CityInfo(this.id, this.name);
}
