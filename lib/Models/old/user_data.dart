// lib/models/user_data.dart

import 'users.dart'; // Import the User and Post classes from user.dart

List<User> users = [
  User(
    name: 'Erronn John Madelo',
    profile: 'assets/images/0.jpg',
    posts: [
      Post(
          timePosted: '2 hours ago',
          caption: 'It is edging time🥰',
          images: ['assets/images/post1.png', 'assets/images/post2.jpg'],
          reactions: 120,
          comments: 35,
          shares: 3,
          reactLogo: 'assets/icons/love.png'),
      Post(
          timePosted: '1 day ago',
          caption: 'My new favorite coffee spot!',
          images: ['assets/images/post1.png'],
          reactions: 200,
          comments: 50,
          shares: 33,
          reactLogo: 'assets/icons/angry.png'),
    ],
    stories: [
      Story(timePosted: 'timePosted', image: 'assets/images/story0.jpg')
    ],
  ),
  User(
    name: 'Batman',
    profile: 'assets/images/1.png',
    posts: [
      Post(
        timePosted: '21 hours ago',
        caption: 'For Gotham!!!',
        images: ['assets/images/11.jpg', 'assets/images/11.jpg'],
        reactions: 14,
        comments: 28,
        shares: 37,
        reactLogo: 'assets/icons/love.png',
      ),
    ],
    stories: [
      Story(timePosted: 'timePosted', image: 'assets/images/story1.webp')
    ],
  ),
  User(
    name: 'Hannibal Lecter',
    profile: 'assets/images/3.jpg',
    posts: [
      Post(
        timePosted: '6 hours ago',
        caption: 'Exquisite dinner!',
        images: ['assets/images/33.png', 'assets/images/33.png'],
        reactions: 369,
        comments: 7,
        shares: 3,
        reactLogo: 'assets/icons/love.png',
      ),
    ],
    stories: [
      Story(timePosted: 'timePosted', image: 'assets/images/story3.jpg')
    ],
  ),
  User(
    name: 'Chrollo',
    profile: 'assets/images/2.jpg',
    posts: [
      Post(
        timePosted: '1 minute ago',
        caption: 'Can you hear me, Uvo?',
        images: ['assets/images/22.jpg', 'assets/images/22.jpg'],
        reactions: 11,
        comments: 11,
        shares: 11,
        reactLogo: 'assets/icons/love.png',
      ),
    ],
    stories: [
      Story(timePosted: 'timePosted', image: 'assets/images/story2.jpg')
    ],
  ),
  User(
    name: 'Lord Bayron',
    profile: 'assets/images/4.jpg',
    posts: [
      Post(
        timePosted: '1 minute ago',
        caption: 'I badly need sleep🫥',
        images: ['assets/images/44.jpeg', 'assets/images/44.jpeg'],
        reactions: 6,
        comments: 3,
        shares: 17,
        reactLogo: 'assets/icons/haha.png',
      ),
    ],
    stories: [
      Story(timePosted: 'timePosted', image: 'assets/images/story4.jpg')
    ],
  ),
  User(
    name: 'Kurapika',
    profile: 'assets/images/5.jpg',
    posts: [
      Post(
        timePosted: '1 minute ago',
        caption: 'Is this the wrong one?',
        images: ['assets/images/55.jpg', 'assets/images/55.jpg'],
        reactions: 32,
        comments: 16,
        shares: 66,
        reactLogo: 'assets/icons/haha.png',
      ),
    ],
    stories: [
      Story(timePosted: 'timePosted', image: 'assets/images/story5.jpg')
    ],
  ),
];
