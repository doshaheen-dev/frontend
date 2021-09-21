import 'package:acc/models/local_countries.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class Country {
  final String type;
  final int status;
  final String message;
  final CountryData data;

  Country({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory Country.fromMap(Map<String, dynamic> json) {
    return Country(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: CountryData.fromJson(json["data"]),
    );
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: CountryData.fromJson(json["data"]),
    );
  }

  static Country from(Map valueMap) {
    return Country(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: CountryData.fromJson(valueMap["data"]),
    );
  }
}

class CountryData {
  final List<OptionsData> options;

  CountryData(this.options);

  factory CountryData.fromMap(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return CountryData(optionsData);
  }

  factory CountryData.fromJson(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return CountryData(optionsData);
  }
}

@JsonSerializable(nullable: false, explicitToJson: true)
class OptionsData {
  int countryCode;
  String countryPhCode;
  String countryName;
  String currencyCode;
  String countryAbbr;
  int maxLength;

  OptionsData._privateConstructor();

  static final OptionsData _instance = OptionsData._privateConstructor();

  static OptionsData get instance => _instance;

  OptionsData get countryInfo => OptionsData(
      this.countryCode,
      this.countryPhCode,
      this.countryName,
      this.currencyCode,
      this.countryAbbr,
      this.maxLength);

  set countryInfo(OptionsData info) {
    this.countryCode = info.countryCode;
    this.countryPhCode = info.countryPhCode;
    this.countryName = info.countryName;
    this.currencyCode = info.currencyCode;
    this.maxLength = info.maxLength;
  }

  OptionsData(this.countryCode, this.countryPhCode, this.countryName,
      this.currencyCode, this.countryAbbr, this.maxLength);

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(
        json['country_code'],
        json['country_ph_code'],
        json['country_name'],
        json['currency_code'],
        json['country_abbr'],
        json['country_ph_max_no_length']);
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(
        json['country_code'],
        json['country_ph_code'],
        json['country_name'],
        json['currency_code'],
        json['country_abbr'],
        json['country_ph_max_no_length']);
  }
}
