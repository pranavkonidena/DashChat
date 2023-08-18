import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/beforeAuth/login.dart';
import 'package:dash_chat/src/services/database.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = "";
  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        uid = user.uid;
      }
      return null;
    });
    print(uid);
    

    AuthService _auth = AuthService();
    return MaterialApp(
        routes: routes,
        home: Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: (ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.pushNamed(context, "/login");
                  },
                  child: Text("SignOut"))),
            ),

            Text("Hi"),

            // Text(uid),
          ],
        )));
  }
}
