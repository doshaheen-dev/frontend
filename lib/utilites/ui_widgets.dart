import 'package:flutter/material.dart';

import 'app_colors.dart';

BoxDecoration appColorButton(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(
      const Radius.circular(15.0),
    ),
    gradient: LinearGradient(
      colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor],
      begin: FractionalOffset.centerLeft,
      end: FractionalOffset.centerRight,
    ),
  );
}

void showSnackBar(BuildContext _context, String message) {
  final snackBar = SnackBar(
    duration: Duration(seconds: 2),
    content: Text(message),
    // action: SnackBarAction(
    //   label: 'Ok',
    //   onPressed: () {},
    // ),
  );

  ScaffoldMessenger.of(_context).showSnackBar(snackBar);
}

void showSnackBarWithoutButton(BuildContext _context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(_context).showSnackBar(snackBar);
}
