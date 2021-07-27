import 'package:flutter/material.dart';
import 'package:top_movies/pages/home/home_page.dart';
import 'package:top_movies/pages/movie_detail/movie_detail_page.dart';
import 'package:top_movies/utils/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Movies',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
      ),
      home: HomePage(),
      routes: {
        AppRoutes.MOVIEDETAIL: (ctx) => MovieDetailPage(),
      },
    );
  }
}
