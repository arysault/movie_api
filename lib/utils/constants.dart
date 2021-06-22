import 'package:dio/dio.dart';

class Constants {
  static String kBaseUrl = "https://api.themoviedb.org/";
  static String kBaseUrlImage = "https://image.tmdb.org/t/p/w500/";

  static String kApiKey = "a5bc05fb630c9b7fdc560033345fa13e";

  static Options kOptions = Options(
    headers: {
      // "X-RapidAPI-Host": "love-calculator.p.rapidapi.com"
    },
  );
  static var kParameters = {
    "api_key": "a5bc05fb630c9b7fdc560033345fa13e",
    "language": "en-US",
    "page": 1
  };
}
