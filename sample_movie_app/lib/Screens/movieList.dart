import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sample_movie_app/Model/movieModel.dart';
import 'package:sample_movie_app/Provider/movieProvider.dart';
import 'package:sample_movie_app/Screens/movieDetails.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showFavorites = false;
  bool isOffline = false;

  TextEditingController search = TextEditingController();
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().fetchMovies();
    });
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      // print(isOffline);
      isOffline = connectivityResult.contains(ConnectivityResult.none);
      print("object ${connectivityResult.join().toString()}");
      print("isOffline $isOffline");
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    var box = Hive.box<Movie>('favoriteMovies');
    box.values.forEach((element) {
      print(element.title);
    });

    List<Movie> displayedMovies = isOffline
        ? box.values.toList()
        : showFavorites
            ? box.values.toList()
            : movieProvider.movies;

    List<Movie> allMovies = showFavorites
        ? movieProvider.movies.where((movie) => movie.isFavorite).toList()
        : movieProvider.movies;

    // Filter movies based on search query
    List<Movie> filteredMovies = allMovies.where((movie) {
      return movie.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // movieProvider.fetchMovies();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              movieProvider.fetchMovies();
            },
          ),
          IconButton(
            icon: Icon(showFavorites ? Icons.list : Icons.favorite),
            onPressed: () {
              setState(() {
                showFavorites = !showFavorites;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: search,
              onChanged: (query) {
                setState(() {
                  searchQuery = query; // Update search query
                });
              },
              decoration: InputDecoration(
                hintText: "Search movies...",
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            search.text = '';
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: movieProvider.isLoading // Check loading state directly
                ? const Center(child: CircularProgressIndicator())
                : movieProvider.movies
                        .isEmpty // Check for empty list only after loading is done
                    ? const Center(child: Text('No movies found'))
                    : filteredMovies.isEmpty
                        ? const Center(child: Text('No movies found'))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                            ),
                            // ...itemBuilder remains the same but access movies via provider...

                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailsPage(
                                          movie: filteredMovies[index]),
                                    ),
                                  );
                                },
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Image.network(
                                        filteredMovies[index].posterPath,
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.4,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.26, // Adjust height as needed
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                filteredMovies[index].title,
                                                maxLines: 1,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  movieProvider.toggleFavorite(
                                                      filteredMovies[index].id),
                                              icon: Icon(
                                                filteredMovies[index].isFavorite
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: filteredMovies.length,
                          ),
          )
        ],
      ),
    );
  }
}
