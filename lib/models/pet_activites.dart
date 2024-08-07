import 'package:cloud_firestore/cloud_firestore.dart';

class PetActivity {
  final String category;
  final String date;
  final String endTime;
  final String memo;
  final String startTime;
  final DateTime timestamp;
  final String title;

  PetActivity({
    required this.category,
    required this.date,
    required this.endTime,
    required this.memo,
    required this.startTime,
    required this.timestamp,
    required this.title,
  });

  factory PetActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PetActivity(
      category: data['category'] as String,
      date: data['date'] as String,
      endTime: data['endTime'] as String,
      memo: data['memo'] as String,
      startTime: data['startTime'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      title: data['title'] as String,
    );
  }
}


Future<List<PetActivity>> fetchActivities() async {
  final firestore = FirebaseFirestore.instance;
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday % 7)); // 이번 주 일요일
  final startOfMonth = DateTime(now.year, now.month, 1); // 이번 달 1일

  final snapshot = await firestore.collection('pet_activities')
      .where('timestamp', isGreaterThanOrEqualTo: startOfWeek.toUtc())
      .where('timestamp', isLessThanOrEqualTo: startOfMonth.add(Duration(days: 31)).toUtc())
      .get();

  return snapshot.docs.map((doc) => PetActivity.fromFirestore(doc)).toList();
}

class PetActivityTodo {
  final String category;
  final DateTime date;

  PetActivityTodo({required this.category, required this.date});

  factory PetActivityTodo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PetActivityTodo(
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
