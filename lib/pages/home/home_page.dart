import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_movies/network/rest_client.dart';
import 'package:top_movies/pages/home/home_controller.dart';
import 'package:top_movies/pages/home/home_repository.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/widgets/dropdown_widget.dart';
import 'package:top_movies/widgets/movie_item_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedGenreId = 0;
  int currentPage = 1;
  ScrollController _scrollController = new ScrollController();

  HomeController controller = HomeController(
    repository: HomeRepository(
      restClient: RestClient(Dio()),
    ),
  );

  @override
  void initState() {
    super.initState();
    controller.getPopularMovies();
    controller.getGenres();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        currentPage = currentPage++;
        controller.getPopularMoviesNextPage(currentPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hit Movies",
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: Column(
        children: [
          controller.genresResponseHasResults
              ? DropDownWidget(
                  genresList: controller.genresResponse!.value!,
                  onChanged: (value) {
                    selectedGenreId = value;
                  },
                )
              : SizedBox(),
          RefreshIndicator(
            onRefresh: () {
              return Future(() {
                // Load the data again
                setState(() {
                  controller.getPopularMovies();
                });
              });
            },
            child: Column(
              children: [
                Observer(
                  builder: (_) {
                    if (controller.popularResponseIsLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.popularResponseHasResults) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: AspectRatio(
                          aspectRatio: 16 / 8,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller
                                .popularResponse!.value!.results!.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return MovieItemWidget(
                                movie: controller
                                    .popularResponse!.value!.results!
                                    .elementAt(index),
                              );
                            },
                            controller: _scrollController,
                          ),
                        ),
                      );
                      ;
                    }

                    if (controller.popularResponseHasError) {
                      return Center(
                        child: Text("Erro"),
                      );
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
