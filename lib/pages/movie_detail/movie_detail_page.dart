import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:top_movies/data/hive.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_controller.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_repository.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/functions.dart';
import 'package:top_movies/utils/strings.dart';

class MovieDetailPage extends StatefulWidget {
  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  MovieDetailController controller = MovieDetailController(
    repository: MovieDetailRepository(),
  );

  @override
  void initState() {
    super.initState();
    controller.getMovieDetail(movieId: 0);
    controller.getMovieImages(movieId: 0);

    _openbox();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  _openbox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(FavoritesAdapter());
    Hive.registerAdapter(MoviesAdapter());
  }

  Future<void> _toggleFavorite(Movie movie) async {
    Movies movies = Movies();
    movies.id = movie.id;
    movies.title = movie.title;
    movies.voteAverage = movie.voteAverage;
    movies.originalTitle = movie.originalTitle;
    movies.popularity = movie.popularity;
    movies.voteCount = movie.voteCount;
    movies.posterPath = movie.posterPath;

    var box = await Hive.openBox('favoriteBox');
    await box.put('${movies.id}', movies);
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
            var random = new Random();
            var index = random.nextInt(
                controller.movieImagesResponse!.value!.backdrops!.length);
            return Image.network(
              getBackdrop(controller.movieImagesResponse!.value!.backdrops!
                  .elementAt(index)
                  .filePath!),
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

  Widget _showMovieTitle() {
    return Observer(
      builder: (_) {
        if (controller.movieDetailResponseIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.movieDetailResponseHasResults) {
          MovieDetail movieDetail = controller.movieDetailResponse!.value!;
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
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
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
            ],
          );
        } else if (controller.movieDetailResponseHasError) {
          return Center(
            child: Text("Erro"),
          );
        } else
          return Container();
      },
    );
  }

  Widget _showMovieOverview() {
    return Observer(
      builder: (_) {
        if (controller.movieDetailResponseIsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.movieDetailResponseHasResults) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Column(
              children: [
                Text(
                  Strings.overviewTitle,
                  style: new TextStyle(
                      color: ColorsConstants.textDefaultColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${controller.movieDetailResponse!.value!.overview!}",
                  style: new TextStyle(color: ColorsConstants.textDefaultColor),
                ),
              ],
            ),
          );
        } else if (controller.movieDetailResponseHasError) {
          return Center(
            child: Text("Erro"),
          );
        } else
          return Container();
      },
    );
  }

  //Detail Screen Widget
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
                    child: _showMovieTitle(),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              _showMovieOverview(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.star),
        onPressed: () {
          _toggleFavorite(movie);
        },
      ),
    );
  }
}
