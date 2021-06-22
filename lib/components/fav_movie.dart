import 'package:flutter/material.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/utils/constants.dart';
import 'package:movie_api/view/movie_page.dart';
import 'package:movie_api/viewmodel/movie_view_model.dart';

class FavMovie extends StatelessWidget {
  const FavMovie({
    Key key,
    @required this.onPressed,
    this.movie,
  }) : super(key: key);

  final Results movie;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            MovieViewModel movieViewModel = MovieViewModel();
            Results movieAPI = await movieViewModel.getById(movie.idAPI);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MoviePage(
                  movie: movieAPI,
                );
              },
            ));
          },
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(
                  Constants.kBaseUrlImage + movie.posterPath,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
