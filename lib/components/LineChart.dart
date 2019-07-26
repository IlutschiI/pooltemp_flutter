import 'package:charts_common/src/chart/common/behavior/chart_behavior.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';

class LineChart extends StatefulWidget {
  bool isZoomable;
  bool showXAxis;
  bool shrinkYAxis;
  List series;
  var onChangeListener;

  double maxValue;

  LineChart({this.isZoomable, this.series, this.onChangeListener, this.showXAxis: true, this.shrinkYAxis: false, this.maxValue});

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  double minValue = 0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    var chart = charts.TimeSeriesChart(
      widget.series,
      primaryMeasureAxis: buildAxisSpec(),
      domainAxis: widget.showXAxis ? null : charts.DateTimeAxisSpec(showAxisLine: false, tickProviderSpec: charts.StaticDateTimeTickProviderSpec([])),
      behaviors: createBehavior(),
      dateTimeFactory: charts.LocalDateTimeFactory(),
      animate: true,
      selectionModels: []..addAll(widget.onChangeListener != null ? [charts.SelectionModelConfig(type: charts.SelectionModelType.info, changedListener: widget.onChangeListener)] : []),
    );
    return Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        chart,
        GestureDetector(
          onVerticalDragUpdate: onDrag,
          onVerticalDragEnd: onDragEnd,
          child: Container(
            width: 60,
            height: double.infinity,
            color: Color.fromRGBO(255, 0, 0, 0.0),
          ),
        )
      ],
    );
  }

  charts.AxisSpec buildAxisSpec() {
    if (widget.shrinkYAxis) {
      return charts.AxisSpec(tickProviderSpec: charts.NumericEndPointsTickProviderSpec());
    }
    return charts.NumericAxisSpec(viewport: charts.NumericExtents(minValue, widget.maxValue), showAxisLine: true);
  }

  List<charts.ChartBehavior<ChartBehavior>> createBehavior() {
    List<charts.ChartBehavior<ChartBehavior>> behaviors = [];
    if (widget.isZoomable) {
      behaviors.add(charts.PanAndZoomBehavior());
    }
    return behaviors;
  }

  void onDrag(DragUpdateDetails details) {
    minValue = minValue + details.delta.dy / 20;
    //print(details.delta.dy);
    if (count == 50) {
      print("setting state");
      setState(() {});
      count = 0;
    }
    count++;
  }

  void onDragEnd(DragEndDetails details) {
    print(minValue);
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {});
    });
  }
}
