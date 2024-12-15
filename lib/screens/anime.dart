import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AnimeListScreen extends StatefulWidget {
  @override
  _AnimeListScreenState createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen> {
  final String baseUrl = 'https://api.jikan.moe/v4';
  List animeList = [];

  @override
  void initState() {
    super.initState();
    fetchTopAnime();
  }

  Future<void> fetchTopAnime() async {
    final url = Uri.parse('$baseUrl/top/anime');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        animeList = data['data'];
      });
    } else {
      throw Exception('Failed to load anime');
    }
  }

  Future<Map<String, dynamic>> getAnime(int animeId) async {
    final response =
        await http.get(Uri.parse('https://api.jikan.moe/v4/anime/$animeId'));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Anime'),
      ),
      body: animeList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                return ListTile(
                  leading: Image.network(
                    anime['images']['jpg']['image_url'],
                    fit: BoxFit.cover,
                  ),
                  title: Text(anime['title']),
                  subtitle: Text('Score: ${anime['score']}'),
                );
              },
            ),
    );
  }
}
