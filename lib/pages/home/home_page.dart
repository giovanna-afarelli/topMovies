import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_movies/models/genres.dart';
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
  int selectedGenreId = 0;
  int currentPage = 1;
  int maxPage = 1;

  HomeController controller = HomeController(
    repository: HomeRepository(),
  );

  @override
  void initState() {
    super.initState();
    controller.getMovies(page: 1, genreId: 0);
    controller.getGenres();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getNextPage() {
    currentPage++;
    if (currentPage < maxPage) {
      setState(() {
        controller.getMovies(page: currentPage, genreId: selectedGenreId);
      });
    }
  }

  void _getPreviousPage() {
    currentPage--;
    if (currentPage >= 1) {
      setState(() {
        controller.getMovies(page: currentPage, genreId: selectedGenreId);
      });
    }
  }

  Widget _createDropDownMenu() {
    return Observer(
      builder: (_) {
        if (controller.genresResponseIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.genresResponseHasResults) {
          return DropdownButton<int>(
              value: selectedGenreId,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 15,
              style: TextStyle(color: Colors.yellow, fontSize: 18),
              dropdownColor: Colors.black87,
              underline: Container(
                height: 2,
                color: Colors.blueGrey,
              ),
              onChanged: (int? data) {
                setState(() {
                  selectedGenreId = data!;
                  currentPage = 1;
                  controller.getMovies(
                      page: currentPage, genreId: selectedGenreId);
                });
              },
              items:
                  controller.genres.map<DropdownMenuItem<int>>((Genres genre) {
                return DropdownMenuItem<int>(
                  value: genre.id,
                  child: Text(genre.name!),
                );
              }).toList());
        } else if (controller.genresResponseHasError) {
          return Center(
            child: Text("Erro"),
          );
        } else
          return Container();
      },
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
          maxPage = controller.popularMoviesResponsePages;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.popularMoviesLength,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MovieItemWidget(
                movie: controller.popularMovies.elementAt(index),
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

  //Buttons to show page numbers
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
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Row(children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                    Strings.selectGenreTitle,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: ColorsConstants.textDefaultColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              _createDropDownMenu(),
            ]),
            _createMoviesList(),
          ],
        ),
      ),
      persistentFooterButtons: _createFooterButtons(),
    );
  }
}
