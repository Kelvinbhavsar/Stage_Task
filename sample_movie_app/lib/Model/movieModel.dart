import 'package:hive_flutter/hive_flutter.dart';

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

// Create a Hive adapter for the Movie class

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0; // Assign a unique type ID

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      backdropPath: fields[3] as String,
      overview: fields[4] as String,
      voteAverage: fields[5] as double,
      voteCount: fields[6] as int,
      isFavorite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(8) // Number of fields
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.backdropPath)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.voteAverage)
      ..writeByte(6)
      ..write(obj.voteCount)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }
}
