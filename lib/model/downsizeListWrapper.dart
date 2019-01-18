import 'package:pooltemp_flutter/model/temperature.dart';

class DownsizeListWrapper {
  List<Temperature> temperatures;
  DateTime startDate;
  DateTime endDate;

  DownsizeListWrapper(this.temperatures, this.startDate, this.endDate);
}
