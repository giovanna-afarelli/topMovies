import 'package:top_movies/models/movie.dart';
import 'package:top_movies/network/rest_client.dart';

class MovieDetailRepository {
  final RestClient restClient;

  MovieDetailRepository({required this.restClient});

  Future<Movie> getMovieDetail(int movieId) async {
    return restClient.getMovieDetail(movieId);
  }
}
