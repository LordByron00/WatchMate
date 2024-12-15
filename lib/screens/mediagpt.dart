import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatelessWidget {
  final dynamic movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    print(movie);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      backgroundColor: Colors.black54, // Dim background to focus on the pop-up
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            // width: double.infinity,
            // height: double.infinity,
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
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}', // Replace with movie poster URL
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // height: double.infinity,
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
                              movie['title'], // Replace with actual title
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              movie['release_date'],
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
                              onPressed: () {
                                print('Add to Watchlist');
                              },
                              icon: Icon(Icons.add),
                              label: Text('Watchlist'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Rate');
                              },
                              child: Text('Rate'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Review');
                              },
                              child: Text('Review'),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Movie Synopsis overview
                        Text(
                          movie['overview'],
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
                              Text('${movie['vote_average']}',
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
                            itemCount: 10,
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
                                      'User $index',
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
                                      'Great movie! Highly recommend.',
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
}
