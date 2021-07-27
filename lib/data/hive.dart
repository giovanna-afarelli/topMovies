import 'package:hive/hive.dart';

part 'hive.g.dart';

@HiveType(typeId: 1)
class Favorites {
  Favorites({required this.list});

  @HiveField(0)
  List<Movies> list;
}

@HiveType(typeId: 2)
class Movies {
  @HiveField(0)
  num? voteAverage;
  @HiveField(1)
  String? overview;
  @HiveField(2)
  int? id;
  @HiveField(3)
  String? title;
  @HiveField(4)
  int? voteCount;
  @HiveField(5)
  List<int>? genreIds;
  @HiveField(6)
  String? releaseDate;
  @HiveField(7)
  String? originalLanguage;
  @HiveField(8)
  String? originalTitle;
  @HiveField(9)
  String? posterPath;
  @HiveField(10)
  double? popularity;

  Movies({
    this.voteAverage,
    this.overview,
    this.id,
    this.title,
    this.voteCount,
    this.genreIds,
    this.releaseDate,
    this.originalLanguage,
    this.originalTitle,
    this.posterPath,
    this.popularity,
  });
}
