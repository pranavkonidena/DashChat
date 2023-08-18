import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/beforeAuth/register.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  void loginCheck() {}
}

class _LoginScreenState extends State<LoginScreen> {
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
                child: Text("Welcome Back",
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.w600))),
            const LoginForm(),
            ElevatedButton(
                onPressed: () {
               

                  Navigator.pushNamed(
                    context,
                    "/register",
                    arguments: {
                      "username": "Hello",
                    },
                  );
                },
                child: const Text("SignUp"))
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
                          await _auth.loginWithEmail(email, password);
                    } catch (e) {
                      dynamic error = SnackBar(
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(error);
                    }
                  }
                },
                child: const Text("Login")),
          )
        ],
      ),
    );
  }
}
