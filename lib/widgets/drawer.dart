import 'package:flutter/material.dart';
import 'package:project_aqua/pages/lists_page.dart';
import 'package:project_aqua/pages/lists_page_active.dart';

import '../pages/home.dart';

Drawer buildDrawer(BuildContext context, String currentRoute){
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text("Project Aqua"),
          ),
        ),
        ListTile(
          title: const Text("Street Map"),
          selected: currentRoute == HomePage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, HomePage.route);
          },
        ),
        ListTile(
          title: const Text("Locations"),
          selected: currentRoute == ListsLocation.route,
          onTap: (){
            Navigator.pushReplacementNamed(context, ListsLocation.route);
          },
        ),
        ListTile(
          title: const Text("My Lists"),
          selected: currentRoute == ListsPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, ListsPage.route);
          },
        )
      ],
    ),
  );
}