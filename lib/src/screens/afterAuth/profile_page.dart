import 'dart:io';

import 'package:dash_chat/src/screens/afterAuth/image_returner.dart';
import 'package:dash_chat/src/screens/afterAuth/loading_screen.dart';
import 'package:dash_chat/src/screens/beforeAuth/login.dart';
import 'package:dash_chat/src/screens/beforeAuth/register.dart';
import 'package:dash_chat/src/services/auth.dart';
import 'package:dash_chat/src/services/database.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  dynamic userData = {};
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamWidget(),
    );
  }
}

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _isLoading2 = true;
  dynamic _currentUser = null;
  dynamic _userData;
  List<String> postsUrl = [];
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(_onAuthStateChanged);
    fetchPostUrls();
  }

  void _onAuthStateChanged(User? user) async {
    if (user != null) {
      String uid = user.uid;
      print(uid);
      Database _db = Database();
      dynamic data;
      data = _db.fetchUserFromDB(uid).then((value) => setState(() {
            if (value != null) {
              _userData = value;
              _currentUser = MyUser(uid);
              _isLoading = false;
            } else {
              _isLoading = true;
            }
          }));
    } else {
      setState(() {
        _currentUser = null;
        _isLoading = true;
        _userData = null;
      });
    }
  }

  void fetchPostUrls() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Database _db = Database();
    dynamic data;
    data = _db.fetchUserFromDB(uid).then((value) => setState(() {
          if (value != null) {
            postsUrl =
                (value['posts'] as List).map((item) => item as String).toList();
            _isLoading2 = false;
          } else {
            _isLoading2 = true;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && !_isLoading2) {
      if (_currentUser != null) {
        return Scaffold(
           backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left : 28.0),
                child: Text(
                  _userData["username"],
                  style: const TextStyle(
                      fontFamily: "Pragati",
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top : 20.0 , left: 28),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(38.0),
                      child: Image.network(_userData["imageUrl"],
                          height: 80,
                          width: 80,
                          fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 38.0),
                    child: Container(
                      width: 220,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Column(children: [
                          Text(_userData["posts"].length.toString() , style: TextStyle(
                            color: Colors.white,
                          ),),
                          Text("Posts" , style: TextStyle(
                            color: Colors.white,
                          ),),
                        ],),
                        Column(children: [
                          Text(_userData["followers"].length.toString() , style: TextStyle(
                            color: Colors.white,
                          ),),
                          Text(" Followers" , style: TextStyle(
                            color: Colors.white,
                          ),),
                        ],),
                         Column(children: [
                          Text(_userData["following"].length.toString() , style: TextStyle(
                            color: Colors.white,
                          ),),
                          Text("Following" , style: TextStyle(
                            color: Colors.white,
                          ),),
                        ],)
                      ]),
                    ),
                  )
                
              ]),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top : 38.0 , left : 28),

                      child: Text(_userData["bio"] , style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Pragati",
                        fontSize: 20,
                      ),),
                    ),
                  ]),
              Padding(
                padding: const EdgeInsets.only(top: 20 , bottom: 20),
                child: Row(
                  
                  children: [
                    for (var item in postsUrl)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Image.network(item, width: 80, height: 80,
                              frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
                            return child;
                          }, loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          }
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left : 28.0 , top: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color.fromRGBO(57, 53, 53, 2),
                  ),
                    onPressed: () async {
                      Database _db = Database();
                      await _db.deleteUser(_userData["uid"]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text("Delete account" , style: TextStyle(color: Colors.red),)),
              )
            ],
          ),
        );
      } else {
        return loadingScreen();
      }
    } else {
      return loadingScreen();
    }
  }
}
