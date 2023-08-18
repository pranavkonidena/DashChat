import 'user.dart';

class Story {
  MyUser storyPoster;
  List<MyUser> viewedBy = [];
  int noOfViews = 0;
  List<MyUser> likedBy = [];
  int noOfLikes = 0;

  Story(this.storyPoster);
}
