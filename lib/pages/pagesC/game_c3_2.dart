import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:like_button/like_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random _random = Random();
  late Timer _timer;
  late ConfettiController _confettiController;
  int _score = 0;
  double _bugX = 0.0;
  double _bugY = 0.0;
  bool _isBugVisible = true;
  double _bugOpacity = 1.0;
  double _bugSize = 80.0; // LikeButton의 사이즈에 맞춰서 조정
  bool _gameEnded = false; // 게임 종료 상태를 관리하는 변수

  double? _secondBugX;
  double? _secondBugY;
  bool _isSecondBugVisible = false;
  double _secondBugOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _startGame();
  }

  void _startGame() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _moveBug();
      if (_isSecondBugVisible) {
        _moveSecondBug();
      }
    });
  }

  void _moveBug() {
    if (!_gameEnded) {
      // 게임이 끝났을 때는 벌레를 이동시키지 않음
      setState(() {
        _bugX = _random.nextDouble() *
            (MediaQuery.of(context).size.width - _bugSize);
        _bugY = _random.nextDouble() *
            (MediaQuery.of(context).size.height - _bugSize);
      });
    }
  }

  void _moveSecondBug() {
    if (!_gameEnded) {
      setState(() {
        _secondBugX = _random.nextDouble() *
            (MediaQuery.of(context).size.width - _bugSize);
        _secondBugY = _random.nextDouble() *
            (MediaQuery.of(context).size.height - _bugSize);
      });
    }
  }

  Future<bool> _onBugTap(bool isTapped) async {
    if (_gameEnded) return !isTapped; // 게임이 끝난 후에는 아무런 동작도 하지 않음

    setState(() {
      _score++;
      _bugOpacity = 0.0; // 벌레를 사라지게 함

      if (_score == 5) {
        _isSecondBugVisible = true; // 점수가 5점일 때 두 번째 벌레를 보이게 함
      }

      if (_score == 10) {
        _confettiController.play(); // 점수가 10점일 때 Confetti 재생
        _gameEnded = true; // 게임 종료 상태로 변경
      }
    });

    Future.delayed(Duration(milliseconds: 600), () {
      if (!_gameEnded) {
        // 게임이 끝났다면 벌레를 다시 보이게 하지 않음
        setState(() {
          _bugOpacity = 1.0;
          _moveBug();
        });
      }
    });

    return !isTapped;
  }

  Future<bool> _onSecondBugTap(bool isTapped) async {
    if (_gameEnded) return !isTapped; // 게임이 끝난 후에는 아무런 동작도 하지 않음

    setState(() {
      _score++;
      _secondBugOpacity = 0.0; // 두 번째 벌레를 사라지게 함

      if (_score == 10) {
        _confettiController.play(); // 점수가 10점일 때 Confetti 재생
        _gameEnded = true; // 게임 종료 상태로 변경
      }
    });

    Future.delayed(Duration(milliseconds: 600), () {
      if (!_gameEnded) {
        // 게임이 끝났다면 벌레를 다시 보이게 하지 않음
        setState(() {
          _secondBugOpacity = 1.0;
          _moveSecondBug();
        });
      }
    });

    return !isTapped;
  }

  @override
  void dispose() {
    _timer.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: Text('고양이 게임'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[200],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              '점수: $_score',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (!_gameEnded && _isBugVisible)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              left: _bugX,
              top: _bugY,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _bugOpacity,
                child: LikeButton(
                  size: _bugSize,
                  animationDuration: Duration(milliseconds: 700),
                  isLiked: false,
                  likeBuilder: (isTapped) {
                    return Image.asset(
                      'assets/images/bug.png',
                      width: _bugSize,
                      height: _bugSize,
                    );
                  },
                  onTap: _onBugTap,
                ),
              ),
            ),
          if (_isSecondBugVisible)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              left: _secondBugX,
              top: _secondBugY,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _secondBugOpacity,
                child: LikeButton(
                  size: _bugSize,
                  animationDuration: Duration(milliseconds: 700),
                  isLiked: false,
                  likeBuilder: (isTapped) {
                    return Image.asset(
                      'assets/images/bug3.png',
                      width: _bugSize,
                      height: _bugSize,
                    );
                  },
                  onTap: _onSecondBugTap,
                ),
              ),
            ),
          if (_gameEnded)
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Color.fromARGB(255, 255, 173, 173),
                  Color.fromARGB(255, 255, 214, 165),
                  Color.fromARGB(255, 253, 255, 182),
                  Color.fromARGB(255, 202, 255, 191),
                  Color.fromARGB(255, 188, 212, 230),
                  Color.fromARGB(255, 155, 246, 255),
                  Color.fromARGB(255, 160, 196, 255),
                  Color.fromARGB(255, 189, 178, 255),
                  Color.fromARGB(255, 255, 0, 0),
                  Color.fromARGB(255, 255, 135, 0),
                  Color.fromARGB(255, 255, 211, 0),
                  Color.fromARGB(255, 222, 255, 10),
                  Color.fromARGB(255, 161, 255, 10),
                  Color.fromARGB(255, 10, 255, 153),
                  Color.fromARGB(255, 10, 239, 255),
                  Color.fromARGB(255, 20, 125, 245),
                  Color.fromARGB(255, 88, 10, 255),
                  Color.fromARGB(255, 190, 10, 255),
                ],
              ),
            ),
          if (_gameEnded) // 게임이 끝난 상태에서만 "축하합니다" 메시지를 표시
            Center(
              child: Text(
                '축하합니다!',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[300],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
