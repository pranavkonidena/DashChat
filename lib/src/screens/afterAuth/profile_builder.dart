import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/models/user.dart';
import 'package:dash_chat/src/screens/afterAuth/home.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileBuilder extends StatefulWidget {
  const ProfileBuilder({super.key});

  @override
  State<ProfileBuilder> createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  String bio = "";
  String username = "";
  File? _image;
  final _formKey = GlobalKey<FormState>();

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
    final user = ModalRoute.of(context)?.settings.arguments as MyUser;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: Scaffold(
            backgroundColor: Colors.black,
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 130.0),
                child: Text(
                  "Tell us more about yourself",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: "ShadowsIntoLight",
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  getImage();
                                },
                                child: Text("Set Profile Pic"),
                              ),
                            ),
                            _image == null ? SizedBox() : Container(
                              child: Image.file(_image!),
                              width: 100,
                              height: 100,
                            )
                          ],
                          
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              labelText: "What would you like to be called?",
                              filled: true,
                              fillColor: Color.fromRGBO(57, 53, 53, 2),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            onChanged: (value) {
                              setState(() {
                                username = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a username";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              labelText: "Tell us about yourself",
                              filled: true,
                              fillColor: Color.fromRGBO(57, 53, 53, 2),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            onChanged: (value) {
                              setState(() {
                                bio = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a bio";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    user.username = username;
                                    user.bio = bio;
                                  });
                                  Database _db = Database();
                                  await _db.registerToDB(user, _image!);
                                  setState(() {
                                    _image = null;
                                  });
                                  Navigator.pushNamed(context, "/home",
                                      arguments: user.uid);
                                }
                              },
                              child: Text("Get Set Dash")),
                        ),
                      ]))
            ])));
  }
}
