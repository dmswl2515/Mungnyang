import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:totalexam/models/pet_activites.dart';
import '../chartzip/chart_column.dart';
import '../chartzip/chart_containerbar.dart';
import '../chartzip/chart_ring.dart';
import '../chartzip/chart_spline.dart';
import '../chartzip/chart_spline2.dart';
import '../chartzip/chart_spline3.dart';
import '../models/data.dart';
import '../reference/constants.dart';
import '../reference/drawer.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageB1 extends StatefulWidget {
  const PageB1({Key? key}) : super(key: key);

  @override
  _PageB1State createState() => _PageB1State();
}

class _PageB1State extends State<PageB1> {

  Future<List<PetActivity>> fetchActivities() async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    final startOfMonth = DateTime(now.year, now.month, 1);

    final snapshot = await firestore.collection('pet_activities')
        .where('timestamp', isGreaterThanOrEqualTo: startOfWeek.toUtc())
        .where('timestamp', isLessThanOrEqualTo: startOfMonth.add(Duration(days: 31)).toUtc())
        .get();

    return snapshot.docs.map((doc) => PetActivity.fromFirestore(doc)).toList();
  }

  Map<String, int> calculateActivityCounts(List<PetActivity> activities) {
    Map<String, int> counts = {};
    for (var activity in activities) {
      if (counts.containsKey(activity.category)) {
        counts[activity.category] = counts[activity.category]! + 1;
        print('counts1 : $counts');
      } else {
        counts[activity.category] = 1;
        print('counts2 : $counts');
      }
    }
    return counts;
    
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM').format(DateTime.now());

  return Scaffold(
  appBar: AppBar(
    centerTitle: true,
    title: const Text('보고서'),
  ),
  drawer: AppDrawer(),
  body: SingleChildScrollView(
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15, bottom: 0),
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            height: 300, 
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '돌봄정보',
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        'Week',
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white54,)
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<PetActivity>>(
                    future: fetchActivities(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No data found'));
                      } else {
                        final List<PetActivity> activities = snapshot.data!;
                        return ChartRing(activities: activities);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0, right: 15, left: 15, bottom: 15),
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            height: 400,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),),
            ),
            child: Column(
              children: [
                FutureBuilder<List<PetActivity>>(
                  future: fetchActivities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data found'));
                    } else {
                      final List<PetActivity> activities = snapshot.data!;
                      final activityCounts = calculateActivityCounts(activities);

                      print('Activity Counts: $activityCounts'); // Debugging line

                      return Expanded(
                        child: Column(
                          children: activityCounts.entries.map((entry) {
                            final category = entry.key;
                            final count = entry.value;
                            final percentage = count / activities.length;

                            return ContainerBar(
                              title: category,
                              value: '${(percentage * 100).toStringAsFixed(1)}% ($count 회)',
                              percentage: percentage,
                              color: getColorForCategory(category),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            height: 370,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'TODO',
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        currentMonth,
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white54,)
                  ],
                ),
                SizedBox(height: defaultPadding),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: DataTable(
                    headingTextStyle: TextStyle(color: Colors.white),
                    headingRowHeight: 25,
                    horizontalMargin: 0,
                    dataRowHeight: 35,
                    columnSpacing: 7,
                    columns: [
                      DataColumn(label: Text('할일')),
                      DataColumn(label: Text('15')),
                      DataColumn(label: Text('16')),
                      DataColumn(label: Text('17')),
                      DataColumn(label: Text('18')),
                      DataColumn(label: Text('19')),
                      DataColumn(label: Text('20')),
                      DataColumn(label: Text('21')),
                    ], 
                    rows: List.generate(
                      demoData.length, 
                      (index) => _dataRow(demoData[index])
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Container(
            height: 300,
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Financial Analytics',
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding / 2),
                      child: Text(
                        'Income',
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    SizedBox(width: defaultPadding * 2),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding / 2),
                      child: Text(
                        'Expenses',
                        style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding * 2),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: chartSpline(),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: defaultPadding * 2),
        SizedBox(height: 100),
      ],
    ),
  ),
);

  }
}

DataRow _dataRow(Data data) {
  return DataRow(cells: [
    DataCell(Text(data.title, style: TextStyle(fontSize: 11))),
    DataCell(data.icon1),
    DataCell(data.icon2),
    DataCell(data.icon3),
    DataCell(data.icon4),
    DataCell(data.icon5),
    DataCell(data.icon6),
    DataCell(data.icon7),
  ]);
}

Color getColorForCategory(String category) {
  switch (category) {
    case '식사/간식':
      return Colors.orange;
    case '병원':
      return Color(0xFFB39DDB);
    case '산책':
      return Color(0xFF4FF0B4);
    case '배변':
      return Color(0xFF01DFFF);
    case '양치/목욕':
      return Color(0xFFF9A266);
    case '미용':
      return Color(0xFFF9CE62);
    case '약':
      return Color(0xFFF48FB1);
    default:
      return Colors.grey;
  }
}
