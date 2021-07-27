import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres_api_response.dart';
import 'package:top_movies/network/rest_client.dart';

class HomeRepository {
  final RestClient restClient;

  HomeRepository({required this.restClient});

  Future<ApiResponse> getTrendingMovies(String time) async {
    return restClient.getTrendingMovies(time);
  }

  Future<ApiResponse> getPopularMovies() async {
    return restClient.getPopularMovies();
  }

  Future<ApiResponse> getPopularMoviesNextPage(int page) async {
    return restClient.getPopularMoviesNextPage(page);
  }

  Future<GenresApiResponse> getGenres() async {
    return restClient.getGenres();
  }
}
