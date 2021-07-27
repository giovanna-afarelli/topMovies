import 'package:top_movies/models/backdrops.dart';
import 'package:top_movies/models/posters.dart';

class MovieImages {
  int? id;
  List<Backdrops>? backdrops;
  List<Posters>? posters;

  MovieImages({this.id, this.backdrops, this.posters});

  MovieImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['backdrops'] != null) {
      backdrops = <Backdrops>[];
      json['backdrops'].forEach((v) {
        backdrops!.add(new Backdrops.fromJson(v));
      });
    }
    if (json['posters'] != null) {
      posters = <Posters>[];
      json['posters'].forEach((v) {
        posters!.add(new Posters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.backdrops != null) {
      data['backdrops'] = this.backdrops!.map((v) => v.toJson()).toList();
    }
    if (this.posters != null) {
      data['posters'] = this.posters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
