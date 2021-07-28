import 'package:top_movies/models/video_model.dart';

class VideoResponse {
  int? id;
  List<Videos>? results;

  VideoResponse({this.id, this.results});

  VideoResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['results'] != null) {
      results = <Videos>[];
      json['results'].forEach((v) {
        results!.add(new Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
