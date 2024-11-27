import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart'; // Add mockito
import 'package:sample_movie_app/Model/movieModel.dart'; // Import your movie model

import 'package:sample_movie_app/Provider/movieProvider.dart'; // Import Provider
import 'package:sample_movie_app/Screens/movieDetails.dart';
import 'package:sample_movie_app/Screens/movieList.dart';
import 'package:sample_movie_app/main.dart';

// Create a mock HTTP client for testing
// class MockClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ... Other Tests

  testWidgets('Movie list displays and navigates to details',
      (WidgetTester tester) async {
    // Create mock data
    final mockMovies = [
      Movie(
          id: 1,
          title: 'Movie 1',
          posterPath: 'poster1.jpg',
          backdropPath: 'backdrop1.jpg',
          overview: 'Overview 1',
          voteAverage: 8.0,
          voteCount: 1000),
      Movie(
          id: 2,
          title: 'Movie 2',
          posterPath: 'poster2.jpg',
          backdropPath: 'backdrop2.jpg',
          overview: 'Overview 2',
          voteAverage: 7.0,
          voteCount: 500),
    ];

// Create a mock HTTP client
    final mockClient = http.Client();

    // when(mockClient.get(Uri.parse('https://example.com')))
    //     .thenAnswer((_) async => http.Response('{}', 200));

    // Now, using mockClient.get() will return a Future<http.Response>.
    // final response = await mockClient.get(Uri.parse('https://example.com'));
    // expect(response.statusCode, 200);

    // Mock the API response
    when(mockClient.get(Uri.parse(
            "https://run.mocky.io/v3/d33a4e9d-ed8d-43ed-841d-22afa3c0fa44")))
        .thenAnswer((_) async => http.Response(
            '{"results": ${jsonEncode(mockMovies.map((e) => e.toJson()).toList())}}',
            200));

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => MovieProvider(), // Use MockClient
        child: const MaterialApp(home: MyHomePage(title: 'Movie List')),
      ),
    );

    // Verify loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for API call to complete and UI to rebuild
    await tester.pumpAndSettle();

    // Verify that movies are displayed
    expect(find.text('Movie 1'), findsOneWidget);
    expect(find.text('Movie 2'), findsOneWidget);

    // Tap on the first movie to navigate to details page
    await tester.tap(find.text('Movie 1'));
    await tester.pumpAndSettle();

    // Verify navigation to the details page
    expect(find.byType(MovieDetailsPage), findsOneWidget);
    expect(find.text('Movie 1'), findsOneWidget);
  });
}

// Add toJson() method to your Movie class
extension MovieExtension on Movie {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'overview': overview,
      'vote_average': voteAverage,
      'vote_count': voteCount
    };
  }
}
