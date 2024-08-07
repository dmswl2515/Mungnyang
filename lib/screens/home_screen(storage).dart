import 'package:flutter/material.dart';
import 'package:totalexam/imageupload/image_retrive.dart';
import 'package:totalexam/imageupload/image_upload.dart';

class Storage extends StatefulWidget {
  const Storage({super.key, required this.title});

  final String title;
  
  @override
  State<Storage> createState() => _Storage();
}

class _Storage extends State<Storage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Firebase Storage"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageUpload(),
                    ),
                  );
                },
                child: const Text("Upload Image"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageRetrive(),
                    ),
                  );
                },
                child: const Text("Show Uploads"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
