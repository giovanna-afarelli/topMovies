import 'package:flutter/material.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/utils/app_routes.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/functions.dart';
import 'package:top_movies/utils/strings.dart';

class MovieItemWidget extends StatelessWidget {
  final Movie movie;

  MovieItemWidget({
    required this.movie,
  });

  void _openMovieDetail(BuildContext context, Movie movie) {
    Navigator.of(context).pushNamed(
      AppRoutes.MOVIEDETAIL,
      arguments: movie,
    );
  }

  Widget _createMovieImage() {
    var img = "";
    if (movie.posterPath != null) {
      img = movie.posterPath!;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shadowColor: ColorsConstants.shadowColor,
        clipBehavior: Clip.hardEdge,
        child: img.isNotEmpty
            ? Hero(
                tag: movie.id!,
                child: Image.network(
                  getImage(img),
                  fit: BoxFit.cover,
                  scale: 1.0,
                  width: 110,
                  height: 160,
                ),
              )
            : SizedBox(
                height: 160,
                width: 110,
                child: Center(child: Text(Strings.noImageText)),
              ),
      ),
    );
  }

  Widget _createMovieInfo() {
    return Expanded(
      child: Column(
        children: [
          Text(
            movie.title.toString(),
            style: new TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorsConstants.textDefaultColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${Strings.originalTitle}: ${movie.originalTitle.toString()}",
            style: new TextStyle(color: ColorsConstants.textDefaultColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${Strings.popularityRanking}: ${movie.popularity!.toStringAsFixed(0)}",
            style: new TextStyle(color: ColorsConstants.textDefaultColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${Strings.voteAverage}: ${movie.voteAverage}",
            style: new TextStyle(color: ColorsConstants.textDefaultColor),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "${Strings.voteCount}: ${movie.voteCount}",
            style: new TextStyle(color: ColorsConstants.textDefaultColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openMovieDetail(context, movie),
      child: Row(
        children: [
          _createMovieImage(),
          _createMovieInfo(),
        ],
      ),
    );
  }
}
