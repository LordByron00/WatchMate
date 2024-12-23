import 'package:WatchMate/screens/Chat.dart';
import 'package:WatchMate/screens/MedeiaDetail.dart';
import 'package:WatchMate/services/getAuthUID.dart';
import 'package:WatchMate/services/userPreference.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchMate extends StatefulWidget {
  const MatchMate({super.key});

  @override
  State<MatchMate> createState() => _MatchMateState();
}

class _MatchMateState extends State<MatchMate> {
  List<Map<String, dynamic>> users = [];
  // String? _matchImageUrl =
  //     'https://instagram.fdvo4-1.fna.fbcdn.net/v/t51.29350-15/422523898_404992448634193_6480536581568353188_n.jpg?stp=dst-jpg_e35_p640x640_sh0.08_tt7&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDE4MDAuc2RyLmYyOTM1MC5kZWZhdWx0X2ltYWdlIn0&_nc_ht=instagram.fdvo4-1.fna.fbcdn.net&_nc_cat=101&_nc_ohc=J7PN8WzHPhUQ7kNvgGMF9Ow&_nc_gid=3f37423160e447d48923b932afc803a7&edm=ALQROFkBAAAA&ccb=7-5&ig_cache_key=MzI4Nzk3ODcxODc0MzI4MjM3NA%3D%3D.3-ccb7-5&oh=00_AYDM7tL19p3yA2a8kazsoSAj7MPx2F9-5Pp6UzfUehsvNw&oe=6768D1C3&_nc_sid=fc8dfb';
  String? _matchImageUrl;
  final UserService userService = UserService();

  int currentView = 0; // 0: Favorites, 1: Ratings, 2: Reviews

  List<Map<String, dynamic>>? favorite;
  List<Map<String, dynamic>>? MovieRating;
  List<Map<String, dynamic>>? MovieReview;

  // Dummy data
  // final List<String> favorites = ["Movie A", "Movie B", "Movie C"];
  // final List<String> ratings = ["Rating 1", "Rating 2", "Rating 3"];
  // final List<String> reviews = ["Review 1", "Review 2", "Review 3"];

  // final List<String> Movies = [
  //   'mad_max.jpg',
  //   'redone.jpg',
  //   'Venom.jpg',
  //   'Dune.jpg',
  //   'Secret Level.jpg'
  // ];

  // final List<String> Movietitle = [
  //   'Mad Max',
  //   'Red One',
  //   'Venom',
  //   'Dune',
  //   'Secret Level'
  // ];

  // Function to get current list
  List<Map<String, dynamic>>? getCurrentList() {
    switch (currentView) {
      case 1:
        return MovieRating;
      case 2:
        return MovieReview;
      default:
        return favorite;
    }
  }

