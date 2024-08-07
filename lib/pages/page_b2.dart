import 'package:flutter/material.dart';


class PageB2 extends StatefulWidget {
  const PageB2({Key? key}) : super(key: key);

  @override
  _PageB2State createState() => _PageB2State();
}

class _PageB2State extends State<PageB2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page B-2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page B-2', style: TextStyle(fontSize : 30)),
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