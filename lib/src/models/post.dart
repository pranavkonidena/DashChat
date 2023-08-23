// ignore_for_file: non_constant_identifier_names

import 'user.dart';
import 'comment.dart';

class Post {
  String poster_uid = "";
  String caption = "";
  int noOfLikes = 0;
  List<MyUser> likedBy = [];
  List<Comment> comments = [];
  Post(poster_uid);
}
