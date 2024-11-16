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
        // AppBar color
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[200],
          foregroundColor: Colors.black, // AppBar text's color
        ),
        // background color
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

//button toggle
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

//Mixin for implementing button animations in Flutter
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

       @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, //TickerProvider
        duration: Duration(milliseconds: 350),
        reverseDuration:
            Duration(milliseconds: 275) //Defines the duration of the animation when it plays in reverse
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
    //Reset the state when the page is reloaded
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

  //Floating button
  late AnimationController _controller;
  late Animation _animation;
  bool toggle = true; //Variable to manage the state of the curve navigation bar button

  Alignment alignment1 = Alignment(0.0, 5.0);
  Alignment alignment2 = Alignment(0.0, 5.0);
  Alignment alignment3 = Alignment(0.0, 5.0);
  double size1 = 0.0;
  double size2 = 0.0;
  double size3 = 0.0;
  
  ////Used to maintain page state when using CurvedNavigationBar
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
  

  //Page navigation function
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
              color: Colors.deepPurple.shade200, // bar color
              animationDuration: Duration(milliseconds: 300), //bar animation speed
              onTap: (index) {
                setState(() {
                  _pageIndex = index;
                  print(index);
                });
                _pageController.jumpToPage(index);
              },
              items: const [
                Icon(
                  Icons.home, 
                  color: Colors.black87, 
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
                //First add button
                duration: toggle
                    ? const Duration(milliseconds: 275)
                    : const Duration(milliseconds: 875),
                alignment: alignment1,
                curve: toggle ? Curves.easeIn : Curves.elasticInOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 275),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size1,
                  width: size1,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      borderRadius: BorderRadius.circular(40.0)),
                  child: GestureDetector(
                    onTap: () => _navigateToPage(const PageC2(
                      title: '반려동물 정보 입력',
                    )),
                    child: const Icon(Icons.pets, color: Colors.black87),
                  ),
                ),
              ),
              AnimatedAlign(
                //Second add button
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
                    onTap: () => _navigateToPage(const PageC3(
                      title: '반려동물케어',
                    )),
                    child: const Icon(Icons.note_alt_outlined, color: Colors.black87),
                  ),
                ),
              ),
              AnimatedAlign(
                //Third add button
                duration: toggle
                    ? const Duration(milliseconds: 275)
                    : const Duration(milliseconds: 875),
                alignment: alignment3,
                curve: toggle ? Curves.easeIn : Curves.elasticInOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 275),
                  curve: toggle ? Curves.easeIn : Curves.easeOut,
                  height: size3,
                  width: size3,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple.shade200,
                      borderRadius: BorderRadius.circular(40.0)),
                  child: GestureDetector(
                    onTap: () => _navigateToPage(Scheduler(
                      title: '반려동물 일정',
                    )),
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
                      //The + button icon rotates
                      angle: _animation.value * pi * (3 / 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 375),
                        curve:
                            Curves.easeOut, // Effect that gradually slows down the animation during its progress //
                        height: toggle ? 50.0 : 50.0, //Effect where the button grows and shrinks 
                        width: toggle ? 50.0 : 50.0,
                        child: Material(
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(40.0),
                          child: IconButton(
                            splashColor: Colors.black54, //Effect where the button expands when clicked
                            splashRadius: 20.0,
                            onPressed: () {
                              setState(() {
                                if (toggle) {
                                  toggle = !toggle;
                                  _controller.forward();
                                  Future.delayed(Duration(milliseconds: 10),
                                      () {
                                    //Delay time for the icon to pop out
                                    alignment1 =
                                        Alignment(-0.28, 0.75); //Adjust icon position
                                    size1 = 40.0;
                                  });
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    alignment2 = Alignment(0.0, 0.68);
                                    size2 = 40.0;
                                  });
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    alignment3 = Alignment(0.28, 0.75);
                                    size3 = 40.0;
                                  });
                                } else {
                                  toggle = !toggle;
                                  _controller.reverse();
                                  alignment1 = const Alignment(0.0, 5.0);
                                  alignment2 = const Alignment(0.0, 5.0);
                                  alignment3 = const Alignment(0.0, 5.0);
                                  size1 = size2 = size3 = 0.0;
                                }
                              });
                            },
                            icon: const Icon(
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
      backgroundColor: Colors.deepPurple, 
    );
  }
}
