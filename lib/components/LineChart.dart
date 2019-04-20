import 'package:charts_common/src/chart/common/behavior/chart_behavior.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';

class LineChart extends StatefulWidget {
  bool isZoomable;
  bool showXAxis;
  List series;
  var onChangeListener;

  LineChart({this.isZoomable, this.series, this.onChangeListener, this.showXAxis: true});

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      widget.series,
      domainAxis: widget.showXAxis ? null : charts.DateTimeAxisSpec(showAxisLine: false, tickProviderSpec: charts.StaticDateTimeTickProviderSpec([])),
      behaviors: createBehavior(),
      dateTimeFactory: charts.LocalDateTimeFactory(),
      animate: true,
      selectionModels: []..addAll(widget.onChangeListener != null ? [charts.SelectionModelConfig(type: charts.SelectionModelType.info, changedListener: widget.onChangeListener)] : []),
    );
  }

  List<charts.ChartBehavior<ChartBehavior>> createBehavior() {
    List<charts.ChartBehavior<ChartBehavior>> behaviors = [];
    if (widget.isZoomable) {
      behaviors.add(charts.PanAndZoomBehavior());
    }
    return behaviors;
  }
}
