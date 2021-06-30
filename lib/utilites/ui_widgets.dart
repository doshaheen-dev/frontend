import 'package:flutter/material.dart';

import 'app_colors.dart';

BoxDecoration appColorButton() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(
      const Radius.circular(15.0),
    ),
    gradient: LinearGradient(
      colors: [kDarkOrange, kLightOrange],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
    ),
  );
}
