import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:movie_api/model/movie.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/service/config/base_response.dart';
import 'package:movie_api/service/movie_service.dart';

class HomeBloc {
  MovieService _movieService;

  StreamController<BaseResponse<List<Results>>> _movieController;
  Stream<BaseResponse<List<Results>>> get movieStream =>
      _movieController.stream;
  Sink<BaseResponse<List<Results>>> get movieSink => _movieController.sink;

  HomeBloc() {
    _movieService = MovieService();
    _movieController = StreamController.broadcast();
  }

  getMovies() async {
    movieSink.add(BaseResponse.loading());
    try {
      var response = await _movieService.getMovies();
      movieSink.add(BaseResponse.completed(data: response));
      debugPrint("RECEBI O RESPONSE");
      print(response.first.toJson());
    } catch (e, stackTrace) {
      debugPrint("ERRO: " + e.toString());
      debugPrint("ERRO: " + stackTrace.toString());
      movieSink.add(BaseResponse.error(e.toString()));
    }
  }

  dispose() {
    _movieController.close();
  }
}
