import 'package:flutter/material.dart';
import 'package:project_aqua/pages/lists_page.dart';
import 'package:project_aqua/pages/lists_page_active.dart';

import './pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Aqua',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        ListsPage.route: (context) => ListsPage(),
        ListsLocation.route: (context) => ListsLocation(),
      },
    );
  }
}
