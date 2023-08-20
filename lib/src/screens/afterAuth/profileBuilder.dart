import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/models/user.dart';
import 'package:dash_chat/src/screens/afterAuth/home.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';

class ProfileBuilder extends StatefulWidget {
  const ProfileBuilder({super.key});

  @override
  State<ProfileBuilder> createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  String bio = "";
  String username = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as MyUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        routes: routes,
        home: Scaffold(
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Tell us more about yourself"),
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Username",
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a username";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Tell us about yourself",
                        ),
                        onChanged: (value) {
                          setState(() {
                            bio = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a bio";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                             
                              setState(() {
                                user.username = username;
                                user.bio = bio;
                              });
                              Database _db = Database();
                              await _db.registerToDB(user);
                              Navigator.pushNamed(context, "/home",
                                  arguments: user.uid);
                            }
                          },
                          child: Text("Go to home")),
                    ),
                  ]))
        ])));
  }
}
