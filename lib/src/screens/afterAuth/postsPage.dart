import 'dart:io';

import 'package:dash_chat/src/services/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  File? _image;
  String caption = "";
  bool isPressed = false;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Post stuff here" , style: TextStyle(
                fontSize: 30,
              ),),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.file(
                        _image!,
                        width: 300,
                        height: 300,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Text(" Pick from Gallery ")),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Caption",
                        ),
                        onChanged: (value) {
                          setState(() {
                            caption = value;
                            isPressed = true;
                          });
                        },
                      ),
                    )
                  : SizedBox(),
              isPressed
                  ? ElevatedButton(
                      onPressed: () async {
                        Database _db = Database();
                        await _db.uploadPost(_image!, caption);
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Text("Post"))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
