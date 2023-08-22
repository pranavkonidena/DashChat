import 'package:dash_chat/src/constants/routes.dart';
import 'package:dash_chat/src/screens/afterAuth/followPage.dart';
import 'package:dash_chat/src/screens/afterAuth/loadingScreen.dart';
import 'package:dash_chat/src/screens/afterAuth/profilePage.dart';
import 'package:dash_chat/src/screens/beforeAuth/login.dart';
import 'package:dash_chat/src/services/database.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './postsPage.dart';

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

  List<Widget> _pages = [
    StreamWidget(),
    FollowPage(),
    PostsPage(),
    ProfilePage()
  ];
  List<Icon> _icons = [
    Icon(
      Icons.message,
      size: 30,
    ),
    Icon(
      Icons.message,
      size: 30,
    ),
    Icon(
      Icons.send,
      size: 30,
    ),
    Icon(Icons.exit_to_app_rounded, size: 30)
  ];
  final AuthService _auth = AuthService();
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        home: Scaffold(
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
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
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
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  bool _noPosts = false;
  MyUser? _currentUser;
  dynamic _userData;
  List postUrls = [];
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
            tempList.insert(0, i);
            print(tempList);
            setState(() {
              postUrls = tempList;
              print(postUrls.length);
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
    if (_currentUser != null && !_isLoading ||  !_noPosts) {
      return Scaffold(
          body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: postUrls.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(5),
              child: Image.network(postUrls[index], scale: 1, frameBuilder:
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
            );
          },
        ),
      ));
    } else {
      return Scaffold(
        body: Text(
            "No posts to display , please follow someone before seeing posts here"),
      );
    }
  }
}
