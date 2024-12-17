class User {
  final String name;
  final String profile; // URL or path to the profile image
  final List<Post> posts; // List of posts by the user
  final List<Story> stories;

  User({
    required this.name,
    required this.profile,
    required this.posts,
    required this.stories,
  });
}

class Post {
  final String timePosted; // Time the post was made (can be "x hours ago")
  final String caption; // The caption or text content of the post
  final List<String> images; // List of image URLs or asset paths
  final int reactions; // Number of reactions
  final int comments;
  final int shares;
  final String reactLogo;

  Post({
    required this.timePosted,
    required this.caption,
    required this.images,
    required this.reactions,
    required this.comments,
    required this.shares,
    required this.reactLogo,
  });
}

class Story {
  final String timePosted;
  final String image;
  Story({
    required this.timePosted,
    required this.image,
  });
}
