import 'package:dash_chat/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/src/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<dynamic> fetchUserFromDB(String uid) async {
    print("Inside fn" + uid);
    try {
      // Reference to the Firestore collection 'users'
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query to retrieve data where 'uid' field matches the provided UID
      QuerySnapshot querySnapshot =
          await usersCollection.where('uid', isEqualTo: uid).get();

      // Process the querySnapshot to get documents and data
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          // Use the data as needed
          return data;
        }
      } else {
        print('No matching documents');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<dynamic> fetchUserFromDBUsername(String username) async {
    try {
      // Reference to the Firestore collection 'users'
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query to retrieve data where 'uid' field matches the provided UID
      QuerySnapshot querySnapshot =
          await usersCollection.where('username', isEqualTo: username).get();

      // Process the querySnapshot to get documents and data
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;
          // Use the data as needed
          return data;
        }
      } else {
        print('No matching documents');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<dynamic> getAllUsers() async {
    List<dynamic> usersList = [];
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    await usersCollection.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        usersList.add(result.data());
      }
    });

    return usersList;
  }

  Future deleteUser(String uid) async {
    await FirebaseAuth.instance.currentUser?.delete();

    FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                doc.reference.delete().then(
                      (value) => {print("Success")},
                    );
              })
            });

    print(FirebaseAuth.instance.currentUser);
  }

  Future updateUser(String uid, var data) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    usersCollection.where("uid", isEqualTo: uid).get().then((querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update(data).then(
                  (value) => {print("Success")},
                );
          })
        });
  }
}
