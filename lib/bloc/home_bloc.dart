import 'dart:async';

import 'package:movie_api/model/movie.dart';
import 'package:movie_api/service/config/api_service.dart';
import 'package:movie_api/service/config/base_response.dart';
import 'package:movie_api/service/movie_service.dart';

class HomeBloc {
  MovieService _movieService;

  StreamController<BaseResponse<List<Movie>>> _movieController;
  Stream<BaseResponse<List<Movie>>> get movieStream => _movieController.stream;
  Sink<BaseResponse<List<Movie>>> get movieSink => _movieController.sink;

  HomeBloc() {
    _movieService = MovieService(APIService());
    _movieController = StreamController();
  }

  getMovies() async {
    try {
      movieSink.add(BaseResponse.loading());
      var response = await _movieService.getMovies();
      movieSink.add(BaseResponse.completed(data: response));
    } catch (e) {
      movieSink.add(BaseResponse.error(e.toString()));
    }
  }

  dispose() {
    _movieController.close();
  }
}
