import 'package:mobx/mobx.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres_api_response.dart';
import 'package:top_movies/models/movie.dart';

import 'home_repository.dart';

class HomeController with Store {
  final HomeRepository repository;

  HomeController({required this.repository});

  @observable
  ObservableFuture<ApiResponse>? popularResponse;

  List<Movie> popularResponseByGenre = <Movie>[];

  @observable
  ObservableFuture<GenresApiResponse>? genresResponse;

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
