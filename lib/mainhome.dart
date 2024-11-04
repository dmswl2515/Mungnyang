import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:totalexam/pages/pagesC/page_c2(%EB%B0%98%EB%A0%A4%EB%8F%99%EB%AC%BC%EC%A0%95%EB%B3%B4%EC%9E%85%EB%A0%A5).dart';
import 'package:totalexam/pages/pagesC/pet_activites/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:totalexam/reference/constants.dart';
import 'db/db_helper.dart';
import 'reference/drawer.dart';
import 'pages/page_a1.dart';
import 'pages/page_b1.dart';
import 'pages/pagesC/page_c1.dart';
import 'pages/pagesC/page_c3.dart';
import 'pages/page_d1.dart';
import 'pages/page_e1.dart';
import 'dart:math';
import 'reference/text_provider.dart';
import 'services/theme_services.dart';
import 'reference/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:totalexam/screens/musichome_screen.dart';
import 'package:totalexam/screens/playlist_screen.dart';
import 'package:totalexam/screens/song_screen.dart';

class Mainhome extends StatefulWidget {
  const Mainhome({
    super.key,
  });

  @override
  State<Mainhome> createState() => _MainhomeState();
}

class _MainhomeState extends State<Mainhome> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'mainhome',
      theme: ThemeData(
        // AppBar 색상
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[200],
          foregroundColor: Colors.black, // AppBar의 텍스트 색상
        ),
        // 배경 색상
        scaffoldBackgroundColor: Color(0xFFD1C4E9),
      ),
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MyHomePage(
          title: 'mainhome',
          userName: '',
          userEmail: '',
          userProfileImage: '',
        )),
        GetPage(name: '/musichome', page: () => const MusichomeScreen()),
        GetPage(name: '/mainhome', page: () => const Mainhome()),
        GetPage(name: '/pageC1', page: () => const PageC1()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

//버튼 토글
bool toggle = true;

class MyHomePage extends StatefulWidget {
  final String title;
  final String userName;
  final String userEmail;
  final String userProfileImage;

  const MyHomePage(
      {super.key,
      required this.title,
      required this.userName,
      required this.userEmail,
      required this.userProfileImage});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Flutter에서 애니메이션을 구현할 때 사용하는 믹스인(버튼)
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

       @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, //TickerProvider를 지정
        duration: Duration(milliseconds: 350),
        reverseDuration:
            Duration(milliseconds: 275) //애니메이션이 반대 방향으로 진행될 때의 지속 시간을 정의
        );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

    @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 페이지가 다시 보일 때 상태를 초기화
    if (ModalRoute.of(context)?.settings.name == '/') {
      setState(() {
        toggle = true;
        _controller.reverse();
        alignment1 = Alignment(0.0, 5.0);
        alignment2 = Alignment(0.0, 5.0);
        alignment3 = Alignment(0.0, 5.0);
        size1 = size2 = size3 = 0.0;
      });
    }
  }

  ////////////////////////버튼//////////////////////////////////////
  late AnimationController _controller;
  late Animation _animation;
  bool toggle = true; //curve navigationbar 버튼의 상태를 관리하기 위한 변수

  //버튼 여러개 설정 
  Alignment alignment1 = Alignment(0.0, 5.0);
  Alignment alignment2 = Alignment(0.0, 5.0);
  Alignment alignment3 = Alignment(0.0, 5.0);
  double size1 = 0.0;
  double size2 = 0.0;
  double size3 = 0.0;
  ////////////////////////버튼//////////////////////////////////////

  //CurvedNavigationBar사용할 때 페이지 상태 유지하기위해 사용//
  int _pageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Widget> _buildScreens() {
    return [
      const PageA1(),
      const PageB1(),
      const PageC1(),
      const PageD1(),
      const PageE1(),
    ];
  }
  ///////////////CurbedNavigationBar///////////////////////////////

  // 페이지 이동 함수
  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _pageIndex = index;
              });
            },
            children: _buildScreens(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CurvedNavigationBar(
              index: _pageIndex,
              backgroundColor: Colors
                  .transparent, // Makes sure the background is not visible
              // backgroundColor: Colors.deepPurple, // bar 배경색
              color: Colors.deepPurple.shade200, // bar 색깔
              animationDuration: Duration(milliseconds: 300), //bar 애니메이션 속도
              onTap: (index) {
                setState(() {
                  _pageIndex = index;
                  print(index);
                });
                _pageController.jumpToPage(index);
              },
              items: const [
                Icon(
                  Icons.home, //아이콘
                  color: Colors.black87, // 아이콘 색깔
                ),
                Icon(
                  Icons.bar_chart,
                  color: Colors.black87,
                ),
                // Dummy icon to keep the space for animated buttons
                Icon(
                  Icons.add,
                  color: Colors.transparent,
                ),
                Icon(
                  FontAwesomeIcons.solidHeart,
                  size: 19,
                  color: Colors.black87,
                ),
                Icon(
                  Icons.person,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              AnimatedAlign(
                //첫번째 추가 버튼
                duration: toggle
                    ? const Duration(milliseconds: 275)
                    : const Duration(milliseconds: 875),
                alignment: alignment1,
                curve: toggle ? Curves.easeIn : Curves.elasticInOut,
                child: AnimatedContainer(
                  //첫번째 추가 버튼
                  duration: const Duration(milliseconds: 275),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size1,
                  width: size1,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      borderRadius: BorderRadius.circular(40.0)),
                  child: GestureDetector(
                    onTap: () => _navigateToPage(const PageC2(
                      title: '반려동물 정보 입력(Page C-2)',
                    )), // 버튼 클릭 시 Page1으로 이동
                    child: const Icon(Icons.pets, color: Colors.black87),
                  ),
                ),
              ),
              AnimatedAlign(
                //두번째 추가 버튼
                duration: toggle
                    ? const Duration(milliseconds: 275)
                    : const Duration(milliseconds: 875),
                alignment: alignment2,
                curve: toggle ? Curves.easeIn : Curves.elasticInOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 275),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size2,
                  width: size2,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      borderRadius: BorderRadius.circular(40.0)),
                  child: GestureDetector(
                    onTap: () => _navigateToPage(PageC3(
                      title: '반려동물케어(Page C-3)',
                    )), // 버튼 클릭 시 Page1으로 이동
                    child: Icon(Icons.note_alt_outlined, color: Colors.black87),
                  ),
                ),
              ),
              AnimatedAlign(
                //세번째 추가 버튼
                duration: toggle
                    ? Duration(milliseconds: 275)
                    : Duration(milliseconds: 875),
                alignment: alignment3,
                curve: toggle ? Curves.easeIn : Curves.elasticInOut,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 275),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size3,
                  width: size3,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      borderRadius: BorderRadius.circular(40.0)),
                  child: GestureDetector(
                    onTap: () => _navigateToPage(HomePage(
                      title: '반려동물 일정(Page C-4)',
                    )), // 버튼 클릭 시 Page1으로 이동
                    child: Icon(Icons.calendar_month, color: Colors.black87),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 580),
                  child: Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      //+버튼의 아이콘이 돌아감
                      angle: _animation.value * pi * (3 / 4),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 375),
                        curve:
                            Curves.easeOut, //애니메이션이 진행되는 동안 속도가 점점 느려지게 하는 효과
                        height: toggle ? 50.0 : 50.0, //버튼이 커졌다가 작아졌다하는 효과
                        width: toggle ? 50.0 : 50.0,
                        child: Material(
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(40.0),
                          child: IconButton(
                            splashColor: Colors.black54, //버튼을 누르면 퍼지는 효과
                            splashRadius: 20.0,
                            onPressed: () {
                              setState(() {
                                if (toggle) {
                                  toggle = !toggle;
                                  _controller.forward();
                                  Future.delayed(Duration(milliseconds: 10),
                                      () {
                                    //아이콘이 튀어나오는 delayed되는 시간
                                    alignment1 =
                                        Alignment(-0.28, 0.75); //아이콘 위치 조절
                                    size1 = 40.0;
                                  });
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    //아이콘이 튀어나오는 delayed되는 시간
                                    alignment2 = Alignment(0.0, 0.68);
                                    size2 = 40.0;
                                  });
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    //아이콘이 튀어나오는 delayed되는 시간
                                    alignment3 = Alignment(0.28, 0.75);
                                    size3 = 40.0;
                                  });
                                } else {
                                  toggle = !toggle;
                                  _controller.reverse();
                                  alignment1 = Alignment(0.0, 5.0);
                                  alignment2 = Alignment(0.0, 5.0);
                                  alignment3 = Alignment(0.0, 5.0);
                                  size1 = size2 = size3 = 0.0;
                                }
                              });
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple, //전체 배경색
    );
  }
}
