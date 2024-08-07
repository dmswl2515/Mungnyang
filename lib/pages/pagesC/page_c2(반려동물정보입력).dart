import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Add this import for Getx navigation

class PageC2 extends StatefulWidget {
  const PageC2({super.key, required this.title});

  final String title;

  @override
  _PageC2State createState() => _PageC2State();
}

enum Animal { dog, cat }
enum Gender { male, female }
enum Neuter { done, yet }

class _PageC2State extends State<PageC2> with SingleTickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late AnimationController _animationController;
  bool isExpandex = false;

  Uint8List? _image;
  File? selectedImage;
  Animal _myGroup1 = Animal.dog;
  Gender _myGroup2 = Gender.male;
  Neuter _myGroup3 = Neuter.done;
  DateTime? _selectDateTime;
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();

  late CollectionReference pets;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    super.initState();

    pets = FirebaseFirestore.instance.collection('pets');
  }

  void _chooseDateTime() async {
    final result = await showBoardDateTimePicker(
      context: context,
      pickerType: DateTimePickerType.date,
      initialDate: _selectDateTime ?? DateTime.now(),
      options: BoardDateTimeOptions(
        languages: const BoardPickerLanguages(
          today: '오늘',
          tomorrow: '내일',
          now: '지금',
        ),
        startDayOfWeek: DateTime.sunday,
        pickerFormat: PickerFormat.ymd,
        activeColor: Colors.blueGrey[900],
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _selectDateTime = result;
      });
    }
  }

  Future<void> _registerPet() async {
    // 유효성 검증
    if (_nameController.text.isEmpty || _weightController.text.isEmpty || _selectDateTime == null) {
      Get.snackbar(
        "필수사항입니다",
        "모든 필드를 채워주세요.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.deepPurple[200],
        colorText: Colors.grey[850],
        icon: Icon(Icons.warning_amber_rounded, color: Colors.amber),
      );
      return;
    }

    String? imageUrl;
    if (_image != null) {
      try {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child('pet_images/${DateTime.now().millisecondsSinceEpoch}.png');
        final uploadTask = storageReference.putData(_image!);
        final snapshot = await uploadTask.whenComplete(() => {});
        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("이미지 업로드 실패: $e");
      }
    }

    await pets.add({
      'image': imageUrl,
      'animal': _myGroup1.toString().split('.').last,
      'name': _nameController.text,
      'birthdate': _selectDateTime,
      'weight': double.parse(_weightController.text),
      'gender': _myGroup2.toString().split('.').last,
      'neuter': _myGroup3.toString().split('.').last,
    });

    Get.snackbar(
      "등록 완료",
      "반려동물 정보가 성공적으로 저장되었습니다.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.deepPurple[200],
      colorText: Colors.grey[850],
      icon: Icon(Icons.check_circle, color: Colors.amber),
    );

    // 2초 후에 페이지 이동
    Future.delayed(Duration(seconds: 4), () {
      Get.offNamed('/'); // '/mainhome'은 이동할 페이지의 경로입니다. 변경할 수 있습니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '반려동물 정보 입력(Page C-2)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(radius: 100, backgroundImage: MemoryImage(_image!))
                          : CircleAvatar(
                              radius: 100,
                              backgroundColor: Colors.blue[20],
                              backgroundImage: const AssetImage('assets/images/dogcat.png'),
                            ),
                      Positioned(
                        bottom: -0,
                        left: 140,
                        child: IconButton(
                          onPressed: () {
                            showImagePickerOption(context);
                          },
                          icon: const Icon(Icons.add_a_photo, size: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Row( // 반려동물 선택
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      '반려동물',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: Row(
                        children: [
                          Radio<Animal>(
                            groupValue: _myGroup1,
                            value: Animal.dog,
                            onChanged: (Animal? value) {
                              setState(() {
                                _myGroup1 = value!;
                                print(_myGroup1);
                              });
                            },
                          ),
                          const Text('강아지'),
                          Radio<Animal>(
                            groupValue: _myGroup1,
                            value: Animal.cat,
                            onChanged: (Animal? value) {
                              setState(() {
                                _myGroup1 = value!;
                                print(_myGroup1);
                              });
                            },
                          ),
                          const Text('고양이'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row( // 이름
                  children: [
                    SizedBox(width: 20),
                    const Text(
                      '이름',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 50),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Flexible(
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: '이름을 입력해주세요',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            filled: true,
                            fillColor: const Color.fromARGB(0, 255, 255, 255),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color.fromARGB(0, 158, 158, 158), width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: const TextStyle(fontSize: 16.0),
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (text) {
                            print('현재 입력: $text');
                          },
                          onSubmitted: (text) {
                            print('완료된 입력: $text');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row( // 생년월일
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      '생년월일',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _chooseDateTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        shadowColor: Colors.transparent,
                      ),
                      child: _selectDateTime == null
                          ? const Text('날짜를 선택해주세요.', style: TextStyle(color: Colors.grey))
                          : Text(
                              '${_selectDateTime!.year}-${_selectDateTime!.month}-${_selectDateTime!.day}'),
                    ),
                  ],
                ),
                const Divider(),
                Row( // 몸무게
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      '몸무게',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _weightController,
                                  decoration: InputDecoration(
                                    hintText: '예) 3.45',
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                    filled: true,
                                    fillColor: Color.fromARGB(0, 255, 255, 255),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromARGB(0, 158, 158, 158), width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 16.0),
                                  textAlignVertical: TextAlignVertical.center,
                                  onChanged: (text) {
                                    print('현재 입력: $text');
                                  },
                                  onSubmitted: (text) {
                                    print('완료된 입력: $text');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text('kg', style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row( // 성별
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      '성별',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 50),
                    Flexible(
                      child: Row(
                        children: [
                          Radio<Gender>(
                            groupValue: _myGroup2,
                            value: Gender.male,
                            onChanged: (Gender? value) {
                              setState(() {
                                _myGroup2 = value!;
                                print(_myGroup2);
                              });
                            },
                          ),
                          const Text('수컷'),
                          Radio<Gender>(
                            groupValue: _myGroup2,
                            value: Gender.female,
                            onChanged: (Gender? value) {
                              setState(() {
                                _myGroup2 = value!;
                                print(_myGroup2);
                              });
                            },
                          ),
                          const Text('암컷'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row( // 중성화 여부
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      '중성화 여부',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Row(
                        children: [
                          Radio<Neuter>(
                            groupValue: _myGroup3,
                            value: Neuter.done,
                            onChanged: (Neuter? value) {
                              setState(() {
                                _myGroup3 = value!;
                                print(_myGroup3);
                              });
                            },
                          ),
                          const Text('완료'),
                          Radio<Neuter>(
                            groupValue: _myGroup3,
                            value: Neuter.yet,
                            onChanged: (Neuter? value) {
                              setState(() {
                                _myGroup3 = value!;
                                print(_myGroup3);
                              });
                            },
                          ),
                          const Text('미완료'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text(
                    '등록하기',
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                  onPressed: _registerPet,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(330, 50),
                    backgroundColor: Colors.blueGrey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 180,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('카메라로 사진 찍기'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('갤러리에서 선택하기'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
        selectedImage = File(pickedFile.path);
      });
    }
  }
}
