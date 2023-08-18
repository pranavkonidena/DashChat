import 'user.dart';
import 'comment.dart';

class Post {
  MyUser poster;
  int noOfLikes = 0;
  List<MyUser> likedBy = [];
  List<Comment> comments = [];

  Post(this.poster);
}
