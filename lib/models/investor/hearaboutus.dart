import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class HearAboutUs {
  String type;
  int status;
  String message;
  Data data;

  HearAboutUs({this.type, this.status, this.message, this.data});

  HearAboutUs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Options> options;

  Data({this.options});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String name;
  String imageUrl;

  Options({this.name, this.imageUrl});

  Options.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
