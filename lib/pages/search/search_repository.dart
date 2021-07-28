import 'package:dio/dio.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/network/rest_client.dart';

class SearchRepository {
  final RestClient restClient = RestClient(Dio());

  SearchRepository();

  Future<ApiResponse> searchMovies(String query, int page) async {
    return restClient.searchMovies(query, page);
  }
}
