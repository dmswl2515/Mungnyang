import 'package:flutter/material.dart';

class PageA2 extends StatefulWidget {
  const PageA2({Key? key}) : super(key: key);

  @override
  _PageA2State createState() => _PageA2State();
}

class _PageA2State extends State<PageA2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Page A-2'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Page A-2', style: TextStyle(fontSize: 30)),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text('2페이지 제거', style: TextStyle(fontSize: 24)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
