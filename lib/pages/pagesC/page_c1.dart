import 'package:flutter/material.dart';
import 'package:totalexam/presentation/features/pet/screens/pet_registration_screen.dart';
import '../../reference/drawer.dart';
import 'page_c3.dart';
import 'page_c4.dart';

class PageC1 extends StatefulWidget {
  const PageC1({Key? key}) : super(key: key);

  @override
  _PageC1State createState() => _PageC1State();
}

class _PageC1State extends State<PageC1> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page C1'),
      ),
      drawer: AppDrawer(), // AppDrawer 사용
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page C-1', style: TextStyle(fontSize : 30)),
            const SizedBox(height: 30,),
            ElevatedButton(
              child: const Text('반려동물 추가',
                                style: TextStyle(fontSize: 24)),
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const PageA2()),
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) => const PetRegistrationsScreen(),
                    transitionDuration: const Duration(seconds : 0), 
                  ), 
                );
              }, 
            ),
            ElevatedButton(
              child: const Text('반려동물 케어',
                                style: TextStyle(fontSize: 24)),
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const PageA2()),
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) => const PageC3(title: '반려동물케어(Page C-3)',),
                    transitionDuration: const Duration(seconds : 0), 
                  ), 
                );
              }, 
            ),
            ElevatedButton(
              child: const Text('일정 등록',
                                style: TextStyle(fontSize: 24)),
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const PageA2()),
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) => const PageC4(title: '반려동물 일정(Page C-4)',),
                    transitionDuration: const Duration(seconds : 0), 
                  ), 
                );
              }, 
            ),
          ],
        ),
      )
    );
  }
}