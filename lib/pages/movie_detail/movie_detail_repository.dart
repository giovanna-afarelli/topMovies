import 'package:dio/dio.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/models/movie_images.dart';
import 'package:top_movies/models/video_response.dart';
import 'package:top_movies/network/rest_client.dart';

class MovieDetailRepository {
  final RestClient restClient = RestClient(Dio());

  MovieDetailRepository();

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
}
