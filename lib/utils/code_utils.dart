import 'package:intl/intl.dart';

class CodeUtils {
  static bool emailValid(String input) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(input);

  static bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  static String currentDateWithFormat(String format) {
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(DateTime.now());
  }
}
