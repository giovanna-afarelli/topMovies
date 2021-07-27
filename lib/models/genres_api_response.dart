import 'package:top_movies/models/genres.dart';

class GenresApiResponse {
  List<Genres>? genres;

  GenresApiResponse({this.genres});

  GenresApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['genres'] != null) {
      genres = <Genres>[];
      json['genres'].forEach((v) {
        genres!.add(new Genres.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.genres != null) {
      data['genres'] = this.genres!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
