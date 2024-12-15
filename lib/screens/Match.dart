import 'dart:ui';

import 'package:WatchMate/screens/Chat.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class MatchMate extends StatefulWidget {
  const MatchMate({Key? key}) : super(key: key);

  @override
  State<MatchMate> createState() => _MatchMateState();
}

class _MatchMateState extends State<MatchMate> {
  int currentView = 0; // 0: Favorites, 1: Ratings, 2: Reviews

  // Dummy data
  final List<String> favorites = ["Movie A", "Movie B", "Movie C"];
  final List<String> ratings = ["Rating 1", "Rating 2", "Rating 3"];
  final List<String> reviews = ["Review 1", "Review 2", "Review 3"];

  final List<String> Movies = [
    'mad_max.jpg',
    'redone.jpg',
    'Venom.jpg',
    'Dune.jpg',
    'Secret Level.jpg'
  ];

  final List<String> Movietitle = [
    'Mad Max',
    'Red One',
    'Venom',
    'Dune',
    'Secret Level'
  ];

  // Function to get current list
  List<String> getCurrentList() {
    switch (currentView) {
      case 1:
        return ratings;
      case 2:
        return reviews;
      default:
        return favorites;
    }
  }

  Widget buildMovie(int index) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        color: const Color.fromARGB(255, 41, 39, 39),
        width: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 180, // Fixed height for the image
              width: double.infinity, // Full width for the card
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${Movies[index]}'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                Movietitle[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Image.network(
            //     'https://i1.sndcdn.com/artworks-dnl5nAJKNjLM05B6-bkFueg-t500x500.jpg'),
            // Text(
            //   getCurrentList()[index],
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.black),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildMovieRating(int index) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        color: const Color.fromARGB(255, 41, 39, 39),
        width: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 200, // Fixed height for the image
              width: double.infinity, // Full width for the card
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${Movies[index]}'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                Movietitle[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (starIndex) {
                return Icon(Icons.star, size: 16, color: Colors.amber);
              }),
            ),
            // Image.network(
            //     'https://i1.sndcdn.com/artworks-dnl5nAJKNjLM05B6-bkFueg-t500x500.jpg'),
            // Text(
            //   getCurrentList()[index],
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.black),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildMovieReview(int index) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        color: const Color.fromARGB(255, 41, 39, 39),
        width: 120,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 180, // Fixed height for the image
              width: double.infinity, // Full width for the card
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/${Movies[index]}'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                Movietitle[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('This movie is so wonderful!'),
            // Image.network(
            //     'https://i1.sndcdn.com/artworks-dnl5nAJKNjLM05B6-bkFueg-t500x500.jpg'),
            // Text(
            //   getCurrentList()[index],
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.black),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Match Mate"),
        ),
        body: SingleChildScrollView(
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
                            'https://i1.sndcdn.com/artworks-dnl5nAJKNjLM05B6-bkFueg-t500x500.jpg', // Replace with actual image URL
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
                      bottom: 50,
                      left: 20,
                      right: 20,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Hanni Pham",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              SizedBox(height: 5),
                              Text(
                                "Seoul, South Korea",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text("20", style: TextStyle(color: Colors.white)),
                              Text(
                                "Female",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {},
                                child: Icon(Icons.cancel_sharp)),
                            ElevatedButton(
                                onPressed: () {},
                                child: Icon(Icons.thumb_up_sharp)),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chat()));
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
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Movies.length,
                  itemBuilder: (context, index) {
                    switch (currentView) {
                      case 1:
                        return buildMovieRating(index);
                      case 2:
                        return buildMovieReview(index);
                      default:
                        return buildMovie(index);
                    }
                    // return Card(
                    //   margin: EdgeInsets.all(10),
                    //   child: Container(
                    //     color: const Color.fromARGB(255, 41, 39, 39),
                    //     width: 120,
                    //     alignment: Alignment.center,
                    //     padding: EdgeInsets.all(10),
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           height: 180, // Fixed height for the image
                    //           width: double.infinity, // Full width for the card
                    //           decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //               image: AssetImage('assets/${Movies[index]}'),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             borderRadius: BorderRadius.only(
                    //               topLeft: Radius.circular(10),
                    //               topRight: Radius.circular(10),
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.all(8.0),
                    //           child: Text(
                    //             Movietitle[index],
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.white,
                    //             ),
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //         ),
                    //         // Image.network(
                    //         //     'https://i1.sndcdn.com/artworks-dnl5nAJKNjLM05B6-bkFueg-t500x500.jpg'),
                    //         // Text(
                    //         //   getCurrentList()[index],
                    //         //   textAlign: TextAlign.center,
                    //         //   style: TextStyle(color: Colors.black),
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar(navx: 1));
  }

  changeHighlight() {
    return ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        backgroundColor:
            WidgetStatePropertyAll(const Color.fromARGB(255, 40, 42, 49)));
  }
}
