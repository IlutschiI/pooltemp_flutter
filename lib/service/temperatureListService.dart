import 'package:pooltemp_flutter/model/downsizeListWrapper.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureListService {
  static List<Temperature> downsizeList(DownsizeListWrapper wrapper, {int maxSize = 1000}) {
    var list = wrapper.temperatures;
    var result = <Temperature>[];
    list = list.where((t) => t.time.isAfter(wrapper.startDate)).toList();
    list = list.where((t) => t.time.isBefore(wrapper.endDate)).toList();
    if (list.length > maxSize) {
      final x = (list.length / maxSize);
      for (int i = 0; i < list.length; i++) {
        if (i % x < 1) {
          result.add(list[i]);
        }
      }
    } else {
      result = list;
    }
    print("reduced from ${wrapper.temperatures.length} to ${result.length}");
    return result;
  }
}
