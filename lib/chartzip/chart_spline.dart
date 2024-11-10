
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/chart_spline_data.dart';
import '../reference/constants.dart';

class chartSpline extends StatelessWidget {
  const chartSpline({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      onDataLabelRender: (DataLabelRenderArgs args) {       //Display values on top of the chart
        if(args.pointIndex == 1) {
          args.text = "\$2 500,00";
          args.textStyle = TextStyle(
            fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400);
            args.offset = Offset(0, 20);
        }
        if(args.pointIndex != 1) {
          args.text = '';
        }
      },
      onMarkerRender: (MarkerRenderArgs args) {   //Display markers on top of the chart
        if(!(args.pointIndex == 1)) {
          args.markerHeight = 0;
          args.markerWidth = 0;
        }
      },
      plotAreaBackgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(0),
      borderColor: Colors.transparent,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        axisLine: AxisLine(width: 0),
        labelPlacement: LabelPlacement.onTicks,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        labelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
      )),
      primaryYAxis: const NumericAxis(
      majorGridLines:
          MajorGridLines(width: 1, color: bgColor),
      majorTickLines: MajorTickLines(width: 0),
      axisLine: AxisLine(width: 0),
      minimum: 1000,
      maximum: 3000,
      interval: 500,
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
              secondaryColor2.withAlpha(150),
              secondaryColor2.withAlpha(10)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      SplineSeries<ChartSplineData, String>(
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 10,
          width: 10
        ), 
        dataLabelSettings: const DataLabelSettings(   // Set value properties on top of the chart
          color: primaryColor,
          borderColor : secondaryColor,
          borderWidth: 2,
          useSeriesColor: true,
          isVisible: true,
          labelAlignment: ChartDataLabelAlignment.top,
        ),
        color: secondaryColor,
        width: 4,
        dataSource: chartData2,
        xValueMapper: (ChartSplineData data, _) =>
            data.month,
        yValueMapper: (ChartSplineData data, _) =>
            data.amount,
      ),
      SplineAreaSeries(
        dataSource: chartData2,
        xValueMapper: (dynamic data, _) =>
            (data as ChartSplineData).month,
        yValueMapper: (dynamic data, _) =>
            (data as ChartSplineData).amount,
        gradient: LinearGradient(
            colors: [
              secondaryColor.withAlpha(150),
              secondaryColor.withAlpha(10)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      )
    ],
  );
  }
}

final List<ChartSplineData> chartData = <ChartSplineData>[
  ChartSplineData("월", 1000),
  ChartSplineData("화", 2000),
  ChartSplineData("수", 1500),
  ChartSplineData("목", 2800),
  ChartSplineData("금", 1000),
  ChartSplineData("토", 2500),
  ChartSplineData("일", 1500),
];

final List<ChartSplineData> chartData2 = <ChartSplineData>[
  ChartSplineData("월", 2000),
  ChartSplineData("화", 1500),
  ChartSplineData("수", 2800),
  ChartSplineData("목", 1500),
  ChartSplineData("금", 2500),
  ChartSplineData("토", 1000),
  ChartSplineData("일", 1500),
];
