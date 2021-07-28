import 'package:mobx/mobx.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/backdrops.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/models/movie_images.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_repository.dart';

class MovieDetailController with Store {
  final MovieDetailRepository repository;

  MovieDetailController({required this.repository});

  @observable
  ObservableFuture<MovieDetail>? movieDetailResponse;

  @observable
  ObservableFuture<MovieImages>? movieImagesResponse;

  @observable
  ObservableFuture<ApiResponse>? movieRecommendationsResponse;

  @computed
  bool get movieDetailResponseHasResults =>
      movieDetailResponse != null &&
      movieDetailResponse?.status == FutureStatus.fulfilled &&
      movieDetailResponse?.result != null;

  @computed
  bool get movieDetailResponseIsLoading =>
      movieDetailResponse != null &&
      movieDetailResponse?.status == FutureStatus.pending;

  @computed
  bool get movieDetailResponseHasError =>
      movieDetailResponse != null &&
      movieDetailResponse?.status == FutureStatus.rejected;

  @computed
  bool get movieImagesResponseHasResults =>
      movieImagesResponse != null &&
      movieImagesResponse?.status == FutureStatus.fulfilled &&
      movieImagesResponse?.result != null;

  @computed
  bool get movieImagesResponseIsLoading =>
      movieImagesResponse != null &&
      movieImagesResponse?.status == FutureStatus.pending;

  @computed
  bool get movieImagesResponseHasError =>
      movieImagesResponse != null &&
      movieImagesResponse?.status == FutureStatus.rejected;

  @computed
  bool get movieRecommendationsResponseHasResults =>
      movieRecommendationsResponse != null &&
      movieRecommendationsResponse?.status == FutureStatus.fulfilled &&
      movieRecommendationsResponse?.result != null;

  @computed
  bool get movieRecommendationsResponseIsLoading =>
      movieRecommendationsResponse != null &&
      movieRecommendationsResponse?.status == FutureStatus.pending;

  @computed
  bool get movieRecommendationsResponseHasError =>
      movieRecommendationsResponse != null &&
      movieRecommendationsResponse?.status == FutureStatus.rejected;

  //Movie images list
  @computed
  List<Backdrops> get moviesBackdrops => movieImagesResponse!.value!.backdrops!;
  @computed
  bool get moviesBackdropsIsNotEmpty => moviesBackdrops.isNotEmpty;
  @computed
  int get moviesBackdropsLenght => moviesBackdrops.length;

  //Movies details
  @computed
  MovieDetail get movieDetail => movieDetailResponse!.value!;

  //Movie recommendations
  @computed
  List<Movie> get movieRecommendations =>
      movieRecommendationsResponse!.value!.results!;
  @computed
  bool get movieRecommendationsIsNotEmpty => movieRecommendations.isNotEmpty;
  @computed
  int get movieRecommendationsLenght => movieRecommendations.length;

  @action
  Future getMovieDetail({required int movieId}) async {
    try {
      movieDetailResponse =
          ObservableFuture(repository.getMovieDetail(movieId));
    } catch (error) {
      movieDetailResponse = ObservableFuture.value(MovieDetail());
    }
  }

  @action
  Future getMovieImages({required int movieId}) async {
    try {
      movieImagesResponse =
          ObservableFuture(repository.getMovieImages(movieId));
    } catch (error) {
      movieImagesResponse = ObservableFuture.value(MovieImages());
    }
  }

  @action
  Future getMovieRecommendations(
      {required int movieId, required int page}) async {
    try {
      movieRecommendationsResponse =
          ObservableFuture(repository.getMovieRecommendations(movieId, page));
    } catch (error) {
      movieRecommendationsResponse = ObservableFuture.value(ApiResponse());
    }
  }
}
