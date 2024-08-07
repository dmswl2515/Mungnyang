import 'dart:async';
import 'package:flutter/material.dart';



class PageC39 extends StatefulWidget {
  final int number;
  
  PageC39({required this.number});

  @override
  State<PageC39> createState() => _PageC39State();
}

class _PageC39State extends State<PageC39> {
  bool isStart = false;
  late Timer timer;
  late int seconds;

  @override
  void initState() {
    super.initState();
    // 생성자에서 전달받은 number로 seconds 초기화
    seconds = widget.number;
  }
 
  
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void stopTimer() {
    setState(() {
      timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page C3_9'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          seconds.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 100,),
        Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: seconds / widget.number,
                    strokeWidth: 15,
                    backgroundColor: Colors.red.withOpacity(0.2),
                    color: Colors.red,
                  ),
                  // 애니메이션 효과를 위해 AnimatedSwitcher 사용
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isStart
                        ? Center(
                            key: ValueKey<bool>(true),
                            child: Container(
                              // padding: const EdgeInsets.only(top: 30, bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // 애니메이션 효과를 위해 AnimatedOpacity 사용
                                  AnimatedOpacity(
                                    opacity: isStart ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isStart = !isStart;
                                        });
                                        stopTimer();
                                      },
                                      icon: Icon(Icons.pause, size: 30, color: Colors.red),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: isStart ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Text(
                                      'pause',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : IconButton(
                            key: ValueKey<bool>(false),
                            onPressed: () {
                              setState(() {
                                isStart = !isStart;
                              });
                              startTimer();
                            },
                            icon: Icon(Icons.pets, size: 30, color: Colors.red),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
