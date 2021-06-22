import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:movie_api/model/movie_id.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/service/config/custom_dio.dart';
import 'package:movie_api/utils/constants.dart';

class MovieService {
  final CustomDio _dio = CustomDio();

  String _getUpComming = "3/movie/upcoming";
  String _getMovieById = "3/movie/";

  Future<Results> getMovieById(int movieId) async {
    String finalUrl = Constants.kBaseUrl + _getMovieById + "$movieId";

    Response response =
        await _dio.get(finalUrl, queryParameters: Constants.kParameters);
    print("etste");

    MovieID _result = MovieID.fromJson(response.data);
    print("_RESPONSE");
    print(_result.toJson());
    return _result.toResults();
  }

  Future<List<Results>> getMovies() async {
    String finalUrl = Constants.kBaseUrl + _getUpComming;

    Response response =
        await _dio.get(finalUrl, queryParameters: Constants.kParameters);

    var _results = (response.data["results"] as List)
        .map((e) => Results.fromJson(e))
        .toList();

    return _results;
  }
}

class MovieId {}
