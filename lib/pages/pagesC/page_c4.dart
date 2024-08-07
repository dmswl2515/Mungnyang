import 'package:flutter/material.dart';



class PageC4 extends StatefulWidget {
  const PageC4({Key? key, required String title}) : super(key: key);

  @override
  _PageC4State createState() => _PageC4State();
}

class _PageC4State extends State<PageC4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('반려동물 일정(Page C-4)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page C-4', style: TextStyle(fontSize : 30)),
            const SizedBox(height: 30,),
            ElevatedButton(
              child: const Text('2페이지 제거',
                                style: TextStyle(fontSize: 24)),
              onPressed: () {
                Navigator.pop(context);
              }, 
            ),
          ],
        ),
      )
    );
  }
}