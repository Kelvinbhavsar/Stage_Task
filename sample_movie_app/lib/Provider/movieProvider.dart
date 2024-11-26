import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sample_movie_app/Model/movieModel.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies; // Getter for movies
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    _isLoading = true; // Indicate loading
    notifyListeners();
    const apiKey =
        '4186dbd7398020e620cfb75b8c8322db'; // Replace with your API key
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> results = jsonData['results'];
        print("added new response");
        _movies =
            results.map((movieData) => Movie.fromJson(movieData)).toList();

        _isLoading = false;
        notifyListeners();
      } else {
        // Handle error (e.g., show a snackbar)
        _movies = [];
        _isLoading = false;
        print('Error fetching movies: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      _isLoading = false;
      _movies = [];
      print('Error fetching movies: ${e}');
    }
    notifyListeners();
  }

  void toggleFavorite(int movieId) {
    final movieIndex = movies.indexWhere((movie) => movie.id == movieId);
    if (movieIndex != -1) {
      print(movies[movieIndex].isFavorite);
      if (movies[movieIndex].isFavorite) {
        movies[movieIndex].isFavorite = false;
      } else {
        movies[movieIndex].isFavorite = true;
      }
      print(movies[movieIndex].isFavorite);
      // This tells the UI to rebuild.
    }
    notifyListeners();
  }

  Future<void> addFavorite(Movie movie) async {
    var box = Hive.box<Movie>('favoriteMovies');
    print("object ${movie.toString()}");
// Check if the movie with the same ID already exists in the favorites box

    final existingMovie = box.values.firstWhere((m) => m.id == movie.id);

    if (existingMovie.id == movie.id) {
      //If found, Update
      box.delete(movie.id);
    } else {
      // If not found, add the movie to the favorites box
      box.put(movie.id, movie);
    }

    notifyListeners();
  }

  Future<void> removeFavorite(int movieId) async {
    var box = Hive.box<Movie>('favoriteMovies');
    print("object $movieId");
    await box.delete(movieId);
    notifyListeners();
  }
}
