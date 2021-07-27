class Movie {
  bool? video;
  double? voteAverage;
  String? overview;
  int? id;
  String? title;
  bool? adult;
  String? backdropPath;
  int? voteCount;
  List<int>? genreIds;
  String? releaseDate;
  String? originalLanguage;
  String? originalTitle;
  String? posterPath;
  double? popularity;
  String? mediaType;

  Movie(
      {this.video,
      this.voteAverage,
      this.overview,
      this.id,
      this.title,
      this.adult,
      this.backdropPath,
      this.voteCount,
      this.genreIds,
      this.releaseDate,
      this.originalLanguage,
      this.originalTitle,
      this.posterPath,
      this.popularity,
      this.mediaType});

  Movie.fromJson(Map<String, dynamic> json) {
    video = json['video'];
    voteAverage = json['vote_average'];
    overview = json['overview'];
    id = json['id'];
    title = json['title'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    voteCount = json['vote_count'];
    genreIds = json['genre_ids'].cast<int>();
    releaseDate = json['release_date'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    posterPath = json['poster_path'];
    popularity = json['popularity'];
    mediaType = json['media_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['overview'] = this.overview;
    data['id'] = this.id;
    data['title'] = this.title;
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['vote_count'] = this.voteCount;
    data['genre_ids'] = this.genreIds;
    data['release_date'] = this.releaseDate;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['poster_path'] = this.posterPath;
    data['popularity'] = this.popularity;
    data['media_type'] = this.mediaType;
    return data;
  }
}
