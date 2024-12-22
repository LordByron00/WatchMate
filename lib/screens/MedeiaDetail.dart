import 'package:WatchMate/services/userPreference.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieDetailPage extends StatefulWidget {
  final Map<String, dynamic> movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite = false;
  bool reviewStatus = false;
  bool ratingStatus = false;
  late Map<String, dynamic>? reviewData;
  List<String> ratingList = ['Awful', 'Meh', 'Good', 'Amazing', 'Masterpiece'];
  List<bool> isSelectedList = List.generate(5, (index) => false);

  List<String> userList = [
    'Dasha Taran',
    'Anya Taylor',
    'Hanni Pham',
    'Dannielle',
    'Kasey Lael'
  ];
  List<String> reviewList = [
    'A Masterpiece. I am at loss for words',
    'I love this movie, this is amazing!',
    'So bad, i do not like how they killed the character',
    'This is such as waste of time I gucking hate it.',
    'Don\'t waste your time on this garbase',
  ];

  @override
  void initState() {
    super.initState();
    setReview();
    setRating();
    loadFavoriteStatus();
    loadReviewStatus();
    loadratingStatus();
  }

  void _showRatingPopup(BuildContext context) {
    int starRating = 0; // Rating value (0 to 5)
    TextEditingController reviewController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Rate This Item')),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isSelectedList[index]
                                ? const Color.fromARGB(255, 255, 113, 74)
                                : const Color.fromARGB(255, 179, 75, 46),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            ratingList[index],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        onTap: () {
                          starRating = index + 1;
                          for (int i = 0; i < isSelectedList.length; i++) {
                            setState(() {
                              isSelectedList[i] = false;
                            });
                          }

                          setState(() {
                            isSelectedList[index] = !isSelectedList[index];
                          });
                          print('isSelected:');
                          print(isSelectedList[index]);
                        },
                      ),
                    );
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: isSelectedList[index + 3]
                                ? const Color.fromARGB(255, 255, 113, 74)
                                : const Color.fromARGB(255, 179, 75, 46),
                          ),
                          child: Text(
                            ratingList[index + 3],
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        onTap: () {
                          starRating = index + 4;
                          for (int i = 0; i < isSelectedList.length; i++) {
                            setState(() {
                              isSelectedList[i] = false;
                            });
                          }
                          setState(() {
                            isSelectedList[index + 3] =
                                !isSelectedList[index + 3];
                          });
                          print('isSelected:');
                          print(isSelectedList[index + 3]);
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                // Review Text Field (optional)
              ],
            );
          }),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clear Button
                ElevatedButton(
                  onPressed: () async {
                    await PreferenceService().clearRating(widget.movie);
                    loadratingStatus();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                //cancel button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                // Rate Button
                ElevatedButton(
                  onPressed: () async {
                    // Handle the rating submission here
                    if (starRating > 0) {
                      // Submit the rating and review
                      print('Rating: $starRating');
                      print('Review: ${reviewController.text}');

                      Map<String, dynamic> movieRating = {
                        ...widget.movie,
                        'rating': starRating,
                      };
                      await PreferenceService().addRating(movieRating);
                      setRating();
                      loadratingStatus();
                    } else {
                      // Show a message if no rating was given
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please provide a rating')),
                      );
                    }
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Rate',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showReviewPopup(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    int starRating = (reviewData?['rating'] ?? 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave a Review'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            starRating = index + 1;
                          });
                        },
                        child: Icon(
                          index < starRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 37,
                        ),
                      );
                    }),
                  ),
                  // Review Text Field
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      labelText: reviewData?['review'] ?? 'Your review',
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    await PreferenceService().clearReview(widget.movie);
                    loadReviewStatus();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Handle the submission logic here
                    // print('Review: ${reviewController.text}');
                    // print('Rating: $starRating');

                    Map<String, dynamic> movieReview = {
                      ...widget.movie,
                      'review': reviewController.text,
                      'rating': starRating,
                    };

                    await PreferenceService().addReview(movieReview);
                    setReview();
                    loadReviewStatus();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.movie);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      backgroundColor: Colors.black54, // Dim background to focus on the pop-up
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Movie Poster and Bottom Overlay
                Stack(
                  children: [
                    // Background Image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}', // Replace with movie poster URL
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                        // colorBlendMode: BlendMode.luminosity,
                      ),
                    ),
                    // Bottom Overlay with Title and Buttons
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Movie Title
                            Text(
                              widget
                                  .movie['title'], // Replace with actual title
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.movie['release_date'],
                              style: TextStyle(color: Colors.white),
                            ),
                            // Add to Watchlist Button
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Description, Actions, and Reviews

                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rate and Review Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                bool favorite = await PreferenceService()
                                    .addFavorite(widget.movie);
                                setState(() {
                                  isFavorite = favorite;
                                });
                                print('Added to Favorite');
                              },
                              label: Text(
                                'favorite',
                                style: TextStyle(fontSize: 12),
                              ),
                              icon: Icon(
                                FontAwesomeIcons.solidHeart,
                                color: isFavorite ? Colors.red : Colors.white,
                                size: 14,
                              ),
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: Colors.black,
                              //   foregroundColor: Colors.white,
                              // ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showRatingPopup(context);
                                print('Rate');
                              },
                              child: Text(
                                ratingStatus ? 'Rated' : 'Rate',
                                style: TextStyle(
                                    color: ratingStatus
                                        ? const Color.fromARGB(255, 221, 97, 36)
                                        : Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _showReviewPopup(context);
                              },
                              child: Text(
                                reviewStatus ? 'Edit Review' : 'Review',
                                style: TextStyle(
                                    color: reviewStatus
                                        ? const Color.fromARGB(255, 221, 97, 36)
                                        : Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Movie Synopsis overview
                        Text(
                          widget.movie['overview'],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        // Star Rating
                        Row(
                            // padding: const EdgeInsets.all(4.0),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                size: 22,
                                color: Colors.amber,
                              ),
                              Text('${widget.movie['vote_average']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ))
                            ]),
                        // Row(
                        //   children: List.generate(5, (index) {
                        //     return Icon(Icons.star, color: Colors.amber);
                        //   }),
                        // ),
                        SizedBox(height: 10),
                        // User Reviews Title
                        Text(
                          'User Reviews',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        // Reviews ListView
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(right: 10),
                                width: 200,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(child: Icon(Icons.person)),
                                    SizedBox(height: 5),
                                    Text(
                                      userList[index],
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (starIndex) {
                                        return Icon(Icons.star,
                                            size: 16, color: Colors.amber);
                                      }),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      reviewList[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(navx: 0),
    );
  }

  Future<void> loadFavoriteStatus() async {
    bool favorite = await PreferenceService().checkFavorite(widget.movie);
    setState(() {
      isFavorite = favorite;
    });
  }

  void loadReviewStatus() async {
    bool reviewStatus2 =
        await PreferenceService().checkReviewStatus(widget.movie);
    setState(() {
      reviewStatus = reviewStatus2;
    });
  }

  void setReview() async {
    QuerySnapshot<Object?> reviewSnap =
        await PreferenceService().checkReview(widget.movie);

    if (reviewSnap.docs.isNotEmpty) {
      setState(() {
        reviewData = reviewSnap.docs.first.data() as Map<String, dynamic>;
      });
    } else {
      reviewData = null;
      print('it returned even empty');
    }
  }

  void setRating() async {
    QuerySnapshot<Object?> ratingSnap =
        await PreferenceService().checkRating(widget.movie);

    if (ratingSnap.docs.isNotEmpty) {
      Map<String, dynamic>? ratingData =
          ratingSnap.docs.first.data() as Map<String, dynamic>;
      setState(() {
        int i = ratingData?['rating'];
        print('rating');
        print(i);
        // int indexRating = i.toInt();
        isSelectedList[i - 1] = true;
      });
    } else {
      reviewData = null;
      print('it returned even empty');
    }
  }

  void loadratingStatus() async {
    bool ratingStat = await PreferenceService().checkRatingStatus(widget.movie);
    setState(() {
      ratingStatus = ratingStat;
    });
  }
}
