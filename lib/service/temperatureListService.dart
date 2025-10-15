import 'package:pooltemp_flutter/model/downsizeListWrapper.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureListService {

  static List<Temperature> downsizeList(DownsizeListWrapper wrapper){
    var list = wrapper.temperatures;
    var result = <Temperature>[];
    list = list.where((t) => t.time.isAfter(wrapper.startDate)).toList();
      list = list.where((t) => t.time.isBefore(wrapper.endDate)).toList();
      if (list.length > 1000) {
      for (int i = 0; i < list.length; i++) {
        if (i % 100 == 0) {
          result.add(list[i]);
        }
      }
    } else {
      result = list;
    }
    return result;
  }

}