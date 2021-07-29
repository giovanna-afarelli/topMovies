import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres.dart';
import 'package:top_movies/models/genres_api_response.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/network/repository.dart';

class HomeController with Store {
  final Repository repository = Repository();

  HomeController();

  @observable
  ObservableFuture<ApiResponse>? popularResponse;

  List<Movie> popularResponseByGenre = <Movie>[];

  @observable
  ObservableFuture<GenresApiResponse>? genresResponse;

  //Check API reponse
  @computed
  bool get popularResponseHasResults =>
      popularResponse != null &&
      popularResponse?.status == FutureStatus.fulfilled &&
      popularResponse?.result != null;

  @computed
  bool get popularResponseIsLoading =>
      popularResponse != null &&
      popularResponse?.status == FutureStatus.pending;

  @computed
  bool get popularResponseHasError =>
      popularResponse != null &&
      popularResponse?.status == FutureStatus.rejected;

  //Get the api response error for getPopularMovies
  @computed
  String get popularResponseError {
    var errorMessage = " ";
    if (popularResponseHasError) {
      String error = ((popularResponse!.error) as DioError).response.toString();

      try {
        var decodedJson = json.decode(error);
        errorMessage = decodedJson["status_message"];
      } catch (e) {
        errorMessage = " ";
      }
    }
    return errorMessage;
  }

  @computed
  bool get genresResponseHasResults =>
      genresResponse != null &&
      genresResponse?.status == FutureStatus.fulfilled &&
      genresResponse?.result != null;

  @computed
  bool get genresResponseIsLoading =>
      genresResponse != null && genresResponse?.status == FutureStatus.pending;

  @computed
  bool get genresResponseHasError =>
      genresResponse != null && genresResponse?.status == FutureStatus.rejected;

  //Genre results
  @computed
  List<Genres> get genres {
    List<Genres> genres = genresResponse!.value!.genres!;
    var genreSelectAll = Genres();
    genreSelectAll.id = 0;
    genreSelectAll.name = "All";
    if (genres.first.id != 0) {
      genres.insert(0, genreSelectAll);
    }
    return genres;
  }

  //Popular movies results
  List<Movie> get popularMovies => popularResponse!.value!.results!;
  int get popularMoviesResponsePages => popularResponse!.value!.totalPages!;
  int get popularMoviesLength => popularResponse!.value!.results!.length;

  @action
  Future getMovies({required int page, required int genreId}) async {
    if (genreId == 0) {
      if (page <= 1) {
        getPopularMovies();
      } else {
        getPopularMoviesNextPage(page);
      }
    } else {
      getPopularMoviesbyGenre(genreId, page);
    }
  }

  @action
  Future getPopularMovies() async {
    try {
      popularResponse = ObservableFuture(repository.getPopularMovies());
    } catch (error) {
      popularResponse = ObservableFuture.value(ApiResponse());
    }
  }

  @action
  Future getPopularMoviesbyGenre(int genreId, int page) async {
    try {
      popularResponse = ObservableFuture(repository.getPopularMoviesByGenre(
          "popularity.desc", page, 10, genreId.toString()));
    } catch (error) {
      popularResponse = ObservableFuture.value(ApiResponse());
    }
  }

  @action
  Future getPopularMoviesNextPage(int page) async {
    try {
      popularResponse =
          ObservableFuture(repository.getPopularMoviesNextPage(page));
    } catch (error) {
      popularResponse = ObservableFuture.value(ApiResponse());
    }
  }

  @action
  Future getGenres() async {
    try {
      genresResponse = ObservableFuture(repository.getGenres());
    } catch (error) {
      genresResponse = ObservableFuture.value(GenresApiResponse());
    }
  }
}
