import 'package:dash_chat/src/screens/afterAuth/loading_screen.dart';
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
  bool timePass = false;
  bool _isLoading = true;
  bool _isLoading2 = true;
  bool _isLoading3 = true;
  List<String> postsUrl = [];
  dynamic _userData;
  String currentUid = "";
  dynamic _currentUserData;
  bool _isFollowing = false;
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
            if (_userData["followers"]
                .contains(FirebaseAuth.instance.currentUser!.uid)) {
              setState(() {
                _isFollowing = true;
              });
            } else {
              setState(() {
                _isFollowing = false;
              });
            }
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
            backgroundColor: Colors.black,
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
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(38.0),
                      child: Image.network(_userData["imageUrl"],
                          height: 80,
                          width: 80,
                          fit: BoxFit.fill,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(right: 48.0),
                    child: Container(
                      width: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Column(
                      children: [
                        Text(_userData["posts"].length.toString() , style: TextStyle(color: Colors.white),),
                        Text("Posts" , style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    Column(
                      children: [
                        Text(_userData["following"].length.toString() ,style: TextStyle(color: Colors.white),),
                        Text("Following" , style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    Column(
                      children: [
                        Text(_userData["followers"].length.toString() , style: TextStyle(color: Colors.white)),
                        Text("Followers" ,style: TextStyle(color: Colors.white)),
                      ],
                    ),
                      ]),
                    ),
                  )
                 
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 38.0 , bottom: 30),
              child: Text(
                _userData["bio"],
                style: TextStyle(
                  color: Colors.white,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      List followers = _userData["followers"];
                      List following = _currentUserData["following"];
                      if (!_isFollowing) {
                        followers.add(currentUid);
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
                        setState(() {
                          _isFollowing = true;
                        });
                      } else {
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
                        setState(() {
                          _isFollowing = false;
                        });
                      }
                    },
                    child: !_isFollowing
                        ? Text(
                            "Follow",
                            style: TextStyle(),
                          )
                        : Text("  Following  "),
                    style: !_isFollowing
                        ? ElevatedButton.styleFrom(backgroundColor: Colors.blue)
                        : ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(57, 53, 53, 2)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(57, 53, 53, 2),
                    ),
                    onPressed: () {}, child: Text("Message"))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "Posts",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  for (var item in _userData["posts"])
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Image.network(item, frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return child;
                        }, loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                        height: 80,
                        width: 80,
                      ),
                    )
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
