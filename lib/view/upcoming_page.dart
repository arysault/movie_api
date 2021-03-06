import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_api/components/native_loading.dart';
import 'package:movie_api/model/results.dart';
import 'package:movie_api/service/config/base_response.dart';
import 'package:movie_api/utils/constants.dart';
import 'package:movie_api/utils/helpers/helpers.dart';
import 'package:movie_api/utils/helpers/manage_dialogs.dart';
import 'package:movie_api/view/your_list.dart';
import 'package:movie_api/viewmodel/home_view_model.dart';
import 'package:page_indicator/page_indicator.dart';

import 'movie_page.dart';

class UpCommingPage extends StatefulWidget {
  @override
  _UpCommingPageState createState() => _UpCommingPageState();
}

class _UpCommingPageState extends State<UpCommingPage> {
  HomeViewModel _viewModel = HomeViewModel();
  PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _viewModel.getMovies();
    trendingsLoop();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  trendingsLoop() async {
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff141E26),
      appBar: AppBar(
        title: Text("Home"),
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
                  "PIRATA MAX",
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
                  Navigator.pop(context);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return YourList();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Trendings",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                StreamBuilder<BaseResponse<List<Results>>>(
                  stream: _viewModel.movieStream,
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
                          List<Results> movies = snapshot.data.data;
                          print(movies.first.toJson());
                          return Column(
                            children: [
                              Container(
                                height: 220,
                                child: PageIndicatorContainer(
                                  align: IndicatorAlign.bottom,
                                  indicatorSpace: 8.0,
                                  padding: EdgeInsets.all(5.0),
                                  indicatorColor: Colors.white,
                                  indicatorSelectorColor: Color(0xff141E26),
                                  length: 5,
                                  child: PageView.builder(
                                    controller: _controller,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: movies.take(5).length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MoviePage(
                                                movie: movies[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                              ),
                                              child: Hero(
                                                tag: movies[index].id + 1,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 220,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      image: DecorationImage(
                                                          image: NetworkImage(Constants
                                                                  .kBaseUrlImage +
                                                              movies[index]
                                                                  ?.backdropPath),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 220,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0.9),
                                                      Colors.transparent
                                                    ]),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                    8.0,
                                                    24.0,
                                                    8.0,
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    "${movies[index].title}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0, top: 30.0),
                                  child: Text(
                                    "Upcoming",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              CarouselSlider.builder(
                                  itemCount: movies.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MoviePage(
                                                  movie: movies[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: movies[index].id,
                                            child: Container(
                                              height: 270,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    Constants.kBaseUrlImage +
                                                        movies[index]
                                                            ?.posterPath,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        movieInfo(movies, index),
                                      ],
                                    );
                                  },
                                  options: CarouselOptions(
                                      viewportFraction: 0.6,
                                      aspectRatio: 16 / 9,
                                      height: 500)),
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
    );
  }

  Padding movieInfo(List<Results> movies, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xffF2B705),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "${movies[index].voteAverage}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color(0xff424E59),
                    borderRadius: BorderRadius.circular(6)),
              ),
              Container(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  Helpers.formatterDateFromAPI("${movies[index].releaseDate}"),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                decoration: BoxDecoration(
                    color: Color(0xff424E59),
                    borderRadius: BorderRadius.circular(6)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                "${movies[index].title}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
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
