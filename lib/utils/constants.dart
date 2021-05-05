import 'package:dio/dio.dart';

class Constants {
  static String kBaseUrl = "https://api.themoviedb.org/";

  static String kApiKey = "ef3b08dbba9437a765af7d71fd8f51c1";

  static Options kOptions = Options(
    headers: {
      // "X-RapidAPI-Host": "love-calculator.p.rapidapi.com"
    },
  );
  static var kParameters = {
    "api_key": "ef3b08dbba9437a765af7d71fd8f51c1",
    "language": "en-US",
    "page": 1
  };
}
