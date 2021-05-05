import 'package:flutter/material.dart';
import 'package:movie_api/pages/upcoming_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie API',
      debugShowCheckedModeBanner: false,
      home: UpCommingPage(),
    );
  }
}
