import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:totalexam/pages/pagesC/page_c3.dart';
import 'package:totalexam/pages/pagesC/timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:totalexam/screens/musichome_screen.dart';
import '../reference/drawer.dart';
import '../reference/text_provider.dart';
import 'map_page.dart';
import 'pagesC/Liten_c3_2.dart';
import 'pagesC/game_c3_2.dart';

class PageA1 extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userProfileImage;

  const PageA1({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userProfileImage,
  }) : super(key: key);

  
  
  @override
  _PageA1State createState() => _PageA1State();
}

class _PageA1State extends State<PageA1> {
  //floating button
  // final isDialOpen = ValueNotifier(false); //뒤로 가기 버튼 누를 때 floating 버튼 꺼지게하는 코드
  bool isDialOpen = false;

  //dark and night mode
  bool isSwitch = false;

  late String userName;
  late String userEmail;
  late String userProfileImage;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    userEmail = widget.userEmail;
    userProfileImage = widget.userProfileImage;
  }


  @override
  Widget build(BuildContext context) {
    // User information for the drawer
    


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: const Text('멍냥멍냥',
                  style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle : true,
      ),
      drawer: AppDrawer(), // AppDrawer 사용
      body: Stack(
        children: [
          AnimatedSwitcher(
            //배경
            duration: Duration(milliseconds: 500),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                //배경색
                isSwitch == false ? HexColor('E0144C') : HexColor('2D033B'),
                isSwitch == false ? HexColor('FFE15D') : HexColor('810CAB')
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    //해 애니메이션
                    duration: const Duration(milliseconds: 800),
                    bottom: isSwitch == false ? 5 : -500,
                    child: SizedBox(
                      height: 900,
                      width: 400,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Lottie.network(
                                'https://assets5.lottiefiles.com/packages/lf20_xcvaucib.json',
                                fit: BoxFit.contain),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                //해 정중앙
                                height: 130,
                                width: 130,
                                decoration: const BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    //바닥 배경
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/mountain.png'),
                          fit:
                              BoxFit.fitHeight, // 이미지의 세로를 컨테이너에 맞추고 비율을 유지합니다.
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 320, left: 20),
                      child: Image.asset(
                        'assets/images/부비.png',
                        height: 230, // 적절한 높이를 설정하세요
                        width: 230, // 적절한 너비를 설정하세요
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
              //realtime으로 실시간 정보 공유
              child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: isSwitch == false
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.5),
            ),
          )),
          Center(
            //위치 고정 필요
            child: Consumer<TextProvider>(
              builder: (context, textProvider, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Text(
                    textProvider.currentText,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ),
          Positioned(
              //dark and night 스위치
              top: 5,
              right: 16,
              child: SizedBox(
                width: 70,
                child: DayNightSwitcher(
                    dayBackgroundColor:
                        const Color.fromARGB(255, 255, 231, 153),
                    isDarkModeEnabled: isSwitch,
                    onStateChanged: (bool value) {
                      setState(() {
                        isSwitch = value;
                      });
                    }),
              )),
          Positioned(
            top: 0,
            left: 0,
            child: buildSpeedDial(),
          ),
        ],
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      icon: Icons.fast_forward_rounded,
      direction: SpeedDialDirection.right,
      // animatedIcon: AnimatedIcons.menu_close, //메뉴
      backgroundColor: const Color.fromARGB(0, 0, 0, 0), //메뉴 배경색
      elevation: 0,
      // overlayColor: Colors.black, //버튼을 클릭했을 때의 배경색(이게 없으면 투명한 하얀색이 됌)
      overlayOpacity: 0.4, //버튼 클릭시 배경색의 투명도 지정
      spacing: 0, //각 아이콘 버튼 사이의 간격을 설정
      spaceBetweenChildren: 15, // 메인 버튼과 자식버튼 사이의 떨어짐 정도
      closeManually: false,
      // openCloseDial: isDialOpen,
      buttonSize: Size(70.0, 70.0), // 메인 버튼의 크기를 줄임
      childrenButtonSize: Size(45.0, 45.0), // 자식 버튼의 크기를 줄임
      renderOverlay: true,
      children: [
        SpeedDialChild(
          //식사
          child: Icon(
            FontAwesomeIcons.cutlery,
            size: 25,
          ),
          backgroundColor: const Color.fromARGB(0, 244, 67, 54), //아이콘 뒤의 배경색
          elevation: 0, //그림자 제거
          labelWidget: Text(
            '식사',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageC3(title: '반려동물케어(Page C-3)')));
          },
        ),
        SpeedDialChild(
          //산책
          child: Icon(
            Icons.directions_walk_sharp,
            size: 28,
          ),
          backgroundColor: const Color.fromARGB(0, 244, 67, 54), //아이콘 뒤의 배경색
          elevation: 0, //그림자 제거
          labelWidget: Text(
            '산책',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () {
            // MapPage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()),
            );
          },
        ),
        SpeedDialChild(
            //놀이
            child: Icon(
              Icons.sports_esports_sharp,
              size: 30,
            ),
            backgroundColor: const Color.fromARGB(0, 244, 67, 54), //아이콘 뒤의 배경색
            elevation: 0, //그림자 제거
            labelWidget: Text(
              '놀이',
              style: TextStyle(fontSize: 12),
            ),
            onTap: () {
              _showOptionsDialog(context);
            }),
        SpeedDialChild(
          //호흡수
          child: Icon(FontAwesomeIcons.heartbeat),
          backgroundColor: const Color.fromARGB(0, 244, 67, 54), //아이콘 뒤의 배경색
          elevation: 0, //그림자 제거
          labelWidget: Text(
            '호흡수',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            int? selectedNumber = await showDialog<int>(
              //모달
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.deepPurple[100],
                  title: Text('호흡 측정을 시작합니다'),
                  content: Text(
                    '몇 초 동안 측정할까요?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15), // 텍스트 중앙 정렬
                  ),
                  actions: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.yellow),
                              minimumSize: WidgetStateProperty.all(
                                  Size(80, 50)), // 버튼 크기 조정
                              textStyle: WidgetStateProperty.all(TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)), // 텍스트 크기 조정
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(30);
                            },
                            child: Text(
                              '30초',
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.yellow),
                              minimumSize: WidgetStateProperty.all(
                                  Size(80, 50)), // 버튼 크기 조정
                              textStyle: WidgetStateProperty.all(TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)), // 텍스트 크기 조정
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(60);
                            },
                            child: Text('60초'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
            if (selectedNumber != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CircularTimer(
                          number: selectedNumber,
                        )),
              );
            }
          },
        ),
        SpeedDialChild(
          //일정
          child: Icon(FontAwesomeIcons.calendarCheck),
          backgroundColor: const Color.fromARGB(0, 244, 67, 54), //아이콘 뒤의 배경색
          elevation: 0, //그림자 제거
          labelWidget: Text(
            '일정',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () {
            // MapPage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()),
            );
          },
        ),
      ],
    );
  }

  void _showOptionsDialog(BuildContext context) async {
    // 사용자가 선택할 수 있는 다이얼로그
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[100],
          title: Text('재밌는 놀이 시간입니다'),
          content: Text(
            '어떤 놀이를 할까요?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.yellow),
                      minimumSize: WidgetStateProperty.all(Size(80, 50)),
                      textStyle: WidgetStateProperty.all(
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dialog를 닫고
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GamePage()), // 게임 페이지로 이동
                      );
                    },
                    child: Text('게임하기'),
                  ),
                  SizedBox(width: 20),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.yellow),
                      minimumSize: WidgetStateProperty.all(Size(80, 50)),
                      textStyle: WidgetStateProperty.all(
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dialog를 닫고
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MusichomeScreen()), // 노래 듣기 페이지로 이동
                      );
                    },
                    child: Text('음악듣기'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
