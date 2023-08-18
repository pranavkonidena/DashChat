import 'package:dash_chat/src/screens/afterAuth/home.dart';
import 'package:dash_chat/src/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/beforeAuth/register.dart';
import './screens/wrapper.dart';
import './models/user.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      initialData: MyUser("test"),
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
