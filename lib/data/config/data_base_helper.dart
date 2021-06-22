import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:movie_api/model/results.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MovieDB.db";
  static final _databaseVersion = 1;
  static final table = 'movies';
  static final columnId = '_id';
  static final columnIdAPI = 'idAPI';
  static final columnTitle = 'title';
  static final columnOverview = 'overview';
  static final columnPosterPath = 'posterPath';
  static final columnVoteAvarage = 'voteAvarage';
  static final columnReleaseDate = 'releaseDate';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    print("Tabela criada");
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnIdAPI INTEGER NOT NULL UNIQUE,
            $columnTitle TEXT NOT NULL,
            $columnOverview TEXT NOT NULL,
            $columnPosterPath TEXT NOT NULL,
            $columnVoteAvarage DOUBLE NOT NULL,
            $columnReleaseDate TEXT NOT NULL
          )
          ''');
  }

  Future insert(Results movie) async {
    final db = await database;
    var id = await db.rawQuery(
        'INSERT INTO $table (idAPI, title, overview, posterPath, voteAvarage, releaseDate) VALUES ("${movie.id}", "${movie.title}", "${movie.overview.toString()}", "${movie.posterPath}", "${movie.voteAverage}", "${movie.releaseDate}")');

    print("MOVIE ID: " + id.toString());
  }

  Future<List<Results>> getMovies() async {
    final db = await database;
    var response = await db.rawQuery('SELECT * FROM $table');

    List<Results> movies = response
        .map(
          (e) => Results.fromBD(e),
        )
        .toList();
    return movies;
  }

  Future<int> update(Results movie) async {
    final db = await database;
    Map<String, dynamic> row = movie.toJson();
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future delete(Results movie) async {
    final db = await database;

    await db.rawQuery("DELETE FROM $table WHERE $columnIdAPI = ${movie.id}");
    print("object");
  }

  Future<dynamic> deleteDB() async {
    final db = await database;
    await db.delete(table);
  }

  Future<bool> checkDB(Results movie) async {
    final db = await database;
    var result = await db
        .rawQuery("SELECT * FROM $table WHERE $columnIdAPI = ${movie.id}");
    return result.isEmpty;
  }
}
