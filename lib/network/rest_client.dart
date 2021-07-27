import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres_api_response.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/models/movie_images.dart';
import 'package:top_movies/utils/settings.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Settings.baseURL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static const _apikey = Settings.apikey;

  //HOME SCREEN
  @GET('/trending/movie/{time}?api_key=$_apikey')
  Future<ApiResponse> getTrendingMovies(@Path("time") String time);

  //Popular movies
  @GET('/movie/popular?api_key=$_apikey')
  Future<ApiResponse> getPopularMovies();

  //Popular movies next page
  @GET('/movie/popular?api_key=$_apikey&page={page}')
  Future<ApiResponse> getPopularMoviesNextPage(@Path("page") int page);

  //Get genres
  @GET('/genre/movie/list?api_key=$_apikey')
  Future<GenresApiResponse> getGenres();

  //DETAIL SCREEN
  //Get movie details
  @GET('/movie/{movie_id}?api_key=$_apikey')
  Future<MovieDetail> getMovieDetail(@Path("movie_id") int movieId);

  //Get movie images
  @GET('/movie/{movie_id}/images?api_key=$_apikey')
  Future<MovieImages> getMovieImages(@Path("movie_id") int movieId);
}
