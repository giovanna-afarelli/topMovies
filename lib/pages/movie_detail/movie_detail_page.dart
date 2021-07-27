import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/network/rest_client.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_controller.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_repository.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/functions.dart';

class MovieDetailPage extends StatefulWidget {
  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieDetailController controller = MovieDetailController(
    repository: MovieDetailRepository(
      restClient: RestClient(Dio()),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  Widget _showMoviePoster(int movieId, String moviePoster) {
    //Book cover image
    return Container(
      height: 300,
      width: double.infinity,
      child: Hero(
        tag: movieId,
        child: Image.network(
          getImage(moviePoster),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title.toString()),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              movie.title.toString(),
              style: new TextStyle(color: ColorsConstants.textDefaultColor),
            ),
            _showMoviePoster(movie.id!, movie.posterPath!)
          ],
        ),
      ),
    );
  }
}
