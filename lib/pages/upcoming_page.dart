import 'package:flutter/material.dart';
import 'package:movie_api/bloc/home_bloc.dart';

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
      appBar: AppBar(
        backgroundColor: Color(0xff141E26),
        title: Text("Comming soon"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
