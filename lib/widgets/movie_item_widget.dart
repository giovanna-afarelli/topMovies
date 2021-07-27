import 'package:flutter/material.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/utils/app_routes.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/functions.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => _openMovieDetail(context, movie),
            child: Card(
              elevation: 5,
              child: Hero(
                tag: movie.id!,
                child: Image.network(
                  getImage(movie.posterPath!),
                  fit: BoxFit.cover,
                  scale: 1.0,
                  width: 110,
                  height: 160,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                movie.title.toString(),
                style: new TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsConstants.textDefaultColor),
              ),
              Text(
                movie.originalTitle.toString(),
                style: new TextStyle(color: ColorsConstants.textDefaultColor),
              ),
              Text(
                movie.popularity.toString(),
                style: new TextStyle(color: ColorsConstants.textDefaultColor),
              ),
              Text(
                movie.voteAverage.toString(),
                style: new TextStyle(color: ColorsConstants.textDefaultColor),
              ),
              Text(
                movie.voteCount.toString(),
                style: new TextStyle(color: ColorsConstants.textDefaultColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
