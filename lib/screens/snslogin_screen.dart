import 'package:flutter/material.dart';

class SnsloginScreen extends StatefulWidget {
  const SnsloginScreen({super.key});

  @override
  State<SnsloginScreen> createState() => _SnsloginScreenState();
}

class _SnsloginScreenState extends State<SnsloginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.abc),
          )
        ],
      )
    );
  }
}