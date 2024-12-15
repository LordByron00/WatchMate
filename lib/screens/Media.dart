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
                              onPressed: () => {print('Review')},
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
