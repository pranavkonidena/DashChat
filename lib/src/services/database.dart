import 'package:dash_chat/src/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _reference = FirebaseFirestore.instance;

class Database {
  Future registerToDB(MyUser user) async {
    await _reference.collection("users").add({
      "email": user.email,
      "password": user.password,
      "username": user.username,
      "uid": user.uid,
      "bio": user.bio,
      "postNums": 0,
      "followers": [],
      "following": [],
      "posts": [],
    });
  }

  Future<MyUser> fetchUserFromDB(String uid) async {
    QuerySnapshot querySnapshot =
        await _reference.collection("users").where('uid', isEqualTo: uid).get();
    QueryDocumentSnapshot userDocument = querySnapshot.docs.first;
    String username = userDocument['username'];
    String email = userDocument['email'];
    String bio = userDocument['bio'];
    dynamic data = {username, email, bio};
    return data;
  }
}
