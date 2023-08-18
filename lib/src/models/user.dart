import 'post.dart';

class MyUser {
  String? email;
  String? password;
  String? uid;
  String? username;
  String bio = "";
  int postNums = 0;
  List<MyUser> followers = [];
  List<MyUser> following = [];
  List<Post> posts = [];

  MyUser(this.uid);
}
