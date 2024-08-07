import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:totalexam/reference/text_provider.dart';

class CircularTimer extends StatefulWidget {
  final int number; // 타이머의 총 지속 시간 (초 단위)

  const CircularTimer({Key? key, required this.number}) : super(key: key);

  @override
  _CircularTimerState createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  late int remainingTime;
  Timer? timer;
  bool isRunning = false; // 타이머의 상태를 관리하는 변수
  int counter = -1; // 숫자를 증가시키는 변수
  bool isIconBlue = false; // 아이콘 색상 상태를 관리하는 변수
  bool isTimerFinished = false; // 타이머 종료 여부를 관리하는 변수
  int resultIndex = 7; // 정상 호흡을 쟀다는 인덱스

  @override
  void initState() {
    super.initState();
    remainingTime = widget.number;
  }

  void startTimer() {
    if (isRunning) return; // 이미 타이머가 실행 중일 때는 아무 작업도 하지 않습니다.
    setState(() {
      isRunning = true;
      isTimerFinished = false; // 타이머 시작 시 종료 상태 초기화
    });
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        stopTimer(); // 타이머가 끝났을 때 타이머를 정지합니다.
        setState(() {
          isTimerFinished = true; // 타이머 종료 상태 설정
          checkBreathing(); // 타이머 종료 후 호흡수 체크
        });
      }
    });
  }

  void stopTimer() {
    if (!isRunning) return; // 타이머가 실행 중이 아닐 때는 아무 작업도 하지 않습니다.
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  void incrementCounter() {
    if (isIconBlue) {
      // 아이콘이 파란색일 때만 카운터를 증가시킵니다.
      setState(() {
        counter++;
      });
    }
  }

  void resetTimer() {
    setState(() {
      remainingTime = widget.number;
      counter = -1;
      isIconBlue = false;
      isRunning = false;
      isTimerFinished = false;
      resultIndex = 7; // 인덱스 초기화
    });
    timer?.cancel();
  }

  void toggleIconColor() {
    if (!isIconBlue) {
      // 아이콘이 회색일 때만 색상을 변경합니다.
      setState(() {
        isIconBlue = true; // 아이콘 색상 상태를 파란색으로 변경
        startTimer(); // 아이콘 클릭 시 타이머를 시작합니다.
      });
    }
  }

  void checkBreathing() {
    int breathingRate;
    if (widget.number == 30) {
      breathingRate = counter * 2; // 30초 타이머일 경우 counter 값에 2를 곱하여 1분 단위로 환산
    } else {
      breathingRate = counter * (60 ~/ widget.number); // 다른 시간일 경우 1분 단위로 환산
    }

    // 정상 호흡 여부를 인덱스로 결정
    if (breathingRate >= 20 && breathingRate <= 30) {
      resultIndex = 7; // 정상 호흡
    } else {
      resultIndex = 8; // 비정상 호흡
    }
  }

  Future<void> _saveToFirestore() async {
    try {
      final time = DateTime.now();
      await FirebaseFirestore.instance.collection('pet_activities').add({
        'category': '호흡수',
        'title': '제목을 입력해주세요',
        'memo': '정상 호흡 여부: ${resultIndex == 7 ? '정상' : '비정상'}',
        'date': DateFormat('yyyy-MM-dd').format(time),
        'startTime': DateFormat('h:mm a').format(time),
        'endTime': "09:30 PM",
        'timestamp': time.toUtc(),
      });

      // 결과를 TextProvider에 업데이트
      Provider.of<TextProvider>(context, listen: false)
          .updateIndex(resultIndex);
    } catch (e) {
      print('Error saving activity to Firestore: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // 위젯이 종료될 때 타이머를 정리합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = remainingTime / widget.number;
    return Scaffold(
      appBar: AppBar(
        title: Text('타이머'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '발바닥을 클릭해주세요',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Visibility(
              visible: isIconBlue,
              child: Text(
                '$remainingTime초 남았습니다',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[300],
                ),
              ),
            ),
            SizedBox(height: 20), // Adjust spacing as needed
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 25,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
                Positioned(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.pets,
                            size: 200,
                            color: isIconBlue
                                ? Colors.deepPurple[400]
                                : Colors.grey),
                        onPressed: () {
                          if (!isIconBlue) {
                            toggleIconColor();
                          }
                          incrementCounter();
                        },
                      ),
                      if (isIconBlue)
                        Positioned(
                          bottom: 50,
                          child: Text(
                            '$counter',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30), // Adjust spacing as needed
            if (isTimerFinished)
              Padding(
                padding: const EdgeInsets.only(
                    bottom:
                        20), // Padding between the result text and the buttons
                child: Text(
                  resultIndex == 7 ? '정상 호흡입니다.' : '비정상 호흡입니다.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: resetTimer,
              child: Text('다시하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            if (isTimerFinished)
              ElevatedButton(
                onPressed: () async {
                  await _saveToFirestore();
                  Get.snackbar(
                    "등록 완료",
                    "호흡수가 성공적으로 저장되었습니다.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.deepPurple[200],
                    colorText: Colors.grey[850],
                    icon: Icon(Icons.check_circle, color: Colors.amber),
                  );

                  // 2초 후에 페이지 이동
                  Future.delayed(Duration(seconds: 2), () {
                    Get.offNamed(
                        '/'); // '/mainhome'은 이동할 페이지의 경로입니다. 변경할 수 있습니다.
                  });
                },
                child: Text(
                  '저장하기',
                  style: TextStyle(color: Colors.deepPurple),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
