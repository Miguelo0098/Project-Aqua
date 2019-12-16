import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:project_aqua/widgets/drawer.dart';

class AboutPage extends StatefulWidget{
  static const String route = "/about";

  AboutPage();

  @override 
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>{

  _AboutPageState();
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("About"),),
      drawer: buildDrawer(context, AboutPage.route),
      body: ListView(children: <Widget>[
        ListTile(
          title: Text("Project Aqua"),
          subtitle: Text("Version: 1.4.1"),
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          title: Text("GitHub"),
          subtitle: Text("github.com/Miguelo0098/Project-Aqua"),
          onTap: () => FlutterWebBrowser.openWebPage(
            url: "https://github.com/Miguelo0098/Project-Aqua",
            androidToolbarColor: Theme.of(context).primaryColor,
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        ListTile(
          title: Text("Built with Flutter"),
          subtitle: Text("flutter.dev"),
          onTap: () => FlutterWebBrowser.openWebPage(
            url: "https://flutter.dev",
            androidToolbarColor: Theme.of(context).primaryColor,
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],),
    );
  }
}