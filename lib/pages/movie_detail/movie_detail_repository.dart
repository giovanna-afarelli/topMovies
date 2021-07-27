import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/models/movie_images.dart';
import 'package:top_movies/network/rest_client.dart';

class MovieDetailRepository {
  final RestClient restClient;

  MovieDetailRepository({required this.restClient});

  Future<MovieDetail> getMovieDetail(int movieId) async {
    return restClient.getMovieDetail(movieId);
  }

  Future<MovieImages> getMovieImages(int movieId) async {
    return restClient.getMovieImages(movieId);
  }
}
