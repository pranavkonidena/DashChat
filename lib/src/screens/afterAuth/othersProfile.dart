import 'package:dash_chat/src/screens/afterAuth/loadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';

class OthersProfile extends StatefulWidget {
  String username = "";
  OthersProfile({super.key, required this.username});
  @override
  State<OthersProfile> createState() => _OthersProfileState();
}

class _OthersProfileState extends State<OthersProfile> {
  bool timePass = true;
  bool _isLoading = true;
  bool _isLoading2 = true;
  dynamic _userData;
  String currentUid = "";
  dynamic _currentUserData;
  @override
  void initState() {
    // TODO: implement initState
    fetchUserData(widget.username);
    currentUid = FirebaseAuth.instance.currentUser!.uid;
    fetchCurrentUserData();

    super.initState();
  }

  void fetchUserData(String username) {
    Database _db = Database();
    dynamic data;

    data = _db.fetchUserFromDBUsername(username).then((value) => setState(() {
          if (value != null) {
            _userData = value;
            _isLoading = false;
          } else {
            _isLoading = true;
          }
        }));
  }

  void fetchCurrentUserData() {
    Database _db = Database();
    dynamic data;
    data = _db.fetchUserFromDB(currentUid).then((value) => setState(() {
          if (value != null) {
            _currentUserData = value;
            _isLoading2 = false;
          } else {
            _isLoading2 = true;
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && !_isLoading2) {
      return MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(_userData["username"]),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(_userData["posts"].length.toString()),
                      Text("Posts"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(_userData["following"].length.toString()),
                      Text("Following"),
                    ],
                  ),
                  Column(
                    children: [
                      Text(_userData["followers"].length.toString()),
                      Text("Followers"),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "Bio",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _userData["bio"],
                style: TextStyle(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if(timePass){
                          List followers = _userData["followers"];
                        followers.add(currentUid);
                        List following = _currentUserData["following"];
                        following.add(_userData["uid"]);
                        dynamic update_followers = {
                          "followers": followers,
                        };
                        dynamic update_following = {
                          "following": following,
                        };
                        Database _db = Database();
                        await _db.updateUser(currentUid, update_following);
                        await _db.updateUser(
                            _userData["uid"], update_followers);
                        }
                        else{
                          List followers = _userData["followers"];
                        followers.remove(currentUid);
                        List following = _currentUserData["following"];
                        following.remove(_userData["uid"]);
                        dynamic update_followers = {
                          "followers": followers,
                        };
                        dynamic update_following = {
                          "following": following,
                        };
                        Database _db = Database();
                        await _db.updateUser(currentUid, update_following);
                        await _db.updateUser(
                            _userData["uid"], update_followers);
                        }
                        
                        setState(() {
                          timePass = !timePass;
                        });
                      },
                      child: timePass ? Text("Follow" , style: TextStyle(
                        
                      ),) : Text("Following"),
                      style: timePass ? ElevatedButton.styleFrom(backgroundColor: Colors.blue) : ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      ),
                  ElevatedButton(onPressed: () {}, child: Text("Message"))
                ],
              ),
            )
          ],
        ),
      ));
    } else {
      return loadingScreen();
    }
  }
}
