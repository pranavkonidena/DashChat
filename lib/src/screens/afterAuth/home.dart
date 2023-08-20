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
  AuthService _auth = AuthService();
  Widget build(BuildContext context) {
    if (_selectedIndex == 3) {
      return MaterialApp(
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
                  style:
                      TextStyle(fontSize: 40, fontFamily: "ShadowsIntoLight"),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  // child: Text("SignOut" , style: TextStyle(
                  //   fontSize: 15,
                  //   color: Colors.white,
                  //   fontFamily: "Montserrat"
                  // ),)
                  icon: Icon(
                    Icons.logout,
                    size: 30,
                  ),
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
    } else {
      return MaterialApp(
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
                  style:
                      TextStyle(fontSize: 40, fontFamily: "ShadowsIntoLight"),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    // await _auth.signOut();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const LoginScreen()),
                    // );
                  },
                  // child: Text("SignOut" , style: TextStyle(
                  //   fontSize: 15,
                  //   color: Colors.white,
                  //   fontFamily: "Montserrat"
                  // ),)
                  icon: Icon(
                    Icons.message_rounded,
                    size: 30,
                  ),
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
}

class StreamWidget extends StatefulWidget {
  const StreamWidget({super.key});

  @override
  State<StreamWidget> createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  MyUser? _currentUser;
  dynamic _userData;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) async {
    if (user != null) {
      String uid = user.uid;
      print(uid);
      Database _db = Database();
      _userData = _db.fetchUserFromDB(uid).then((value) => setState(() {
            if (value != null) {
              _userData = value;
            } else {}
          }));
      setState(() {
        _currentUser = MyUser(uid);
        _isLoading = false;
      });
    } else {
      setState(() {
        _currentUser = null;
        _isLoading = true;
        _userData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser != null) {
      return Scaffold(
          body: Column(
        children: [],
      ));
    } else {
      return loadingScreen();
    }
  }
}
