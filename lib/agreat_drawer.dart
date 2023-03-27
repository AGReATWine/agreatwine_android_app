import 'package:flutter/material.dart';
import 'main.dart';
import 'search_screen.dart';
import 'test_appellation.dart';

class AGreatDrawer extends StatelessWidget {
  const AGreatDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text('AGReaTWine'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        ListTile(
          title: Text('Search'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
              );
          },
        ),
        ListTile(
          title: Text('Test'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TestScreen()),
              );
          },
        ),
      ],
    ),
  );
  }
}