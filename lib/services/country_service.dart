import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/country/country.dart';

class CountryService {
  // Fetch Countries
  static Future<Country> fetchCountries() async {
    final response =
        await http.get(Uri.parse('${ApiServices.baseUrl}/countries'));
    Map valueMap = jsonDecode(response.body);
    Country countries = Country.from(valueMap);
    return countries;
  }
}
