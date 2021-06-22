import 'package:movie_api/data/config/data_base_helper.dart';
import 'package:movie_api/model/results.dart';

class LocalService {
  final db = DatabaseHelper.instance;

  Future add({Results movie}) async {
    await db.insert(movie);
  }

  Future delete({Results movie}) async {
    await db.delete(movie);
  }

  Future<bool> check({Results movie}) async {
    return await db.checkDB(movie);
  }

  Future<List<Results>> getAll() async {
    final List<Results> _movies = await db.getMovies();

    return _movies;
  }
}
