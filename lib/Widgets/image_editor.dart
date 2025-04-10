import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/model.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImagePickerEditorExample extends StatefulWidget {
  const ImagePickerEditorExample({super.key});

  @override
  _ImagePickerEditorExampleState createState() =>
      _ImagePickerEditorExampleState();
}

class _ImagePickerEditorExampleState extends State<ImagePickerEditorExample> {
  @override
  void initState() {
    // TODO: implement initState
    checkModel();
    super.initState();
  }

  void checkModel() {
    final data = {
      "name": "Raghav",
      "age": 30,
      "email": "raghav@gmail.com",
      "phone": "+919876543210",
      "bio": {
        "bio": "I am a software engineer",
        "profile_image": {
          "url": {
            "small_image": {
              "height": 100,
              "width": 100,
              "aspect_ratio": "1:1",
            },
            "medium_image": {
              "height": 100,
              "width": 100,
              "aspect_ratio": "1:1",
            },
            "large_image": {
              "height": 100,
              "width": 100,
              "aspect_ratio": "1:1",
            },
          },
        },
        "technology": ["Java, Python, C++"],
      }
    };
    // final response = jsonDecode(data.toString());

    final User dataResponse = User.fromJson(data);
    debugPrint(' Name: ${dataResponse.name}');
    debugPrint('Age: ${dataResponse.age}');
    debugPrint('${dataResponse.technology}');
    debugPrint('Image ${dataResponse.profileLargeImage.height}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker & Editor Example'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? results =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                if (results != null) {
                  List<File> files =
                      results.paths.map((path) => File(path ?? "")).toList();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProImageEditor.file(files.first,
                                  callbacks: ProImageEditorCallbacks(
                                onImageEditingComplete: (bytes) async {
                                  debugPrint("Editing Completed");
                                  await FilePicker.platform.saveFile(
                                      fileName: "editedFile.png",
                                      type: FileType.image,
                                      bytes: bytes);
                                  Navigator.pop(context);
                                },
                              ))));
                }
              },
              child: Text("Edit Image"))
        ],
      )),
    );
  }
}
