import 'package:intl/intl.dart';

class DateTimeUtil {

  static final DateFormat dateFormat=DateFormat("dd.MM.yyyy");

  static String format(DateTime dateTime){
    if(dateTime==null){
      return "";
    }
    return dateFormat.format(dateTime);
  }

}