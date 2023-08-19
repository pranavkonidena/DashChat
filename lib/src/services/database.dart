import 'package:dash_chat/src/models/user.dart';
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

  // Future<dynamic> fetchUserFromDB(String uid) async {
  //   print(uid);
  //   final DocumentReference document = _reference.collection("users").doc(uid);

  //   await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
  //     print(snapshot.data);
  //   });
  // }
  Future<dynamic> fetchUserFromDB(String uid) async {
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
}
