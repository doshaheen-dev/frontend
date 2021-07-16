import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_service.dart';
import '../models/city/city.dart';

class CityService {
  // Fetch Cities
  static Future<City> fetchCities(String countryCode) async {
    var response;
    if (countryCode == null || countryCode.isEmpty) {
      response = await http.get(Uri.parse('${ApiServices.baseUrl}/cities'));
    } else {
      response = await http
          .get(Uri.parse('${ApiServices.baseUrl}/cities/$countryCode'));
    }
    Map valueMap = jsonDecode(response.body);
    City cities = City.from(valueMap);
    return cities;
  }
}
