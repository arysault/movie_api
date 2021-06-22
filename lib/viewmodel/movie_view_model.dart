import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:movie_api/data/local_service.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/service/config/base_response.dart';
import 'package:movie_api/service/movie_service.dart';

class MovieViewModel {
  MovieService movieService;
  LocalService service;
  List<Widget> yourList = [];
  StreamController<bool> _favsController;
  Stream<bool> get favsStream => _favsController.stream;
  Sink<bool> get favsSink => _favsController.sink;
  StreamController<BaseResponse<List<Results>>> _moviesController;
  Stream<BaseResponse<List<Results>>> get moviesStream =>
      _moviesController.stream;
  Sink<BaseResponse<List<Results>>> get moviesSink => _moviesController.sink;
  StreamController<BaseResponse<Results>> _movieController;
  Stream<BaseResponse<Results>> get movieStream => _movieController.stream;
  Sink<BaseResponse<Results>> get movieSink => _movieController.sink;

  MovieViewModel() {
    movieService = MovieService();
    service = LocalService();
    _favsController = StreamController.broadcast();
    _moviesController = StreamController.broadcast();
  }

  Future save({Results movie}) async {
    await service.add(movie: movie);
  }

  Future delete({Results movie}) async {
    await service.delete(movie: movie);
  }

  Future check({Results movie}) async {
    try {
      bool results = await service.check(movie: movie);
      favsSink.add(results);
    } catch (e) {
      favsSink.add(false);
    }
  }

  Future getAll() async {
    try {
      moviesSink.add(BaseResponse.loading());
      List<Results> movies = await service.getAll();
      moviesSink.add(BaseResponse.completed(data: movies));
    } catch (e) {
      moviesSink.add(BaseResponse.error(e.toString()));
    }
  }

  Future<Results> getById(int id) async {
    Results movie;
    try {
      movie = await movieService.getMovieById(id);
    } catch (e) {
      print(e);
    }
    return movie;
  }
}
