import 'package:flutter/material.dart';
import 'package:project_aqua/pages/about.dart';
import 'package:project_aqua/pages/lists_page_active.dart';
import 'package:project_aqua/pages/scan_location.dart';

import '../pages/home.dart';

Drawer buildDrawer(BuildContext context, String currentRoute){
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Image(image: AssetImage('lib/assets/header-drawer.jpg'),)
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
          title: const Text("Scan Location"),
          selected: currentRoute == ScanLocation.route,
          onTap: (){
            Navigator.pushReplacementNamed(context, ScanLocation.route);
          },
        ),
        ListTile(
          title: const Text("About"),
          selected: currentRoute == AboutPage.route,
          onTap: (){
            Navigator.pushNamed(context, AboutPage.route);
          },
        )
      ],
    ),
  );
}