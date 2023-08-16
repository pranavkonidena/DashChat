import 'user.dart';

class Comment {
  User commenter;
  String commentVal;
  int noOfLikes = 0;
  List<User> likedBy = [];

  Comment(this.commenter, this.commentVal);
}
