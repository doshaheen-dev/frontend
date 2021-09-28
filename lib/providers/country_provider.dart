import 'package:acc/models/country/country.dart';
import 'package:flutter/foundation.dart';
import '../services/country_service.dart';

class Countries with ChangeNotifier {
  List<CountryInfo> _countries = [];

  List<CountryInfo> get countries {
    return [..._countries];
  }

  Future<void> fetchAndSetCountries() async {
    clear();
    final List<CountryInfo> loadedCountries = [];
    final Country extractedData = await CountryService.fetchCountries();
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      loadedCountries.add(CountryInfo(option.countryCode, option.countryName,
          option.countryAbbr, option.countryPhCode));
    });

    _countries = loadedCountries.toList();
    notifyListeners();
  }

  void clear() {
    _countries = [];
    notifyListeners();
  }
}

class CountryInfo {
  final int id;
  final String name;
  final String abbreviation;
  final String phoneCode;

  CountryInfo(this.id, this.name, this.abbreviation, this.phoneCode);
}
