import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totalexam/reference/theme.dart';
import 'package:totalexam/ui/widgets/input_field.dart';

class EditPage extends StatefulWidget {
  final String documentId;
  final String initialCategory;
  final String initialTitle;
  final String initialMemo;
  final DateTime initialStartTime;
  final DateTime initialEndTime;

  const EditPage({
    Key? key,
    required this.documentId,
    required this.initialCategory,
    required this.initialTitle,
    required this.initialMemo,
    required this.initialStartTime,
    required this.initialEndTime,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _titleController;
  late TextEditingController _memoController;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _memoController = TextEditingController(text: widget.initialMemo);
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }

  Future<void> _updateDocument() async {
  try {
    await FirebaseFirestore.instance.collection('pet_activities').doc(widget.documentId).update({
      'title': _titleController.text,
      'memo': _memoController.text,
      'startTime': DateFormat('HH:mm').format(_startTime),
      'endTime': DateFormat('HH:mm').format(_endTime),
      'timestamp': _startTime.toUtc(),
    });
    print('Document updated successfully'); // 로그 추가
    Navigator.pop(context, true);
  } catch (e) {
    print('Error updating document: $e');
  }
}

  Future<void> _selectTime(DateTime initialTime, Function(DateTime) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );
    if (picked != null) {
      setState(() {
        onTimeSelected(DateTime(
          initialTime.year,
          initialTime.month,
          initialTime.day,
          picked.hour,
          picked.minute,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정보 수정',),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("일정 등록",
                  style: HeadingStyle,),
            MyInputField(title: "제목", hint: "제목을 입력해주세요", controller: _titleController,), 
            MyInputField(title: "메모", hint: "메모를 입력해주세요", controller: _memoController,),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: MyInputField(
                      title: "시작 시간",
                      hint: '${DateFormat('h:mm a').format(_startTime)}',
                      widget: IconButton(
                        onPressed: () {
                          _selectTime(_startTime, (time) => _startTime = time); 
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ), 
                    ),
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: MyInputField(
                      title: "종료 시간",
                      hint: '${DateFormat('h:mm a').format(_endTime)}',
                      widget: IconButton(
                        onPressed: () {
                           _selectTime(_endTime, (time) => _endTime = time); 
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ), 
                    ),
                  ),
                // Text('Start Time: ${DateFormat('h:mm a').format(_startTime)}'),
                // Spacer(),
                // ElevatedButton(
                //   onPressed: () => _selectTime(_startTime, (time) => _startTime = time),
                //   child: const Text('Pick Start Time'),
                // ),
              ],
            ),
            // Row(
            //   children: [
            //     Text('End Time: ${DateFormat('h:mm a').format(_endTime)}'),
            //     Spacer(),
            //     ElevatedButton(
            //       onPressed: () => _selectTime(_endTime, (time) => _endTime = time),
            //       child: const Text('Pick End Time'),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[200],
                      minimumSize: Size(150, 50), // 최소 크기 설정 (너비, 높이)
                  ),
                  onPressed: _updateDocument,
                  child: const Text('저장하기',
                      style: TextStyle(color: Colors.black54),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

