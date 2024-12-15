import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TVSeriesScreen extends StatefulWidget {
  const TVSeriesScreen({super.key});

  @override
  _TVSeriesScreenState createState() => _TVSeriesScreenState();
}

class _TVSeriesScreenState extends State<TVSeriesScreen> {
  final String apiKey =
      '9540926d9687553a0ce5551c73da26b9'; // Replace with your TMDB API key
  final String baseUrl = 'https://api.themoviedb.org/3';
  List tvSeries = [];

  @override
  void initState() {
    super.initState();
    fetchPopularTVShows();
  }

  Future<void> fetchPopularTVShows() async {
    final url =
        Uri.parse('$baseUrl/trending/tv/day?api_key=$apiKey&language=en-US');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        tvSeries = data['results'];
      });
    } else {
      throw Exception('Failed to load TV series');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Shows'),
      ),
      body: tvSeries.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tvSeries.length,
              itemBuilder: (context, index) {
                final show = tvSeries[index];
                print(show);
                return (show['poster_path'] != null && show['name'] != null)
                    ? ListTile(
                        leading: Image.network(
                          'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                          fit: BoxFit.cover,
                        ),
                        title: Text(show['name']),
                        subtitle: Text('Rating: ${show['vote_average']}'),
                      )
                    : SizedBox.shrink();
              },
            ),
    );
  }
}
