import 'package:flutter/material.dart';

class Media extends StatefulWidget {
  const Media({super.key});

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  // final String imageUrl = '/assets/mad_max.jpg';
  final String imageUrl =
      'https://oberlinreview.org/wp-content/uploads/2022/03/Batman_-Courtesy-of-DC-Comics-.jpg';

  void _showReviewPopup(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    double starRating = 0.0;

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
                      return IconButton(
                        icon: Icon(
                          index < starRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            starRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  // Review Text Field
                  TextField(
                    controller: reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Your review',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the submission logic here
                print('Review: ${reviewController.text}');
                print('Rating: $starRating');
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.6,
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                      height: 400,
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(8.0),
                      // color: Colors.black,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              onPressed: () => {print('Watchlist')},
                              label: Text('Watch Later')),
                          ElevatedButton.icon(
                              icon: Icon(Icons.star_rate),
                              onPressed: () => {print('Rating')},
                              label: Text('Rate')),
                          ElevatedButton.icon(
                              icon: Icon(Icons.reviews),
                              onPressed: () => {_showReviewPopup},
                              label: Text('Review')),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
