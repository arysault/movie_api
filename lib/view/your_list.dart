import 'package:flutter/material.dart';
import 'package:movie_api/components/fav_movie.dart';
import 'package:movie_api/components/native_loading.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/service/config/base_response.dart';
import 'package:movie_api/utils/constants.dart';
import 'package:movie_api/utils/helpers/manage_dialogs.dart';
import 'package:movie_api/view/upcoming_page.dart';
import 'package:movie_api/viewmodel/movie_view_model.dart';

class YourList extends StatefulWidget {
  const YourList({Key key}) : super(key: key);

  @override
  _YourListState createState() => _YourListState();
}

class _YourListState extends State<YourList> {
  MovieViewModel _viewModel = MovieViewModel();
  //String poster = "/xbSuFiJbbBWCkyCCKIMfuDCA4yV.jpg";
  @override
  void initState() {
    super.initState();
    _viewModel.getAll();
  }

  favsListen(movie) {
    _viewModel.favsStream.listen((event) async {
      await _viewModel.check(movie: movie);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141E26),
      appBar: AppBar(
        title: Text("Your List"),
        backgroundColor: Color(0xff141E26),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff141E26),
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(
                  "ASS MAX",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return UpCommingPage();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: Text(
                  "Your List",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: StreamBuilder<BaseResponse<List<Results>>>(
            stream: _viewModel.moviesStream,
            initialData: BaseResponse.completed(),
            builder: (context, snapshot) {
              if (snapshot.data.data != null) {
                switch (snapshot.data?.status) {
                  case Status.LOADING:
                    return _onLoading();
                    break;
                  case Status.ERROR:
                    onError(snapshot);
                    return Container();
                    break;
                  default:
                    _viewModel.yourList.clear();
                    if (snapshot.data.data != null) {
                      snapshot.data.data.forEach((movie) {
                        _viewModel.yourList.add(
                          FavMovie(
                            movie: movie,
                            onPressed: () async {
                              movie.id = movie.idAPI;
                              await _viewModel.delete(movie: movie);
                              favsListen(movie);
                              print(movie.toJson());
                            },
                          ),
                        );
                      });
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _viewModel.yourList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: _viewModel.yourList[index],
                        );
                      },
                    );
                }
              } else {
                return Text(
                  "LISTA BUGADA",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Padding _onLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: NativeLoading(animating: true),
    );
  }

  Widget onError(AsyncSnapshot snapshot) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ManagerDialogs.showErrorDialog(
        context,
        snapshot.data.message,
      );
    });
  }
}
