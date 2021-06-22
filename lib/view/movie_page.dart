import 'package:flutter/material.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/utils/constants.dart';
import 'package:movie_api/utils/helpers/helpers.dart';
import 'package:movie_api/viewmodel/movie_view_model.dart';

class MoviePage extends StatefulWidget {
  final Results movie;
  const MoviePage({Key key, this.movie}) : super(key: key);
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  MovieViewModel _movieViewModel = MovieViewModel();

  @override
  void initState() {
    super.initState();
    _movieViewModel.check(movie: widget.movie);
    favsListen();
  }

  favsListen() {
    _movieViewModel.favsStream.listen((event) async {
      await _movieViewModel.check(movie: widget.movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141E26),
      appBar: AppBar(
        backgroundColor: Color(0xff141E26),
        title: Text(widget.movie.title),
      ),
      floatingActionButton: StreamBuilder(
        initialData: false,
        stream: _movieViewModel.favsStream,
        builder: (context, snapshot) {
          return FloatingActionButton(
            child: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            backgroundColor: (snapshot != null)
                ? snapshot.data
                    ? Color(0xff424E59)
                    : Colors.red
                : Color(0xff424E59),
            onPressed: () async {
              await _movieViewModel.check(movie: widget.movie);
              if (snapshot.data == true) {
                await _movieViewModel.save(movie: widget.movie);
              } else {
                await _movieViewModel.delete(movie: widget.movie);
              }
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                child: Hero(
                  tag: widget.movie.id,
                  child: Image.network(
                    Constants.kBaseUrlImage + widget.movie?.backdropPath,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Overview",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color(0xffF2B705),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "${widget.movie.voteAverage}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xff424E59),
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    Helpers.formatterDateFromAPI(
                                        "${widget.movie.releaseDate}"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xff424E59),
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.movie.overview,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
