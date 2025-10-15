import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pooltemp_flutter/model/temperature.dart';
import 'package:pooltemp_flutter/util/dateTimeUtil.dart';

class TemperatureSeriesConverter {
  LineChartData convert(List<Temperature> value, {bool showXAxis = true, bool enableTooltips = true}) {
    final data = LineChartData(
      borderData: FlBorderData(
        border: Border(
          left: BorderSide(style: showXAxis ? BorderStyle.solid : BorderStyle.none),
          bottom: BorderSide(style: showXAxis ? BorderStyle.solid : BorderStyle.none),
        ),
      ),
      lineTouchData: LineTouchData(
        touchSpotThreshold: 20,
        enabled: enableTooltips,
        longPressDuration: Duration(),
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((e) {
              return LineTooltipItem(
                '',
                TextStyle(color: e.bar.gradient?.colors.first ?? e.bar.color ?? Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 14),
                children: [
                  TextSpan(text: "${e.y} °C"),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: DateTimeUtil.format(DateTime.fromMillisecondsSinceEpoch(e.x.toInt()), dateFormat: DateTimeUtil.ddMMyyyyHHmm),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: value.map((e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.temperature)).toList(),
          dotData: FlDotData(show: false),
        ),
      ],
      titlesData: FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitleAlignment: SideTitleAlignment.outside,
          sideTitles: SideTitles(
            showTitles: showXAxis,
            reservedSize: 45,
            minIncluded: false,
            maxIncluded: false,
            getTitlesWidget: (double value, TitleMeta meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return SideTitleWidget(
                meta: meta,
                space: 16,
                angle: pi / -4,
                child: Text(DateTimeUtil.format(date, dateFormat: DateTimeUtil.ddMMyy)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            // interval: _calculateInterval(value),
            reservedSize: 40,
            showTitles: true,
            getTitlesWidget: (value, meta) {
              //prevent overlapping rendering of Y-Axis
              if (value != meta.min && value != meta.max && (value + 10 > meta.max || value - 10 < meta.min)) {
                return SizedBox.shrink();
              }
              return SideTitleWidget(meta: meta, space: 4, child: Text("${value.toStringAsFixed(1)}"));
            },
          ),
        ),
      ),
      gridData: FlGridData(drawVerticalLine: false),
    );

    return data;
  }
}