  void getFavorites() async {
    print('initCalled too');
    String? watchUID = await getUID();

    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getFavorites(watchUID);
    setState(() {
      favorite = favoriteSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
    // print('favorite');
    // print(favorite);
  }

  void getRatings() async {
    print('initCalled getRating');

    String? watchUID = await getUID();
    print(watchUID);
    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getRatings(watchUID);
    setState(() {
      MovieRating = favoriteSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
    print('rating');
    print(MovieRating);
  }

  void getReviews() async {
    print('initCalled getRating');

    String? watchUID = await getUID();

    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getReviews(watchUID);
    setState(() {
      MovieReview = favoriteSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Future<void> _loadUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isNotEqualTo: Auth().curUserData?.username)
        .get();
    setState(() {
      users = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
    SetMatchDP();
    getFavorites();
    getRatings();
    getReviews();
  }

  void removeFirstUser() {
    if (users.isNotEmpty) {
      setState(() {
        users.removeAt(0);
        getUID();
        SetMatchDP();
      });
    } else {
      setState(() {
        _matchImageUrl = 'User not found';
      });
    }
  }

  Future<String?> getUID() async {
    String? x;
    if (users.isNotEmpty) {
      x = await userService.getUserIdFromUsername(users[0]['username']);
    }
    return x;
  }

  Future<void> SetMatchDP() async {
    String? fbid = await getUID();

    Map<String, dynamic>? response;

    if (fbid != null && users.isNotEmpty) {
      response = await userService.fetchDPbyID(fbid);
    }

    if (response != null && response.isNotEmpty) {
      setState(() {
        _matchImageUrl = response?['file_url'];
        print(_matchImageUrl);
      });

      // Handle the retrieved data
      // print('ID: ${response['fbid']}');
      // print('Name: ${response['name']}');
      // print('file_url: ${response['file_url']}');
    } else {
      setState(() {
        _matchImageUrl = 'not found';
      });
    }
  }

  TextStyle matchTextStyle() {
    return TextStyle(
      fontSize: 14,
      color: const Color.fromARGB(255, 255, 255, 255),
      shadows: [
        Shadow(
          offset: Offset(
            0.0,
            1.5,
          ), // Horizontal and vertical offset
          blurRadius: 3.0, // Blur radius
          color: Colors.black,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Match Mate"),
        ),
        body: _matchImageUrl == null ||
                favorite == null ||
                MovieRating == null ||
                MovieReview == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Stack(
                        children: [
                          // User image
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  users.isNotEmpty
                                      ? _matchImageUrl!
                                      : 'https://images.pexels.com/photos/1526/dark-blur-blurred-gradient.jpg', // Replace with actual image URL
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey,
                                  width: 2,
                                  style: BorderStyle.solid),
                              boxShadow: [
                                BoxShadow(
                                  // color: Colors.black,
                                  offset: Offset(0, 1),
                                  blurRadius: 10,
                                  // spreadRadius: 5,
                                  blurStyle: BlurStyle.outer,
                                )
                              ],
                            ),
                            child: users.isEmpty
                                ? Center(
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator()),
                                  )
                                : Container(),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ), // Dark overlay
                          ),
                          // Name, Location, Age, Gender
                          Positioned(
                            bottom: 45,
                            left: 20,
                            right: 20,
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: users.isNotEmpty
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        users.isNotEmpty
                                            ? users[0]['name']
                                            : 'Finding match..',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(
                                                0.0,
                                                1.5,
                                              ), // Horizontal and vertical offset
                                              blurRadius: 3.0, // Blur radius
                                              color: Colors.black,
                                            ),
                                          ],
                                        )),
                                    // SizedBox(height: 3),
                                    users.isNotEmpty &&
                                            (users[0]['age'] != null ||
                                                users[0]['gender'] != null)
                                        ? Text(
                                            '${users[0]['age']} ${users[0]['gender']}',
                                            style: matchTextStyle(),
                                          )
                                        : Container(),
                                    users.isNotEmpty &&
                                            users[0]['school'] != null
                                        ? Text(
                                            users[0]['school'],
                                            style: matchTextStyle(),
                                          )
                                        : Container(),
                                    users.isNotEmpty &&
                                            users[0]['location'] != null
                                        ? Text(
                                            users[0]['location'],
                                            style: matchTextStyle(),
                                          )
                                        : Container(),
                                    Row(
                                      children: users.isNotEmpty &&
                                              users[0]['genre'] != null
                                          ? List.generate(
                                              users[0]['genre'].length,
                                              (index) => Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2,
                                                            horizontal: 4),
                                                    padding: const EdgeInsets
                                                        .all(
                                                        7), // Inner padding for the container
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 52, 54, 56),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: users.isNotEmpty &&
                                                            users[0]['genre'] !=
                                                                null
                                                        ? Text(
                                                            users[0]['genre']
                                                                    [index] ??
                                                                Text('empty'),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        : Container(),
                                                  ))
                                          : [Container()],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 20,
                            right: 20,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        removeFirstUser();
                                        getFavorites();
                                        getRatings();
                                        getReviews();
                                      },
                                      child: Icon(Icons.cancel_sharp)),
                                  ElevatedButton(
                                      onPressed: () {
                                        removeFirstUser();
                                        getFavorites();
                                        getRatings();
                                        getReviews();
                                      },
                                      child: Icon(Icons.thumb_up_sharp)),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (users.isNotEmpty) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Chat(
                                                        user: users[0],
                                                      )));
                                        }
                                      },
                                      child: Icon(Icons.send)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //Ignore, like, Message

                    // Buttons for Favorites, Ratings, Reviews
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() => currentView = 0);
                          },
                          style: currentView == 0 ? changeHighlight() : null,
                          child: Text("Favorites"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => currentView = 1);
                          },
                          style: currentView == 1 ? changeHighlight() : null,
                          child: Text("Ratings"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => currentView = 2);
                          },
                          style: currentView == 2 ? changeHighlight() : null,
                          child: Text("Reviews"),
                        ),
                      ],
                    ),
                    // Horizontal ListView.builder
                    switch (currentView) {
                      0 => buildFavorite(favorite, currentView),
                      1 => buildFavorite(MovieRating, currentView),
                      2 => buildReview(MovieReview),
                      _ => Container(), // Default case (optional)
                    },
                  ],
                ),
              ),
        bottomNavigationBar: BottomNavBar(navx: 1));
  }

  Widget buildReview(reviewList) {
    return reviewList != null
        ? SizedBox(
            height: 330,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(10),
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 290,
                  padding: EdgeInsets.all(20),
                  // clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 51, 58, 62),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movie: reviewList[index],
                                      ),
                                    ));
                              },
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${reviewList[index]['poster_path']}',
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      reviewList[index]['title'],
                                      // overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (starIndex) {
                                      return starIndex <
                                              reviewList[index]['rating']
                                          ? Icon(Icons.star,
                                              size: 18,
                                              color: const Color.fromRGBO(
                                                  254, 191, 3, 1))
                                          : Icon(Icons.star,
                                              size: 18,
                                              color: const Color.fromARGB(
                                                  109, 220, 194, 107));
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 12),
                      Divider(
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          reviewList[index]['review'],
                          softWrap: true,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '0',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            child: Icon(Icons.thumb_up_alt_sharp,
                                size: 18,
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          SizedBox(width: 15),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                              child: Icon(Icons.thumb_down_alt,
                                  size: 18,
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))),
                          // Spacer(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildFavorite(media, selectedIndex) {
    return media != null
        ? SizedBox(
            height: selectedIndex != 0 ? 285 : 265,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              itemCount: media.length, // Sample item count
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            movie: media[index],
                          ),
                        ));
                  },
                  child: SizedBox(
                    width: 170,
                    child: Card(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          Container(
                            height: 180, // Fixed height for the image
                            width: double.infinity, // Full width for the card
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                // image: AssetImage('assets/${Movies[index]}'),
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${media[index]['poster_path']}',
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          // Text Section

                          switch (selectedIndex) {
                            0 => Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    media[index]['title'] ?? 'No title',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            1 => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        media[index]['title'] ?? 'No title',
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        // overflow: TextOverflow.ellipsis,
                                        overflow: TextOverflow.clip,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(5, (starIndex) {
                                          return media[index]['rating'] >
                                                  starIndex
                                              ? Icon(Icons.star,
                                                  size: 16, color: Colors.amber)
                                              : Icon(Icons.star,
                                                  size: 16,
                                                  color: const Color.fromARGB(
                                                      89, 182, 151, 57));
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            2 => Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  media[index]['review'],
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            _ => Container(), // Default case (optional)
                          },
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }

  changeHighlight() {
    return ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor:
            WidgetStatePropertyAll(const Color.fromARGB(255, 40, 42, 49)));
  }
}
