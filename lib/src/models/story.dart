import 'user.dart';

class Story {
  User storyPoster;
  List<User> viewedBy = [];
  int noOfViews = 0;
  List<User> likedBy = [];
  int noOfLikes = 0;

  Story(this.storyPoster);
}
