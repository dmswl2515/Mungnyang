import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:totalexam/ui/widgets/button.dart';
import 'package:totalexam/ui/widgets/input_field.dart';
import 'page_d1.dart';

class EditPage2 extends StatefulWidget {
  final String postId;

  const EditPage2({Key? key, required this.postId}) : super(key: key);

  @override
  State<EditPage2> createState() => _EditPage2State();
}

class _EditPage2State extends State<EditPage2> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  File? _image;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchPostData();
  }

  Future<void> _fetchPostData() async {
    final postDoc =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final postSnapshot = await postDoc.get();

    if (postSnapshot.exists) {
      final postData = postSnapshot.data() as Map<String, dynamic>;
      _titleController.text = postData['title'] ?? '';
      _noteController.text = postData['note'] ?? '';
      _selectedDate = postData['date']?.toDate() ?? DateTime.now();
      _startTime = postData['startTime'] ?? '';
      _existingImageUrl = postData['image'];
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("필수사항입니다", "모든 필드를 입력해야 합니다!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pink,
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
      return;
    }

    String imageUrl = _existingImageUrl ?? '';

    if (_image != null) {
      imageUrl = await _uploadImage();
    }

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .update({
      'title': _titleController.text,
      'note': _noteController.text,
      'date': _selectedDate,
      'startTime': _startTime,
      'image': imageUrl,
    });

    Get.snackbar(
      "수정 완료",
      "게시물이 수정되었습니다.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.deepPurple[200],
      colorText: Colors.grey[850],
      icon: Icon(Icons.check_circle, color: Colors.amber),
    );

    Future.delayed(Duration(seconds: 4), () {
      Get.off(() => PageD1());
    });
  }

  Future<String> _uploadImage() async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(_image!);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('게시물 수정')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: _image != null || _existingImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                _existingImageUrl!,
                                width: 300,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          width: 300,
                          height: 300,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.grey[800],
                            size: 100,
                          ),
                        ),
                      ),
              ),
              MyInputField(
                title: "제목",
                hint: "제목을 입력해주세요",
                controller: _titleController,
              ),
              MyInputField(
                title: "메모",
                hint: "메모를 입력해주세요",
                controller: _noteController,
              ),
              MyInputField(
                title: "날짜",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                  onPressed: () => _getDateFromUser(),
                ),
              ),
              Row(children: [
                Expanded(
                  child: MyInputField(
                    title: "시간",
                    hint: _startTime,
                    widget: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: true),
                      icon: Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyButton(label: "저장하기", onTap: _saveData),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    if (pickedTime != null) {
      String _formattedTime = pickedTime.format(context);
      setState(() {
        _startTime = _formattedTime;
      });
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
  }
}
