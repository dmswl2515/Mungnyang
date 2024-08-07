import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totalexam/screens/home_screen(storage).dart';
import 'package:totalexam/screens/login_screen.dart';
import '../db/firestore.dart';
import '../x/login_screen(google).dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  String userEmail = "";

  @override
  Widget build(BuildContext context) {
    userEmail = user!.email!;

    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, 
                                 fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "[ $userEmail ]",
                style: const TextStyle(fontSize: 20, 
                                       fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                child: const Text('관리자 페이지',
                            style: TextStyle(fontSize: 24),),
                onPressed: () {
                  Navigator.push( //페이지간 이동이 있을 때 Navigator.push를 사용하기
                    context,
                    MaterialPageRoute(builder: (context) => const Firestore(title: '관리자페이지')), 
                  );
                },  
              ),
              ElevatedButton(
                child: const Text('사진 업로드',
                            style: TextStyle(fontSize: 24),),
                onPressed: () {
                  Navigator.push( //페이지간 이동이 있을 때 Navigator.push를 사용하기
                    context,
                    MaterialPageRoute(builder: (context) => const Storage(title: '사진 업로드')), 
                  );
                },  
              ),
              ElevatedButton(
                child: const Text('알림 메세지 확인',
                            style: TextStyle(fontSize: 24),),
                onPressed: () {
                  Navigator.push( //페이지간 이동이 있을 때 Navigator.push를 사용하기
                    context,
                    MaterialPageRoute(builder: (context) => const Storage(title: '알림 메세지 확인')), 
                  );
                },  
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
