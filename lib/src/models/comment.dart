import 'user.dart';

class Comment {
  MyUser commenter;
  String commentVal;
  int noOfLikes = 0;
  List<MyUser> likedBy = [];

  Comment(this.commenter, this.commentVal);
}
