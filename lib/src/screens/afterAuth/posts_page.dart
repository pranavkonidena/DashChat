import 'dart:io';

import 'package:dash_chat/src/screens/afterAuth/loading_screen.dart';
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
  bool isPosted = false;
  bool _isPressed = false;

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
    if (_isPressed == false) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: Text(
                  "New Post",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: "ShadowsIntoLight"),
                ),
              ),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.file(
                        _image!,
                        width: 250,
                        height: 250,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(57, 53, 53, 2),
                      ),
                      onPressed: () {
                        getImage();
                      },
                      child: const Text(" Pick from Gallery ")),
              _image != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          labelText: "Caption",
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Color.fromRGBO(57, 53, 53, 2),
                        ),
                        onChanged: (value) {
                          setState(() {
                            caption = value;
                            if (value.isNotEmpty) {
                              isPressed = true;
                            } else {
                              isPressed = false;
                            }
                          });
                        },
                      ),
                    )
                  : const SizedBox(),
              isPressed
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(57, 53, 53, 2),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isPressed = true;
                        });

                        Database db = Database();
                        await db.uploadPost(_image!, caption);
                        setState(() {
                          _image = null;
                          isPosted = true;
                          _isPressed = false;
                          isPressed = false;
                        });
                      },
                      child: const Text("Post"))
                  : const SizedBox()
            ],
          ),
        ),
      );
    } else {
      return const loadingScreen();
    }
  }
}
