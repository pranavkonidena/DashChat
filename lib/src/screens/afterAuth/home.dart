import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/afterAuth/loadingScreen.dart';
import 'package:dash_chat/src/screens/beforeAuth/login.dart';
import 'package:dash_chat/src/services/database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  dynamic userData = {};
  bool is_loading = true;

  Database _db = Database();

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        uid = user.uid;
        MyUser current_user = MyUser(uid);
        dynamic data = _db.fetchUserFromDB(uid).then((value) => setState(() {
              if (value != null) {
                userData = value;
                setState(() {
                  is_loading = false;
                });
              } else {}
            }));
      }
    });

    ;
    super.initState();
  }

  Widget build(BuildContext context) {
    @override
    AuthService _auth = AuthService();
   
   
    if (!is_loading) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text("SignOut"))),
              ),
              Text(userData["bio"]),
            ],
          )));
    } else {
      return loadingScreen();
    }
  }
}
