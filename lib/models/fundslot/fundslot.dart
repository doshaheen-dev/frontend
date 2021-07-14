import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class FundSlot {
  final String type;
  final int status;
  final String message;
  final FundSlotData data;

  FundSlot({
    this.type,
    this.status,
    this.message,
    this.data,
  });
  factory FundSlot.fromMap(Map<String, dynamic> json) {
    return FundSlot(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: FundSlotData.fromJson(json["data"]),
    );
  }

  factory FundSlot.fromJson(Map<String, dynamic> json) {
    return FundSlot(
      type: json["type"],
      status: json["status"],
      message: json["message"],
      data: FundSlotData.fromJson(json["data"]),
    );
  }

  static FundSlot from(Map valueMap) {
    return FundSlot(
      type: valueMap["type"],
      status: valueMap["status"],
      message: valueMap["message"],
      data: FundSlotData.fromJson(valueMap["data"]),
    );
  }
}

class FundSlotData {
  final List<OptionsData> options;
  final String currencyCode;
  final String currencySymbol;

  FundSlotData(this.options, this.currencyCode, this.currencySymbol);

  factory FundSlotData.fromMap(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return FundSlotData(
        optionsData, json['currencyCode'], json['currencySymbol']);
  }

  factory FundSlotData.fromJson(Map<String, dynamic> json) {
    List<OptionsData> optionsData = [];
    if (json['options'] != null) {
      for (Map map in json['options']) {
        optionsData.add(OptionsData.fromMap(map));
      }
    }
    return FundSlotData(
        optionsData, json['currencyCode'], json['currencySymbol']);
  }
}

class OptionsData {
  final String fromAmount;
  final String toAmount;

  OptionsData(this.fromAmount, this.toAmount);

  factory OptionsData.fromMap(Map<String, dynamic> json) {
    return OptionsData(json['fromAmount'], json['toAmount']);
  }
  factory OptionsData.fromJson(Map<String, dynamic> json) {
    return OptionsData(json['fromAmount'], json['toAmount']);
  }
}
