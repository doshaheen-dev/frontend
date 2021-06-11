import 'package:flutter/cupertino.dart';

class CategoriesModel {
  String name;
  String image;
  String detail;
  Function onTap;
  CategoriesModel(
      {@required this.name, @required this.image, @required this.detail , this.onTap});
}
