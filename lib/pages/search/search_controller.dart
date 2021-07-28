import 'package:mobx/mobx.dart';
import 'package:top_movies/models/api_response.dart';
import 'package:top_movies/pages/search/search_repository.dart';

class SearchController with Store {
  final SearchRepository repository;

  SearchController({required this.repository});

  @observable
  ObservableFuture<ApiResponse>? searchResponse;

  @computed
  bool get searchResponseHasResults =>
      searchResponse != null &&
      searchResponse?.status == FutureStatus.fulfilled &&
      searchResponse?.result != null;

  @computed
  bool get searchResponseIsLoading =>
      searchResponse != null && searchResponse?.status == FutureStatus.pending;

  @computed
  bool get searchResponseHasError =>
      searchResponse != null && searchResponse?.status == FutureStatus.rejected;

  @action
  Future searchMovies(String query, int page) async {
    try {
      searchResponse = ObservableFuture(repository.searchMovies(query, page));
    } catch (error) {
      searchResponse = ObservableFuture.value(ApiResponse());
    }
  }
}
