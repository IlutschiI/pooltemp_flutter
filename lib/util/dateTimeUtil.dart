import 'package:intl/intl.dart';

class DateTimeUtil {
  static final DateFormat ddMMyyyy = DateFormat("dd.MM.yyyy");
  static final DateFormat ddMMyy = DateFormat("dd.MM.yy");

  static String format(DateTime dateTime, {DateFormat? dateFormat}) {
    dateFormat = dateFormat ?? ddMMyyyy;
    return dateFormat.format(dateTime);
  }
}
