class Movie {
  final int id;
  final String title;
  final String posterPath;
  String backdropPath; // Add backdrop_path
  String overview; // Add overview
  double voteAverage; // Add vote_average
  int voteCount; // Add vote_count
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    this.backdropPath = "", // Initialize backdropPath
    this.overview = "", // Initialize overview
    this.voteAverage = 0, // Initialize voteAverage
    this.voteCount = 0, // Initialize voteCount
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: 'https://image.tmdb.org/t/p/w500/${json['poster_path']}',
      backdropPath:
          'https://image.tmdb.org/t/p/w500/${json['backdrop_path']}', // Construct backdropPath URL
      overview: json['overview'] ?? '', // Handle null overview
      voteAverage: (json['vote_average'] as num?)?.toDouble() ??
          0.0, // Correct type handling and null safety
      voteCount: json['vote_count'] ?? 0, // Handle null vote_count
    );
  }
}
