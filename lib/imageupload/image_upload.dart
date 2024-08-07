import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No File selected", const Duration(milliseconds: 400));
      }
    });
  }

  Future uploadImage(File image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('/images')
        .child("post_$imgId");

    await reference.putFile(image);
    downloadURL = await reference.getDownloadURL();

    // 조회할 때 사용하기 위해 저장
    prefs.setString("imageUrl", downloadURL!);

    print("File Uploaded : $downloadURL");
    showSnackBar("File Uploaded", const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Upload Image "),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: Column(
                children: [
                  const Text("Upload Image"),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // the image that we wanted to upload
                            Expanded(
                              child: _image == null
                                  ? const Center(
                                      child: Text("No image selected"))
                                  : Image.file(_image!)
                            ),
                            ElevatedButton(
                              onPressed: () {
                                imagePickerMethod();
                              },
                              child: const Text("Select Image"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_image != null) {
                                  uploadImage(_image!);
                                } else {
                                  showSnackBar("Select Image first",
                                      const Duration(milliseconds: 400));
                                }
                              },
                              child: const Text("Upload Image"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
