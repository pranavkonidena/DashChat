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
