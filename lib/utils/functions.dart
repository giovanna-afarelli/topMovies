import 'package:top_movies/utils/settings.dart';

String getImage(String imageName) {
  return Settings.imageURL + "$imageName";
}

String getBackdrop(String imageName) {
  return Settings.backdropURL + "$imageName";
}
