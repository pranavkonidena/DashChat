// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/afterAuth/follow_page.dart';
import 'package:dash_chat/src/screens/afterAuth/profile_page.dart';
import 'package:dash_chat/src/screens/beforeAuth/login.dart';
import 'package:dash_chat/src/services/database.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'posts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const StreamWidget(),
    const FollowPage(),
    const PostsPage(),
    ProfilePage()
  ];
  final List<Icon> _icons = [
    const Icon(
      Icons.message,
      size: 30,
    ),
    const Icon(
      Icons.message,
      size: 30,
    ),
    const Icon(
      Icons.send,
      size: 30,
    ),
    const Icon(Icons.exit_to_app_rounded, size: 30)
  ];
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black87,
            centerTitle: false,
            title: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                "DashChat",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 40, fontFamily: "ShadowsIntoLight"),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  if (_selectedIndex == 3) {
                    await _auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  } else if (_selectedIndex == 2) {
                    //Post icon
                  } else {
                    //Message icon
                  }
                },
                icon: _icons.elementAt(_selectedIndex),
              )
            ],
          ),
          body: _pages.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.amberAccent,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: 'Posts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_box_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ));
  }
}

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _noPosts = false;
  MyUser? _currentUser;
  dynamic _userData;
  List postUrls = [];
  dynamic postData;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user != null) {
      String uid = user.uid;

      Database _db = Database();
      _userData = _db.fetchUserFromDB(uid).then((value) => setState(() {
            if (value != null) {
              _userData = value;
              fetchPostsOfFollowing(_userData).then(
                (value) {},
              );
            } else {}
          }));
      setState(() {
        _currentUser = MyUser(uid);
      });
    } else {
      setState(() {
        _currentUser = null;
        _isLoading = true;
        _userData = null;
      });
    }
  }

  Future fetchPostsOfFollowing(dynamic userData) async {
    List following = userData["following"];
    dynamic temp;
    dynamic data;
    List tempList = [];
    List tempList2 = [];
    int count = 0;

    for (var item in following) {
      temp = Database().fetchUserFromDB(item).then((value) {
        if (value != null) {
          // setState(() {
          //   data = value;
          //   print(data["posts"]);
          // });
          data = value;
          for (var i in data["posts"]) {
            fetchPostData(i).then((value2) {
              tempList2.insert(0, value2.elementAt(0).elementAt(0));
              tempList.insert(0, i);
              setState(() {
                postUrls = tempList;
                postData = tempList2;
              });
            });
          }
        } else {
          setState(() {
            _noPosts = true;
          });
        }
      });
    }

    // setState(() {
    //   _isLoading = false;
    // });

    return postUrls;
  }

  Future fetchPostData(String postUrl) async {
    dynamic temp;
    Database _db = Database();
    temp = _db.fetchPostsFromDB(postUrl).then((value) => {
          if (value != null)
            {
              temp = value,
            }
        });
    return temp;
  }

  String extractValue(String input) {
    int startIndex = input.indexOf("(") + 1;
    int endIndex = input.lastIndexOf(")");

    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return input.substring(startIndex, endIndex);
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null && !_isLoading || !_noPosts) {
      // print((postData[0]));
      return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: postUrls.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  color: const Color.fromARGB(252, 23, 23, 23),
                  child: Column(
                    children: [
                      PostTop(postData: postData[index]),
                      Image.network(postUrls[index], scale: 1, height: 400,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      }, loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                      PostsBottom(postData: postData[index]),
                    ],
                  ),
                );
              },
            ),
          ));
    } else {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Text(
          "No posts to display , please follow someone before seeing posts here",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }
}

Future fetchUsernameFromUid(String uid) async {
  Database _db = Database();
  dynamic data;
  data = _db.fetchUserFromDB(uid).then((value) {
    data = value["username"];
  });
  return data;
}

class PostTop extends StatelessWidget {
  dynamic postData;

  PostTop({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            postData["username"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: "ShadowsIntoLight",
            ),
          )
        ],
      ),
    );
  }
}

class PostsBottom extends StatelessWidget {
  dynamic postData;
  PostsBottom({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            postData["caption"],
            style: const TextStyle(
                fontFamily: "Pragati", fontSize: 25, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
