import 'package:pooltemp_flutter/model/downsizeListWrapper.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureListService {

  static List<Temperature> downsizeList(DownsizeListWrapper wrapper){
    var list = wrapper.temperatures;
    var result = new List<Temperature>();
    if (wrapper.startDate != null) {
      list = list.where((t) => t.time.isAfter(wrapper.startDate)).toList();
    }
    if (wrapper.endDate != null) {
      list = list.where((t) => t.time.isBefore(wrapper.endDate)).toList();
    }
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