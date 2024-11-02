import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalexam/controllers/user_controller.dart';
import 'package:totalexam/mainhome.dart';
import 'package:totalexam/pages/page_a1.dart';
import 'package:totalexam/reference/drawer.dart';
import 'package:totalexam/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailField = Container(
      width: 300,
      child: TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\\.[a-z]").hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "이메일",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

    final passwordField = Container(
      width: 300,
      child: TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "비밀번호",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

    final loginButton = Container(
      width: 300,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepPurple[300],
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          height: 80,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(width: 10),
              const Text(
                "이메일 로그인",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Color(0xFFD1C4E9),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.deepPurple[100],
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/부비.png', width: 250),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 20),
                    loginButton,
                    getNaverLoginButton(),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("아이디가 없으신가요? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegistrationScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "회원가입 하기",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
  if (_formKey.currentState!.validate()) {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
        .then((uid) async {
          // 로그인 성공 시 사용자 정보를 업데이트합니다.
          final userController = Get.find<UserController>();
          // 예를 들어, Firebase에서 사용자 정보를 가져오는 경우
          final user = _auth.currentUser;
          if (user != null) {
            final userProfileImage = user.photoURL ?? 'default_profile_image_url';
            userController.setUser(user.displayName ?? 'Unknown', user.email ?? 'Unknown', userProfileImage);
          }
          showSnackBar("Login Successful", const Duration(milliseconds: 1000));
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Mainhome()));
        })
        .catchError((e) {
          showSnackBar(e.message, const Duration(milliseconds: 3000));
        });
    } catch (e) {
      showSnackBar(e.toString(), const Duration(milliseconds: 3000));
    }
  }
}

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithNaver() async {
    await FlutterNaverLogin.logIn().then((value) async {
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      var accessToken = res.accessToken;
      fetchNaverUserDetail(accessToken);

      print("accesToken $accessToken");
    });
  }

  Future<void> fetchNaverUserDetail(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/nid/me'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      },
    );
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    String name = responseJson['response']['name'];
    String email = responseJson['response']['email'];
    String profileImage = responseJson['response']['profile_image'];

    UserController userController = Get.find();
    userController.setUser(name, email, profileImage);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Mainhome(),
      ),
    );
  }

  Widget getNaverLoginButton() {
    return InkWell(
      onTap: () {
        signInWithNaver();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 2,
        child: Ink.image(
          image: const AssetImage('assets/login/naver.png'),
          fit: BoxFit.cover,
          height: 80,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.transparent,
            ),
            child: null,
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await FlutterNaverLogin.logOutAndDeleteToken();
      print('로그아웃 성공');
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }
}
