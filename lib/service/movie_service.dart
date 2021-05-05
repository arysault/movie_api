import 'package:flutter/material.dart';
import 'package:movie_api/model/movie.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/utils/constants.dart';

import 'config/api_service.dart';

class MovieService {
  final APIService _service;

  String _getUpComming = "3/movie/upcoming";

  MovieService(this._service);

  Future<List<Movie>> getMovies() async {
    List<Movie> movies;
    String finalUrl = Constants.kBaseUrl + _getUpComming;
    final response = await _service.doRequest(
        RequestConfig(finalUrl, HttpMethod.get), Constants.kParameters);
    var _results = Movie.fromJson(response);

    movies = (_results as List).map((e) => Movie.fromJson(e)).toList();

    return movies;
  }
}
