import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:totalexam/models/pet_activites.dart';
import 'package:totalexam/reference/constants.dart';

class ChartRing extends StatefulWidget {
  final List<PetActivity> activities;

  ChartRing({required this.activities});

  @override
  State<ChartRing> createState() => _ChartRingState();
}

class _ChartRingState extends State<ChartRing> {
  List<ChartData> _chartData = [];

  @override
  void initState() {
    super.initState();
    // 위젯 초기화 시 차트 데이터를 생성합니다.
    _chartData = _generateChartData(widget.activities);

    
  }

  List<ChartData> _generateChartData(List<PetActivity> activities) {
    final activityCounts = <String, int>{};
    final totalActivities = activities.length;

    // 활동 카테고리별로 개수를 세어 activityCounts에 저장합니다.
    for (var activity in activities) {
      if (activityCounts.containsKey(activity.category)) {
        activityCounts[activity.category] = activityCounts[activity.category]! + 1;
      } else {
        activityCounts[activity.category] = 1;
      }
    }

    // 차트 데이터 리스트를 생성합니다.
    return activityCounts.entries.map((entry) {
      final percentage = (entry.value / totalActivities) * 100;
      return ChartData(
        x: entry.key, // 카테고리 이름
        y: entry.value.toDouble(), // 활동 개수
        percentage: percentage, // 활동 비율
        color: getColorForCategory(entry.key), // 카테고리 색상
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final activityCounts = <String, int>{};
    final totalActivities = widget.activities.length;

    for (var activity in widget.activities) {
      if (activityCounts.containsKey(activity.category)) {
        activityCounts[activity.category] = activityCounts[activity.category]! + 1;
      } else {
        activityCounts[activity.category] = 1;
      }
    }

    final chartData = activityCounts.entries.map((entry) {
      final percentage = (entry.value / totalActivities) * 100; // Calculate percentage
      return ChartData(
        x: entry.key,
        y: entry.value.toDouble(),
        percentage: percentage, // Correctly include percentage
        color: getColorForCategory(entry.key),
      );
    }).toList();

    // 전체 퍼센테이지
    final totalPercentage = chartData.fold(0.0, (sum, item) => sum + item.percentage);

    // 콘솔에 카테고리, 카운트, 퍼센테이지 출력
    for (var data in chartData) {
      print("Category: ${data.x}, Count: ${data.y.toStringAsFixed(0)}, Percentage: ${data.percentage.toStringAsFixed(1)}%");
    }

    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: 350,
          child: SfCircularChart(
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: chartData,
                innerRadius: "85%",
                startAngle: 350,
                endAngle: 350,
                cornerStyle: CornerStyle.bothCurve,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Icon(Icons.pets,
                        size: 90,
                        color: Colors.white,),
          ),
        ),
      ],
    );
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case '식사/간식':
        return secondaryColor;
      case '배변':
        return Color(0xFF4FF0B4);
      case '놀이':
        return secondaryColor2;  
      case '산책':
        return Color(0xFFF9A266);
      case '양치/목욕':
        return Color(0xFF01DFFF);
      case '미용':
        return Color(0xFFF9CE62);
      case '병원':
        return Color(0xFFB39DDB);
      case '약':
        return Color(0xFFF48FB1);
      default:
        return Colors.grey;
    }
  }
}

class ChartData {
  ChartData({
    required this.x,          // 카테고리 이름
    required this.y,          // 활동 개수
    required this.percentage, // 활동 비율
    required this.color,      // 카테고리 색상
  });

  final String x;          // 카테고리 이름
  final double y;         // 활동 개수
  final double percentage; // 활동 비율
  final Color color;      // 카테고리 색상
}
