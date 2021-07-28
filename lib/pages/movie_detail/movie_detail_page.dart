import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:top_movies/models/movie.dart';
import 'package:top_movies/models/movie_detail.dart';
import 'package:top_movies/models/video_model.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_controller.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_repository.dart';
import 'package:top_movies/utils/app_routes.dart';
import 'package:top_movies/utils/colors.dart';
import 'package:top_movies/utils/functions.dart';
import 'package:top_movies/utils/strings.dart';
import 'package:top_movies/widgets/movie_item_widget.dart';

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
    controller.getMovieRecommendations(movieId: 0, page: 1);
    controller.getMovieVideos(movieId: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Loads the movie poster
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

  //Loads ramdom image (backdrop) from the movie
  Widget _showMovieImage(int movieId, String moviePoster) {
    return Container(
      child: Observer(
        builder: (_) {
          if (controller.movieImagesResponseIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.movieImagesResponseHasResults) {
            if (controller.moviesBackdropsIsNotEmpty) {
              var random = new Random();
              var max = controller.moviesBackdropsLenght - 1;
              if (max < 1) {
                max = 1;
              } else if (max > 1000) {
                max = 1000;
              }
              var index = random.nextInt(max);
              return Image.network(
                getBackdrop(
                    controller.moviesBackdrops.elementAt(index).filePath!),
                fit: BoxFit.fitWidth,
              );
            } else {
              return Container();
            }
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
          MovieDetail movieDetail = controller.movieDetail;
          String formattedDate = "";

          var date = DateTime.parse(movieDetail.releaseDate.toString());
          formattedDate = "${date.day}/${date.month}/${date.year}";

          return Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                "${movieDetail.title!} ($formattedDate)",
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${controller.movieDetail.overview!}",
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

  Widget _showMovieRecommendations() {
    return Container(
      height: 200,
      child: Observer(
        builder: (_) {
          if (controller.movieRecommendationsResponseIsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.movieRecommendationsResponseHasResults) {
            return controller.movieRecommendationsIsNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.movieRecommendationsLenght,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return MovieItemWidget(
                        movie: controller.movieRecommendations.elementAt(index),
                        showOnlyImage: true,
                      );
                    },
                  )
                : Container(
                    //If the collection is empty, show Empty message
                    alignment: Alignment.center,
                    height: 120,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      Strings.recommendationsEmpty,
                      style: TextStyle(color: ColorsConstants.textDefaultColor),
                    ),
                  );
          } else if (controller.movieRecommendationsResponseHasError) {
            return Center(
              child: Text(
                "Erro",
                style: TextStyle(color: ColorsConstants.textDefaultColor),
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }

  Widget _showVideoThumb() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        height: 150,
        width: double.infinity,
        child: Observer(
          builder: (_) {
            if (controller.movieVideosResponseIsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.movieVideosResponseHasResults) {
              return InkWell(
                onTap: () => _openVideo(context, controller.movieVideos.first),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      "https://img.youtube.com/vi/${controller.movieVideos.first.key}/0.jpg",
                      fit: BoxFit.fitHeight,
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      colorBlendMode: BlendMode.modulate,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      child: Image(
                        image: AssetImage('lib/images/play.png'),
                      ),
                    ),
                  ],
                ),
              );
            } else if (controller.movieVideosResponseHasError) {
              return Center(
                child: Text("Erro"),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, Videos video) {
    Navigator.of(context).pushNamed(
      AppRoutes.VIDEOPLAYER,
      arguments: video,
    );
  }

  Widget _space() {
    return SizedBox(
      height: 10.0,
    );
  }

  //Detail Screen Widget
  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    setState(() {
      controller.getMovieDetail(movieId: movie.id!);
      controller.getMovieImages(movieId: movie.id!);
      controller.getMovieRecommendations(movieId: movie.id!, page: 1);
      controller.getMovieVideos(movieId: movie.id!);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title.toString()),
      ),
      backgroundColor: ColorsConstants.backgroundColor,
      body: ListView(
        children: [
          _showMovieImage(movie.id!, movie.posterPath!),
          _space(),
          Row(
            children: [
              _showMoviePoster(movie.id!, movie.posterPath!),
              Expanded(
                child: _showMovieTitle(),
              ),
            ],
          ),
          _space(),
          _showMovieOverview(),
          _space(),
          _showVideoThumb(),
          _space(),
          Text(
            Strings.recommendationsTitle,
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: ColorsConstants.textDefaultColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          _space(),
          _showMovieRecommendations(),
        ],
      ),
    );
  }
}
