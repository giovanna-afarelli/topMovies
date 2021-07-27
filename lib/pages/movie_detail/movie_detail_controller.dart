import 'package:mobx/mobx.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_repository.dart';

class MovieDetailController with Store {
  final MovieDetailRepository repository;

  MovieDetailController({required this.repository});

  @observable
  ObservableFuture<Movie>? movieDetailResponse;

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

  @action
  Future getMovieDetail(int movieId) async {
    try {
      movieDetailResponse =
          ObservableFuture(repository.getMovieDetail(movieId));
    } catch (error) {
      movieDetailResponse = ObservableFuture.value(Movie());
    }
  }
}
