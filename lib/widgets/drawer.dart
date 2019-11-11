import 'package:flutter/material.dart';

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
        ),
        ListTile(
          title: const Text("Locations"),
        ),
        ListTile(
          title: const Text("My Lists"),
        )
      ],
    ),
  );
}