import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthService {
  
  // Stream<User>? get user {
  //   _auth.authStateChanges().listen((
  //     User? user,
  //   ) {
  //     if (user == null) {
  //       print("User signed out!");
  //     } else {
  //       print("User with ${user.uid} signed in!");
  //     }
  //   });
  // }

  MyUser convertToUser(dynamic result) {
    return MyUser(result.user.uid);
  }

  Future registerWithEmail(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return convertToUser(result);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future loginWithEmail(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return convertToUser(result);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    try {
      
    } catch (e) {
      print("Error");
      print(e);
    }
  }
}
