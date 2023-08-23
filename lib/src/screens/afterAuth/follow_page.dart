// ignore_for_file: avoid_function_literals_in_foreach_calls
import 'package:dash_chat/src/screens/afterAuth/others_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/database.dart';
import 'loading_screen.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  List<dynamic> allUsers = [];
  List<dynamic> searchterms = [];
  String query = '';
  List<String> matchedQueries = [];
  void getAllUsers() {
    Database db = Database();
    String currentUID = FirebaseAuth.instance.currentUser!.uid;
    db.getAllUsers().then((value) {
      if (value != null) {
        setState(() {
          allUsers = value;
          allUsers.forEach((element) {
            if (element["username"] != null && element["uid"] != currentUID) {
              searchterms.add(element["username"]);
            }
          });
        });
      } else {
        return const loadingScreen();
      }
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (allUsers.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              // Add padding around the search bar
              padding: const EdgeInsets.all(6),
              // Use a Material design search bar
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                  showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(searchterms));
                  // for (var item in searchterms) {
                  //   if ((item as String)
                  //       .toLowerCase()
                  //       .contains(query.toLowerCase())) {
                  //     matchedQueries.add(item);
                  //   }
                  // }
                },
                decoration: InputDecoration(
                  hintText: 'Search...',

                  hintStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color.fromRGBO(57, 53, 53, 2),
                  // Add a clear button to the search bar
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                  // Add a search icon or button to the search bar
                  prefixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Perform the search here
                      // showSearch(context: context, delegate: CustomSearchDelegate());
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            // ListView.builder(
            //   itemCount: matchedQueries.length,
            //   itemBuilder: (context, index) {
            //     var result = matchedQueries[index];
            //     return ListTile(
            //       title: Text(result),
            //     );
            //   },
            // )
          ],
        ),
      );
    } else {
      return const loadingScreen();
    }
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<dynamic> searchTerms = [];
  CustomSearchDelegate(this.searchTerms);

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase()) &&
          query.length > 1) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OthersProfile(username: result),
              ),
            );
          },
        );
      },
    );
  }
}
