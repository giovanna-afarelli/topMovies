import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/models/movie_detail.dart';
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
    controller.getMovieDetail(movieId: 0);
    controller.getMovieImages(movieId: 0);
  }

  Widget _showMoviePoster(int movieId, String moviePoster) {
    return Container(
      height: 300,
      child: Hero(
        tag: movieId,
        child: Image.network(
          getImage(moviePoster),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _showMovieImage(int movieId, String moviePoster) {
    return Container(
      child: Observer(
        builder: (_) {
          if (controller.movieImagesResponseIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.movieImagesResponseHasResults) {
            return Image.network(
              getBackdrop(controller
                  .movieImagesResponse!.value!.backdrops!.first.filePath!),
              fit: BoxFit.fitWidth,
            );
          } else
            return Image.network(
              getImage(moviePoster),
              fit: BoxFit.fitWidth,
            );
        },
      ),
    );
  }

  Widget _showMovieDetails({required MovieDetail movieDetail}) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Text(
          "${movieDetail.title!} (${movieDetail.releaseDate})",
          style: new TextStyle(
            color: ColorsConstants.textDefaultColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "${movieDetail.tagline!}",
          style: new TextStyle(
            color: ColorsConstants.textDefaultColor,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Sinopse",
          style: new TextStyle(
              color: ColorsConstants.textDefaultColor,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "${movieDetail.overview!}",
          style: new TextStyle(color: ColorsConstants.textDefaultColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    setState(() {
      controller.getMovieDetail(movieId: movie.id!);
      controller.getMovieImages(movieId: movie.id!);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title.toString()),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _showMovieImage(movie.id!, movie.posterPath!),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  _showMoviePoster(movie.id!, movie.posterPath!),
                  Expanded(
                    child: Observer(
                      builder: (_) {
                        if (controller.movieDetailResponseIsLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (controller.movieDetailResponseHasResults) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: _showMovieDetails(
                                movieDetail:
                                    controller.movieDetailResponse!.value!),
                          );
                        } else if (controller.movieDetailResponseHasError) {
                          return Center(
                            child: Text("Erro"),
                          );
                        } else
                          return Container();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
