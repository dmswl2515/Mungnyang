import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageRetrive extends StatefulWidget {
  const ImageRetrive({super.key});

  @override
  State<ImageRetrive> createState() => _ImageRetriveState();
}

class _ImageRetriveState extends State<ImageRetrive> {

  late SharedPreferences prefs;
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      imgUrl = (prefs.getString("imageUrl") ?? "");
    });
    // print("get url : $imgUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your Images"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              imgUrl,
              height: 400,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
