import 'package:mobx/mobx.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/genres.dart';
import 'package:top_movies/models/genres_api_response.dart';

import 'home_repository.dart';

class HomeController with Store {
  final HomeRepository repository;

  HomeController({required this.repository});

  @observable
  ObservableFuture<ApiResponse>? trendingResponse;

  @observable
  ObservableFuture<ApiResponse>? popularResponse;

  @observable
  ObservableFuture<GenresApiResponse>? genresResponse;

  @computed
  bool get trendingResponseHasResults =>
      trendingResponse != null &&
      trendingResponse?.status == FutureStatus.fulfilled &&
      trendingResponse?.result != null;

  @computed
  bool get trendingResponseIsLoading =>
      trendingResponse != null &&
      trendingResponse?.status == FutureStatus.pending;

  @computed
  bool get trendingResponseHasError =>
      trendingResponse != null &&
      trendingResponse?.status == FutureStatus.rejected;

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
  Future getTrendingMovies(String time) async {
    try {
      trendingResponse = ObservableFuture(repository.getTrendingMovies(time));
    } catch (error) {
      trendingResponse = ObservableFuture.value(ApiResponse());
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
