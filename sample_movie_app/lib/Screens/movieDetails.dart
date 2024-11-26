// movie_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_movie_app/Model/movieModel.dart';
import 'package:sample_movie_app/Provider/movieProvider.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(movie.title),
      // ),
      body: Stack(children: [
        SingleChildScrollView(
          // For scrollable content

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                height: MediaQuery.sizeOf(context).height *
                    0.35, // Set a fixed height for the banner image
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // Row for title and favorite button
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          // Wrapped title in Flexible to prevent overflow
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            movie.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            movieProvider.toggleFavorite(movie.id);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Add more movie details here (synopsis, cast, reviews, etc.)
                    Text(
                      movie.overview, // Replace with actual synopsis
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Row(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      print('object');
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
