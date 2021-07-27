import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_movies/data/hive.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/strings.dart';
import 'package:top_movies/widgets/movie_item_widget.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    _openBox();
  }

  _openBox() async {
    var box = await Hive.openBox('favoriteBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Strings.favoritesTitle,
        ),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: FutureBuilder(
        future: Hive.openBox('favoriteBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return WatchBoxBuilder(
                box: Hive.box('favoriteBox'),
                builder: (context, favoriteBox) {
                  return ListView.builder(
                    itemCount: favoriteBox.length,
                    itemBuilder: (BuildContext context, int index) {
                      final favorite = favoriteBox.getAt(index) as Movies;
                      final movie = Movie();

                      movie.id = favorite.id;
                      movie.title = favorite.title;
                      movie.voteAverage = favorite.voteAverage;
                      movie.originalTitle = favorite.originalTitle;
                      movie.popularity = favorite.popularity;
                      movie.voteCount = favorite.voteCount;
                      movie.posterPath = favorite.posterPath;

                      return MovieItemWidget(movie: movie);
                    },
                  );
                },
              );
          } else
            return Scaffold();
        },
      ),
    );
  }
}
