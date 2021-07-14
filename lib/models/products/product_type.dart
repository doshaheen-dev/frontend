import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class ProductType {
  final String type;
  final int status;
  final String message;
  final ProductTypeData data;

  ProductType({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory ProductType.fromMap(Map<String, dynamic> json) {
    return ProductType(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ProductTypeData.fromJson(json["data"]),
    );
  }

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: ProductTypeData.fromJson(json["data"]),
    );
  }

  static ProductType from(Map valueMap) {
    return ProductType(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: ProductTypeData.fromJson(valueMap["data"]),
    );
  }
}

class ProductTypeData {
  final List<OptionsData> options;

  ProductTypeData(this.options);

  factory ProductTypeData.fromMap(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return ProductTypeData(optionsData);
  }

  factory ProductTypeData.fromJson(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return ProductTypeData(optionsData);
  }
}

class OptionsData {
  final int id;
  final String name;
  final String desc;

  OptionsData(this.id, this.name, this.desc);

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(json['id'], json['name'], json['desc']);
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(json['id'], json['name'], json['desc']);
  }
}
