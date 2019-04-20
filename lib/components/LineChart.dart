import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';

class LineChart extends StatefulWidget {
  bool isZoomable;
  List series;
  var onChangeListener;

  LineChart({this.isZoomable, this.series, this.onChangeListener});

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      widget.series,
      behaviors: []..addAll(widget.isZoomable ? [charts.PanAndZoomBehavior()] : []),
      dateTimeFactory: charts.LocalDateTimeFactory(),
      animate: true,
      selectionModels: [
        charts.SelectionModelConfig(type: charts.SelectionModelType.info, changedListener: widget.onChangeListener),
      ],
    );
  }
}
