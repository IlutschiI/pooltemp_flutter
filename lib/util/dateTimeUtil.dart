import 'package:intl/intl.dart';

class DateTimeUtil {

  static final DateFormat dateFormat=DateFormat("dd.MM.yyyy");

  static String format(DateTime dateTime){
    return dateFormat.format(dateTime);
  }

}