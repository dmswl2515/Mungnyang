import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalexam/controllers/user_controller.dart';
import 'package:totalexam/mainhome.dart';
import 'package:totalexam/pages/page_d1.dart';
import 'package:totalexam/screens/login_screen.dart';
import 'package:totalexam/screens/splash_screen.dart';
import 'package:totalexam/reference/Config/index.dart' as app_config;
import 'package:google_fonts/google_fonts.dart';

import 'db/db_helper.dart';
import 'reference/constants.dart';
import 'reference/text_provider.dart';

FirebaseOptions get firebaseOptions => const FirebaseOptions(
      appId: app_config.Config.FIREBASE_APP_ID,
      apiKey: app_config.Config.FIREBASE_API_KEY,
      projectId: app_config.Config.FIREBASE_PROJECT_ID,
      messagingSenderId: app_config.Config.FIREBASE_MESSAGING_SENDER_ID,
      storageBucket: app_config.Config.FIREBASE_STORAGE_BUCKET,
    );

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(0, 133, 204, 137),
    ),
  );
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  Gemini.init(apiKey: app_config.Config.GEMINI_API_KEY);

  await Firebase.initializeApp(options: firebaseOptions);
  await DbHelper.initDb(); //Database initialization
  await GetStorage.init();

  Get.put(UserController());

  runApp(
    ProviderScope (
      child: legacy_provider.ChangeNotifierProvider(
        create: (context) => TextProvider(),
        child: MyApp(),
      ),
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
        textTheme: GoogleFonts.juaTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      //home: LoginScreen(),
      home: Mainhome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
