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
  int maxPage = 1;

  HomeController controller = HomeController(
    repository: HomeRepository(),
  );

  @override
  void initState() {
    super.initState();
    controller.getPopularMovies();
    controller.getGenres();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getNextPage() {
    currentPage++;
    print(currentPage);
    if (currentPage < maxPage) {
      setState(() {
        controller.getPopularMoviesNextPage(currentPage);
      });
    }
  }

  void _getPreviousPage() {
    currentPage--;
    print(currentPage);
    if (currentPage >= 1) {
      setState(() {
        controller.getPopularMoviesNextPage(currentPage);
      });
    }
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
          maxPage = controller.popularResponse!.value!.totalPages!;
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

  List<Widget> _createFooterButtons() {
    if (currentPage > 1 && currentPage < maxPage) {
      return <Widget>[
        ElevatedButton.icon(
          onPressed: _getPreviousPage,
          icon: Icon(Icons.arrow_back),
          label: Text("${currentPage - 1}"),
        ),
        ElevatedButton.icon(
          onPressed: _getNextPage,
          icon: Icon(Icons.arrow_forward),
          label: Text("${currentPage + 1}"),
        ),
      ];
    } else if (currentPage == 1) {
      return <Widget>[
        ElevatedButton.icon(
          onPressed: _getNextPage,
          icon: Icon(Icons.arrow_forward),
          label: Text("${currentPage + 1}"),
        ),
      ];
    } else {
      return <Widget>[
        ElevatedButton.icon(
          onPressed: _getPreviousPage,
          icon: Icon(Icons.arrow_back),
          label: Text("${currentPage - 1}"),
        ),
      ];
    }
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
      persistentFooterButtons: _createFooterButtons(),
    );
  }
}
