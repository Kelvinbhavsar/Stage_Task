import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Add Hive

import 'package:provider/provider.dart';
import 'package:sample_movie_app/Model/movieModel.dart';
import 'package:sample_movie_app/Provider/movieAdapter.dart';
import 'package:sample_movie_app/Screens/movieList.dart';
import 'Provider/movieProvider.dart';

void main() async {
  // Initialize Hive before running the app
  await Hive.initFlutter();

  // Register the Movie adapter
  Hive.registerAdapter(MovieAdapter());

  // Open the Hive box.  Use a unique name for your box.
  await Hive.openBox<Movie>('favoriteMovies');
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Movie List'),
    );
  }
}
