import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/afterAuth/home.dart';
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
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/login.png')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 66.0),
                  child: Text("DashChat",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'DancingScript',
                          color: Colors.white)),
                ),
                const LoginForm(),
                Padding(
                  padding: const EdgeInsets.only(top : 80.0),
                  child: SizedBox(
                    width: 1000,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black
                      ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text("Don't have an account? "),
                          Text("Sign Up" , style: TextStyle(color: Colors.blue),),
                        ]),
                     ) ),
                )
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
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Color.fromRGBO(57, 53, 53, 2),
                labelStyle: TextStyle(color: Colors.white),
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
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color.fromRGBO(57, 53, 53, 2),
              ),
              obscureText: true,
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
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: 1000,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      AuthService _auth = AuthService();
                      try {
                        dynamic user =
                            await _auth.loginWithEmail(email, password);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      } catch (e) {
                        dynamic error = SnackBar(
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(error);
                      }
                    }
                  },
                  child: const Text("Log in")),
            ),
          )
        ],
      ),
    );
  }
}
