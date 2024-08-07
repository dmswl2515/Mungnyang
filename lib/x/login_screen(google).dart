import 'package:flutter/material.dart';
import 'package:totalexam/mainhome.dart'; // Mainhome을 import합니다.
import 'package:totalexam/screens/registration_screen.dart'; // RegistrationScreen을 import합니다.
import 'package:totalexam/services/auth_service.dart'; // AuthService를 import합니다.


class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final AuthService _auth = AuthService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                isLoading
                    ? CircularProgressIndicator() // 로딩 중일 때 인디케이터 표시
                    : IconButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true; // 로딩 상태로 변경
                          });

                          final userCredential = await _auth.loginWithGoogle(); // Google 로그인 시도

                          setState(() {
                            isLoading = false; // 로딩 상태 해제
                          });

                          if (userCredential != null) {
                            // 로그인 성공 시 Mainhome으로 이동
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Mainhome()),
                            );
                          } else {
                            // 로그인 실패 시 오류 메시지 표시
                            showSnackBar("Google Sign-In Failed", Duration(seconds: 3));
                          }
                        },
                        icon: Icon(Icons.login), // Google 로그인 버튼 아이콘
                        iconSize: 50, // 아이콘 크기 설정
                        color: Colors.redAccent, // 아이콘 색상 설정
                      ),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => 
                                      const RegistrationScreen()));
                        },
                        child: const Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
