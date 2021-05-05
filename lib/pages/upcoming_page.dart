import 'package:flutter/material.dart';
import 'package:movie_api/bloc/home_bloc.dart';
import 'package:movie_api/components/native_loading.dart';
import 'package:movie_api/model/movie.dart';
import 'package:movie_api/service/config/base_response.dart';
import 'package:movie_api/utils/helpers/manage_dialogs.dart';

class UpCommingPage extends StatefulWidget {
  @override
  _UpCommingPageState createState() => _UpCommingPageState();
}

class _UpCommingPageState extends State<UpCommingPage> {
  HomeBloc _bloc = HomeBloc();
  @override
  void initState() {
    super.initState();
    _bloc.getMovies();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141E26),
      // appBar: AppBar(
      //   backgroundColor: Color(0xff141E26),
      //   title: Text("Comming soon"),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Comming Soon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StreamBuilder<BaseResponse<List<Movie>>>(
                    stream: _bloc.movieStream,
                    initialData: BaseResponse.completed(),
                    builder: (context, snapshot) {
                      if (snapshot.data.data != null) {
                        switch (snapshot.data?.status) {
                          case Status.LOADING:
                            return _onLoading();
                            break;
                          case Status.ERROR:
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ManagerDialogs.showErrorDialog(
                                context,
                                snapshot.data.message,
                              );
                            });
                            return Container();
                            break;
                          default:
                            List<Movie> movies = snapshot.data.data;
                            return Column(
                              children: [
                                ///Imagem do primeiro filme da lista
                                ///Texto de todos os filmes
                                ///ListView.builder para construir a lista de filmes
                              ],
                            );
                        }
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            "DATA NOT FOUND",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Padding _onLoading() {
  return Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 30),
    child: NativeLoading(
      animating: true,
    ),
  );
}
