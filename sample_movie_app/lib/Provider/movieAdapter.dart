// // Create a Hive adapter for the Movie class
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sample_movie_app/Model/movieModel.dart';

// class MovieAdapter extends TypeAdapter<Movie> {
//   @override
//   final int typeId = 0; // Assign a unique type ID

//   @override
//   Movie read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Movie(
//       id: fields[0] as int,
//       title: fields[1] as String,
//       posterPath: fields[2] as String,
//       backdropPath: fields[3] as String,
//       overview: fields[4] as String,
//       voteAverage: fields[5] as double,
//       voteCount: fields[6] as int,
//       isFavorite: fields[7] as bool,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Movie obj) {
//     writer
//       ..writeByte(8) // Number of fields
//       ..writeByte(0)
//       ..write(obj.id)
//       ..writeByte(1)
//       ..write(obj.title)
//       ..writeByte(2)
//       ..write(obj.posterPath)
//       ..writeByte(3)
//       ..write(obj.backdropPath)
//       ..writeByte(4)
//       ..write(obj.overview)
//       ..writeByte(5)
//       ..write(obj.voteAverage)
//       ..writeByte(6)
//       ..write(obj.voteCount)
//       ..writeByte(7)
//       ..write(obj.isFavorite);
//   }
// }
