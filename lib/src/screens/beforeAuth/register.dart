import 'package:dash_chat/src/constants/routes.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import 'login.dart';

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
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(46.0),
                  child: Center(
                      child: Column(
                    children: [
                      Text("DashChat",
                          style: TextStyle(
                              fontSize: 50,
                              fontFamily: "DancingScript",
                              color: Colors.white)),
                      Text(
                        "Sign Up today to see what your friends are upto",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  )),
                ),
                const LoginForm(),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(top: 80.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          Text(
                            "Log In",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ))
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
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color.fromRGBO(57, 53, 53, 2),
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
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
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
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 1000,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      AuthService auth = AuthService();

                      try {
                        dynamic user =
                            await auth.registerWithEmail(email, password);
                        setState(() {
                          user.password = password;
                          user.email = email;
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, "/profileBuilder",
                            arguments: user);
                      } catch (e) {
                        dynamic emailUsed = SnackBar(
                          content: Text(e.toString()),
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(emailUsed);
                      }
                    }
                  },
                  child: const Text("Sign Up")),
            ),
          )
        ],
      ),
    );
  }
}
