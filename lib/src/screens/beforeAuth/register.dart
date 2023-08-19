import 'package:dash_chat/src/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../services/auth.dart';
import '../../models/user.dart';
import '../../services/database.dart';
import '../../constants/errorSnackBar.dart';
import '../afterAuth/profileBuilder.dart';
import 'login.dart';
import '../afterAuth/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
  void loginCheck() {}
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: routes,
        home: Scaffold(
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text("DashChat",
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.w600))),
            const LoginForm(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                },
                child: const Text("LogIn"))
          ],
        )));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "";
  String password = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as dynamic;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Email",
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a valid email";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: "Password",
              ),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty || value.length <= 5) {
                  return "Password should contain atleast 6 chars";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    AuthService _auth = AuthService();

                    try {
                      dynamic user =
                          await _auth.registerWithEmail(email, password);
                      Database _db = Database();
                      setState(() {
                        user.password = password;
                        user.email = email;
                      });
                      Navigator.pushNamed(context, "/profileBuilder",
                          arguments: user);
                    } catch (e) {
                      dynamic emailUsed = SnackBar(
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(emailUsed);
                    }
                  }
                },
                child: const Text("SignUp")),
          )
        ],
      ),
    );
  }
}
