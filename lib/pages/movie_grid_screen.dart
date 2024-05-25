import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:umdb/pages/new_popular_page.dart';
import 'package:umdb/pages/new_top_rated_page.dart';

import '../models/movie.dart';

class MovieGridscreen extends StatefulWidget {
  const MovieGridscreen({super.key});

  @override
  State<MovieGridscreen> createState() => _MovieGridscreenState();
}

class _MovieGridscreenState extends State<MovieGridscreen> {
  Future<MovieList>? topRatedMovies;
  Future<MovieList>? futureMovies;

  Future<MovieList> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/popular_movies.json');
    final jsonResponse = json.decode(jsonString);
    return MovieList.fromJson(jsonResponse);
  }

  Future<MovieList> fetchTopRatedMovies() async {
    final response = await http.get(Uri.parse('https://movie-api-rish.onrender.com/top-rated'));

    if (response.statusCode == 200) {
      final jsonResponse2 = json.decode(response.body);
      return MovieList.fromJson(jsonResponse2);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  void initState() {
    super.initState();
    futureMovies = loadJsonData();
    topRatedMovies = fetchTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.only(top: 46.0, left: 16.0, right: 16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Movies',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewPopularMovies()),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<MovieList>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.redAccent)));
                  } else {
                    final movies = snapshot.data?.items ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[800],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(movies[index].title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(movies[index].year, style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Rated Movies',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewTopRatedMovies()),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<MovieList>(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.redAccent)));
                  } else {
                    final topMovies = snapshot.data?.items ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[800],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(topMovies[index].title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(topMovies[index].year, style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
