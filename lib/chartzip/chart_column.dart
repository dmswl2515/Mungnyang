
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../reference/constants.dart';

class ChartColumn extends StatelessWidget {
  const ChartColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      borderColor: Colors.transparent,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        axisLine: AxisLine(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        labelStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
          fontSize: 10,
      )),
      primaryYAxis: const NumericAxis(
      majorGridLines: MajorGridLines(width: 1, color: bgColor),
      majorTickLines: MajorTickLines(width: 0),
      axisLine: AxisLine(width: 0),
      isVisible: true,
      minimum: 10,
      maximum: 50,
      interval: 10,
      ),
    series: <CartesianSeries>[
      ColumnSeries<ChartColumnData, String>(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        dataSource: chartData,
        width: 0.4,
        borderColor: primaryColor,
        color: secondaryColor2,
        borderWidth: 2,
        xValueMapper: (ChartColumnData data, _) => data.x,
        yValueMapper: (ChartColumnData data, _) => data.y),
      ColumnSeries<ChartColumnData, String>(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        dataSource: chartData,
        width: 0.4,
        color: secondaryColor,
        borderColor: primaryColor,
        borderWidth: 2,
        xValueMapper: (ChartColumnData data, _) => data.x,
        yValueMapper: (ChartColumnData data, _) => data.y1),
    ]);
  }
}

class ChartColumnData {
  ChartColumnData(this.x, this.y, this.y1);

  final String x;
  final double y;
  final double y1;
}

final List<ChartColumnData> chartData = <ChartColumnData>[
  ChartColumnData("월", 20, 35),
  ChartColumnData("화", 40, 32),
  ChartColumnData("수", 30, 34),
  ChartColumnData("목", 42, 50),
  ChartColumnData("금", 32, 40),
  ChartColumnData("토", 42, 45),
  ChartColumnData("일", 35, 50),
];

