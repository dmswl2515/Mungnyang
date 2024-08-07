import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalexam/ui/widgets/button.dart';
import 'package:totalexam/ui/widgets/input_field.dart';
import 'package:totalexam/reference/theme.dart';

class EatPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const EatPage({super.key, this.data});

  @override
  State<EatPage> createState() => _EatPageState();
}

class _EatPageState extends State<EatPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "21:30";
  String _startTime = DateFormat("HH:mm").format(DateTime.now()).toString();
  String? _documentId;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _titleController.text = widget.data!['title'] ?? '';
      _noteController.text = widget.data!['memo'] ?? '';
      _startTime = widget.data!['startTime'] ?? _startTime;
      _endTime = widget.data!['endTime'] ?? _endTime;

      // 날짜 처리
      var dateData = widget.data!['date'];
      if (dateData is DateTime) {
        _selectedDate = dateData;
      } else if (dateData is String) {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(dateData);
      } else if (dateData is Timestamp) {
        _selectedDate = dateData.toDate();
      } else {
        _selectedDate = DateTime.now();
      }

      _documentId = widget.data!['id'];
      print("Document ID: $_documentId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("식사/간식 등록", style: HeadingStyle),
              MyInputField(title: "제목", hint: "제목을 입력해주세요", controller: _titleController),
              MyInputField(title: "메모", hint: "메모를 입력해주세요", controller: _noteController),
              MyInputField(
                title: "날짜",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                  onPressed: _getDateFromUser,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "시작 시간",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "종료 시간",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                        icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyButton(
                    label: "저장하기",
                    onTap: _validatedDate,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addTaskToDb() async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('pet_activities').doc();
      await docRef.set({
        'title': _titleController.text,
        'memo': _noteController.text,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'startTime': _startTime,
        'endTime': _endTime,
        'timestamp': Timestamp.fromDate(DateTime.now()),
        'id': docRef.id,
      });
      print("Task added to Firestore with ID: ${docRef.id}");
      setState(() {
        _documentId = docRef.id;
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  _updateTaskInDb() async {
    if (_documentId != null) {
      try {
        DocumentReference docRef = FirebaseFirestore.instance.collection('pet_activities').doc(_documentId);
        DocumentSnapshot docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          await docRef.update({
            'title': _titleController.text,
            'memo': _noteController.text,
            'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
            'startTime': _startTime,
            'endTime': _endTime,
            'timestamp': Timestamp.fromDate(DateTime.now()),
          });
          print("Task updated in Firestore with ID: $_documentId");
        } else {
          print("Document does not exist, creating a new document.");
          await _addTaskToDb();
        }
      } catch (e) {
        print("Error updating task: $e");
      }
    } else {
      print("Document ID is null");
    }
  }

  _validatedDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      if (_documentId != null) {
        _updateTaskInDb();
      } else {
        _addTaskToDb();
      }
      Get.back(result: _selectedDate);
    } else {
      Get.snackbar(
        "필수사항입니다",
        "모든 필드를 입력해주세요!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.dialogBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios, size: 20, color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/dogcat.png"),
          radius: 20,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    } else {
      print("Date is null or something is wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      DateTime now = DateTime.now();
      DateTime parsedTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      String formattedTime = DateFormat('HH:mm').format(parsedTime);

      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    } else {
      print("Time is null or something is wrong");
    }
  }
}
