import 'package:dio/dio.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres_api_response.dart';
import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/models/movie_images.dart';
import 'package:top_movies/models/video_response.dart';
import 'package:top_movies/network/rest_client.dart';

class Repository {
  final RestClient restClient = RestClient(Dio());

  Repository();

  Future<ApiResponse> getTrendingMovies(String time) async {
    return restClient.getTrendingMovies(time);
  }

  Future<ApiResponse> getPopularMovies() async {
    return restClient.getPopularMovies();
  }

  Future<ApiResponse> getPopularMoviesNextPage(int page) async {
    return restClient.getPopularMoviesNextPage(page);
  }

  Future<ApiResponse> getPopularMoviesByGenre(
      String sort, int page, int voteL, String genres) async {
    return restClient.getPopularMoviesByGenre(sort, page, voteL, genres);
  }

  Future<GenresApiResponse> getGenres() async {
    return restClient.getGenres();
  }

  Future<MovieDetail> getMovieDetail(int movieId) async {
    return restClient.getMovieDetail(movieId);
  }

  Future<MovieImages> getMovieImages(int movieId) async {
    return restClient.getMovieImages(movieId);
  }

  Future<VideoResponse> getMovieVideos(int movieId) async {
    return restClient.getMovieVideos(movieId);
  }

  Future<ApiResponse> getMovieRecommendations(int movieId, int page) async {
    return restClient.getMovieRecommendations(movieId, page);
  }

  Future<ApiResponse> searchMovies(String query, int page) async {
    return restClient.searchMovies(query, page);
  }
}
