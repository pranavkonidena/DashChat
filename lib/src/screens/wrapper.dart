import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/afterAuth/home.dart';
import 'package:dash_chat/src/screens/beforeAuth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'beforeAuth/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              print(user);
              return HomePage();
            } else {
              return LoginScreen();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}
