import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalexam/controllers/user_controller.dart';
import 'package:totalexam/mainhome.dart';
import 'package:totalexam/pages/page_d1.dart';
import 'package:totalexam/screens/login_screen.dart';
import 'package:totalexam/screens/splash_screen.dart';

import 'db/db_helper.dart';
import 'reference/constants.dart';
import 'reference/text_provider.dart';

FirebaseOptions get firebaseOptions => const FirebaseOptions(
      appId: '1:58500999507:android:7342902a060c0615d199a6',
      apiKey: 'AIzaSyA6zQKGghYi8wqZKqUuk1741Wg1xmVINQI',
      projectId: 'flutter-total-f3299',
      messagingSenderId: '58500999507', // 프로젝트 번호
      storageBucket: 'flutter-total-f3299.appspot.com',
    );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    //web에서 사용하는 것
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(0, 133, 204, 137),
    ),
  );
  //make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  Gemini.init(apiKey: GEMINI_API_KEY);

  await Firebase.initializeApp(options: firebaseOptions);
  await DbHelper.initDb(); // 데이터베이스 초기화
  await GetStorage.init();

  Get.put(UserController());

  runApp(
    ChangeNotifierProvider(
      create: (context) => TextProvider(), // TextProvider를 제공
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
