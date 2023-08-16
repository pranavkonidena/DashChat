import 'post.dart';

class User {
  String uid;
  String username;
  String bio;
  int postNums = 0;
  List<User> followers = [];
  List<User> following = [];
  List<Post> posts = [];

  User(this.uid, this.username, this.bio );
}
