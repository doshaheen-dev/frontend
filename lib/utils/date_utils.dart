import 'package:intl/intl.dart';

class DateUtilsExt {
  static String currentDateWithFormat(String format) {
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(DateTime.now());
  }

  static String dateFromUTCToLocal(String dateString) {
    var strToDateTime = DateTime.parse(dateString);
    final convertLocal = strToDateTime.toLocal();
    var newFormat = DateFormat("dd/MM/yyyy");
    String updatedDt = newFormat.format(convertLocal);
    return updatedDt;
  }
}
