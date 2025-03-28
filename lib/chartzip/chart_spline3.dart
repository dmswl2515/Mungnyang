
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/chart_spline_data.dart';
import '../reference/constants.dart';

class ChartSpline3 extends StatelessWidget {
  const ChartSpline3({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.transparent,
      margin: EdgeInsets.all(0),
      borderColor: Colors.transparent,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        isVisible: false,
      ),
      primaryYAxis: NumericAxis(
        isVisible: false,
      ),
      series: <CartesianSeries<dynamic, dynamic>>[
      SplineSeries<ChartSplineData, String>(
        color: secondaryColor2,
        width: 4,
        dataSource: chartData,
        xValueMapper: (ChartSplineData data, _) =>
            data.month,
        yValueMapper: (ChartSplineData data, _) =>
            data.amount,
      ),
      SplineAreaSeries(
        dataSource: chartData,
        xValueMapper: (dynamic data, _) =>
            (data as ChartSplineData).month,
        yValueMapper: (dynamic data, _) =>
            (data as ChartSplineData).amount,
        gradient: LinearGradient(
            colors: [
              secondaryColor.withAlpha(150),
              secondaryColor.withAlpha(23)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter)),
      ],
    );
  }
}

final List<ChartSplineData> chartData = <ChartSplineData>[
  ChartSplineData("월", 2),
  ChartSplineData("화", 8),
  ChartSplineData("수", 5),
  ChartSplineData("목", 7),
  ChartSplineData("금", 3),
];

