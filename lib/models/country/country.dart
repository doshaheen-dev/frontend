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

class OptionsData {
  final int countryCode;
  final String countryPhCode;
  final String countryName;
  final String currencyCode;
  final String countryAbbr;

  OptionsData(
    this.countryCode,
    this.countryPhCode,
    this.countryName,
    this.currencyCode,
    this.countryAbbr,
  );

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(
      json['country_code'],
      json['country_ph_code'],
      json['country_name'],
      json['currency_code'],
      json['country_abbr'],
    );
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(
      json['country_code'],
      json['country_ph_code'],
      json['country_name'],
      json['currency_code'],
      json['country_abbr'],
    );
  }
}
