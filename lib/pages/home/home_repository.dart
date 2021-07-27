import 'package:dio/dio.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres_api_response.dart';
import 'package:top_movies/network/rest_client.dart';

class HomeRepository {
  final RestClient restClient = RestClient(Dio());

  HomeRepository();

  Future<ApiResponse> getTrendingMovies(String time) async {
    return restClient.getTrendingMovies(time);
  }

  Future<ApiResponse> getPopularMovies() async {
    return restClient.getPopularMovies();
  }

  Future<ApiResponse> getPopularMoviesByGenre(
      String sort, int page, int voteL, String genres) async {
    return restClient.getPopularMoviesByGenre(sort, page, voteL, genres);
  }

  Future<ApiResponse> getPopularMoviesNextPage(int page) async {
    return restClient.getPopularMoviesNextPage(page);
  }

  Future<GenresApiResponse> getGenres() async {
    return restClient.getGenres();
  }
}
