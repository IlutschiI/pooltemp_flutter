import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/components/card.dart';
import 'package:pooltemp_flutter/model/temperature.dart';

class LineGraphCard extends StatelessWidget{

  List<Series<Temperature, DateTime>> _series;


  LineGraphCard(this._series);

  @override
  Widget build(BuildContext context) {



    // TODO: implement build
    return CustomCard(
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          //maybe replace this Chart with a selfmade widget, which uses this chart
          child: TimeSeriesChart(
            _series,
            dateTimeFactory: LocalDateTimeFactory(),
            animate: false,
          ),
        ));
  }

}