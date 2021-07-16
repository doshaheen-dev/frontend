import 'package:acc/models/country/country.dart';
import 'package:flutter/foundation.dart';
import '../services/country_service.dart';

class Countries with ChangeNotifier {
  List<CountryInfo> _countries = [];

  List<CountryInfo> get countries {
    return [..._countries];
  }

  Future<void> fetchAndSetCountries() async {
    final List<CountryInfo> loadedCountries = [];
    final Country extractedData = await CountryService.fetchCountries();
    if (extractedData == null) {
      return;
    }
    extractedData.data.options.forEach((option) {
      loadedCountries.add(CountryInfo(
        option.countryCode,
        option.countryName,
        option.countryAbbr,
      ));
    });

    _countries = loadedCountries.toList();
    notifyListeners();
  }
}

class CountryInfo {
  final int id;
  final String name;
  final String abbreviation;

  CountryInfo(this.id, this.name, this.abbreviation);
}
