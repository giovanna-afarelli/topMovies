import 'package:mobx/mobx.dart';
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
}
