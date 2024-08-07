import 'package:flutter/material.dart';



class PageE2 extends StatefulWidget {
  const PageE2({Key? key}) : super(key: key);

  @override
  _PageE2State createState() => _PageE2State();
}

class _PageE2State extends State<PageE2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page E-2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page E-2', style: TextStyle(fontSize : 30)),
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