import 'package:flutter/material.dart';
import 'package:movie_api/view/upcoming_page.dart';

import 'data/config/data_base_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database.then(
    (value) => runApp(
      MyApp(),
    ),
  );
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
