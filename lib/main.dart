import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? image;
  Future imageGalleryPicker () async {
    try {
      final imagePicked = await ImagePicker().pickImage(source:ImageSource.gallery);
      if (imagePicked == null) return null;
      
      final tempImage = File(imagePicked.path);
      image = tempImage;
      setState(() {
        image = tempImage;
      });
    } on Exception catch (error) {
        debugPrint("Error to load image! $error");
    }
  }
  Future imageCameraPicker () async {
    try {
      final imagePicked = await ImagePicker().pickImage(source:ImageSource.camera);
      if (imagePicked == null) return null;

      final tempImage = File(imagePicked.path);
      image = tempImage;
      setState(() {
        image = tempImage;
      });
    } on Exception catch (error) {
      if (kDebugMode) {
        print("Error to load image! $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  image != null ? ClipOval(
                    child: Image.file(
                      image!,
                      height: 250,
                    ),
                  ) : const Icon(Icons.image_outlined, size: 250, color: Colors.blue)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async{
                      PermissionStatus filePermission = await Permission.manageExternalStorage.request();
                      if (filePermission == PermissionStatus.granted) imageGalleryPicker();
                    }, label: const Text("Gallery"),
                    icon: const Icon(Icons.image),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async{
                      PermissionStatus cameraPermission = await Permission.camera.request();
                      if (cameraPermission == PermissionStatus.granted) imageCameraPicker();
                    }, label: const Text("Camera"),
                    icon: const Icon(Icons.camera),
                  )
                ],
              ),
            ],
          ),
        )
    );
  }
}
