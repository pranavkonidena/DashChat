import 'dart:io';

import 'package:dash_chat/src/screens/afterAuth/loadingScreen.dart';
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
    return MaterialApp(
      home: Scaffold(
        body: StreamWidget(),
      ),
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
  dynamic _currentUser = null;
  dynamic _userData;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(_onAuthStateChanged);
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

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      if (_currentUser != null) {
        return Scaffold(
          body: Column(
            children: [
              Text(
                _userData["username"],
                style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 30,
                    color: Colors.black87),
              ),
              Text(_userData["bio"]),
              Text(_userData["email"]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Following "),
                Text(_userData["following"].length.toString()),
              ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Followers "),
                    Text(_userData["followers"].length.toString()),
                  ]),
              ElevatedButton(
                  onPressed: () async {
                    Database _db = Database();
                    await _db.deleteUser(_userData["uid"]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text("Delete account"))
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
