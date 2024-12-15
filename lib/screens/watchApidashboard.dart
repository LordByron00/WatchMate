import 'dart:convert';
import 'package:WatchMate/screens/mediagpt.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class dashboardMate extends StatefulWidget {
  const dashboardMate({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<dashboardMate> {
  final String apiKey =
      '9540926d9687553a0ce5551c73da26b9'; // Replace with your TMDb API key
  final String baseUrl = 'https://api.themoviedb.org/3';

  Map<String, List<dynamic>> categorizedData = {
    'Action': [],
    'Comedy': [],
    'Drama': [],
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      // Fetch movies for each genre
      await Future.wait([
        fetchGenreMovies('Action', 28), // Genre ID for Action
        fetchGenreMovies('Comedy', 35), // Genre ID for Comedy
        fetchGenreMovies('Drama', 18), // Genre ID for Drama
      ]);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  Future<void> fetchGenreMovies(String genre, int genreId) async {
    final url = '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categorizedData[genre] = data['results'];
      });
    } else {
      throw Exception('Failed to load $genre movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('WatchMate'),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Search functionality can be added here
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: categorizedData.entries.map((entry) {
                final genre = entry.key;
                final movies = entry.value;

                return buildGenreSection(genre, movies);
              }).toList(),
            ),
      bottomNavigationBar: BottomNavBar(
        navx: 0,
      ),
    );
  }

  Widget buildGenreSection(String genre, List<dynamic> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            genre,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movie: movie,
                        ),
                      ));
                },
                child: buildMovieCard(movie),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildMovieCard(dynamic movie) {
    final String imageUrl =
        'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 120,
        child: Card(
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie['title'] ?? 'Untitled',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '⭐ ${movie['vote_average']}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
