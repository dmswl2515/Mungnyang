import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:totalexam/mainhome.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreenNF extends StatefulWidget {
  const LoginScreenNF({super.key});

  @override
  State<LoginScreenNF> createState() => _LoginScreenNFState();
}

class _LoginScreenNFState extends State<LoginScreenNF> {

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: getNaverLoiginButton(),
      ),
    );
  }
  
  void navigateToMainPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Mainhome(),
    ));
  }


    // Future<void> signInWithNaver() async {
    //   await FlutterNaverLogin.logIn().then((value) async {
    //     print('value from naver $value');

    //     NaverAccessToken res = await FlutterNaverLogin.currentAccessToken; 
    //     var accesToken = res.accessToken;
    //     fetchNaverUserDetail(accesToken);

    //     var tokenType = res.tokenType;

    //     print("accesToken $accesToken");
    //     print("tokenType $tokenType");

    //     navigateToMainPage();
    //   });  
    // }

    Future<void> signInWithNaver() async {
      String clientId = 'WBMuvkQMqt5AxKGz1Q_X';
      String redirectUri = 'https://us-central1-dmswl2515.cloudfunctions.net/naverLoginCallback';
      String state = base64Url.encode(List<int>.generate(16, (_) => Random().nextInt(255)));
      Uri url = Uri.parse('https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&state=$state');
      print("네이버 로그인 열기 & 클라우드 평션 부름");
      await launchUrl(url);
    }

    Future<void> initUniLinks() async {
      final initialLink = await getInitialLink();
      if(initialLink != null) _handleDeepLink(initialLink);

      linkStream.listen((String? link) {
        _handleDeepLink(link!);
      }, onError: (err, stacktrace) {
        print("딥링크 에러 $err\n$stacktrace");
      });
    }

    Future<void> _handleDeepLink(String link) async {
      print("딥링크 열기 $link");
      final Uri uri = Uri.parse(link);

      if(uri.authority == 'login-callback') {
        String? firebaseToken = uri.queryParameters['firebaseToken'];
        String? name = uri.queryParameters['name'];
        String? profileImage = uri.queryParameters['profileImage'];

        print("name $name");
        
        await FirebaseAuth.instance.signInWithCustomToken(firebaseToken!).then((value) =>
        navigateToMainPage()
        ).onError((error, stackTrace) {
          print("error $error");
        });

        }
    }



    Future<void> fetchNaverUserDetail(String accessToken) async {
      final response = await http.get(
        Uri.parse('https://openapi.naver.com/v1/nid/me'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
            print('value from naver $responseJson');
    }

  

  //네이버 로그인 버튼
  Widget getNaverLoiginButton() {
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
          height: 100,
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

  //네이버 로그아웃
  Future<void> naverlogout() async {
    try {
      await FlutterNaverLogin.logOutAndDeleteToken().then((value) => {
        print("logout successful"),
        Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreenNF(),
        ))
      });  
    } catch (e) {
      
    }
  }

  Future<void> buttonLogoutAndDeleteTokenPressed() async {
    try {
      await FlutterNaverLogin.logOutAndDeleteToken();
    } catch (e) {
      
    }
  }

  //여러 로그아웃 처리함수
  Future<void> logout() async {
    bool logoutSuccessful = false;

    try{
      await naverlogout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    }
    catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }
}

