import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class City {
  final String type;
  final int status;
  final String message;
  final CityData data;

  City({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory City.fromMap(Map<String, dynamic> json) {
    return City(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: CityData.fromJson(json["data"]),
    );
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: CityData.fromJson(json["data"]),
    );
  }

  static City from(Map valueMap) {
    return City(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: CityData.fromJson(valueMap["data"]),
    );
  }
}

class CityData {
  final List<OptionsData> options;

  CityData(this.options);

  factory CityData.fromMap(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return CityData(optionsData);
  }

  factory CityData.fromJson(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return CityData(optionsData);
  }
}

class OptionsData {
  final int cityId;
  final String cityName;
  final String countryCode;

  OptionsData(
    this.cityId,
    this.cityName,
    this.countryCode,
  );

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(
      json['city_code'],
      json['city_name'],
      json['country_code'],
    );
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(
      json['city_code'],
      json['city_name'],
      json['country_code'],
    );
  }
}
