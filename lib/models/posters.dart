class Posters {
  num? aspectRatio;
  String? filePath;
  int? height;
  String? iso6391;
  num? voteAverage;
  int? voteCount;
  int? width;

  Posters(
      {this.aspectRatio,
      this.filePath,
      this.height,
      this.iso6391,
      this.voteAverage,
      this.voteCount,
      this.width});

  Posters.fromJson(Map<String, dynamic> json) {
    aspectRatio = json['aspect_ratio'];
    filePath = json['file_path'];
    height = json['height'];
    iso6391 = json['iso_639_1'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aspect_ratio'] = this.aspectRatio;
    data['file_path'] = this.filePath;
    data['height'] = this.height;
    data['iso_639_1'] = this.iso6391;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    data['width'] = this.width;
    return data;
  }
}
