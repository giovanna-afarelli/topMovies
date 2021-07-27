import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_movies/models/genres.dart';
import 'package:top_movies/network/rest_client.dart';
import 'package:top_movies/pages/home/home_controller.dart';
import 'package:top_movies/pages/home/home_repository.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/strings.dart';
import 'package:top_movies/widgets/movie_item_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedGenreId = 28;
  int currentPage = 1;
  ScrollController _scrollController = new ScrollController();

  HomeController controller = HomeController(
    repository: HomeRepository(),
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

  Widget _createDropDownMenu() {
    return controller.genresResponseHasResults
        ? DropdownButton<int>(
            value: selectedGenreId,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 15,
            style: TextStyle(color: Colors.red, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.amber,
            ),
            onChanged: (int? data) {
              setState(() {
                selectedGenreId = data!;
                controller.getPopularMoviesbyGenre(selectedGenreId);
              });
            },
            items: controller.genresResponse!.value!.genres!
                .map<DropdownMenuItem<int>>((Genres genre) {
              return DropdownMenuItem<int>(
                value: genre.id,
                child: Text(genre.name!),
              );
            }).toList())
        : SizedBox(
            height: 0,
          );
  }

  Widget _createMoviesList() {
    return Observer(
      builder: (_) {
        if (controller.popularResponseIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.popularResponseHasResults) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.popularResponse!.value!.results!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return MovieItemWidget(
                movie: controller.popularResponse!.value!.results!
                    .elementAt(index),
              );
            },
            controller: _scrollController,
          );
        } else if (controller.popularResponseHasError) {
          return Center(
            child: Text("Erro"),
          );
        } else
          return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.homePageTitle,
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            _createDropDownMenu(),
            _createMoviesList(),
          ],
        ),
      ),
    );
  }
}
