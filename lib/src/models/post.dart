import 'user.dart';
import 'comment.dart';

class Post {
  User poster;
  int noOfLikes = 0;
  List<User> likedBy = [];
  List<Comment> comments = [];

  Post(this.poster);
}
