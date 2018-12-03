import 'package:charts_flutter/flutter.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class TemperatureSeriesConverter{

  List<Series<Temperature, DateTime>> convert(
      List<Temperature> value) {
    return [
      new Series(
          id: "temp",
          data: value,
          domainFn: (Temperature temp, _) => temp.time,
          measureFn: (Temperature temperature, _) => temperature.temperature)
    ];
  }

}