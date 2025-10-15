import 'package:fl_chart/fl_chart.dart' as charts;
import 'package:flutter/widgets.dart';

class LineChart extends StatefulWidget {
  bool isZoomable;
  bool showXAxis;
  bool shrinkYAxis;
  charts.LineChartData series;
  var onChangeListener;

  double maxValue;

  LineChart({
    required this.isZoomable,
    required this.series,
    this.onChangeListener,
    this.showXAxis = true,
    this.shrinkYAxis = false,
    this.maxValue = 30,
  });

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  double minValue = 0;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    var chart = charts.LineChart(
      widget.series,
      transformationConfig: charts.FlTransformationConfig(
        scaleAxis: charts.FlScaleAxis.horizontal,
        trackpadScrollCausesScale: true,
        maxScale: 100,
      ),
    );
    return chart;
  }
}
