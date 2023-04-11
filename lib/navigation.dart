import 'package:flutter/material.dart';
import 'main.dart';
import 'search_screen.dart';
import 'appellation_docg.dart';
import 'appellation_doc.dart';
import 'appellation_second.dart';

class AGreatDrawer extends StatelessWidget {
  const AGreatDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 118,
          child: DrawerHeader(
            child: Text('AGReaTWine'),
          ),
        ),
        ListTile(
          title: Text('DOCG Appellations'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DocgScreen()),
              );
          },
        ),
        ListTile(
          title: Text('DOC Appellations'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DocScreen()),
              );
          },
        ),
        ListTile(
          title: Text('2nd Level Comparisons'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SlevelScreen()),
              );
          },
        ),
      ],
    ),
  );
  }
}

class AGreatBottomNavigationBar extends StatelessWidget {  
const AGreatBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );              
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}

class AGreatBottomNavigationBarH extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  
  const AGreatBottomNavigationBarH({Key? key, required this.currentIndex, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.3),
        //     blurRadius: 8,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        items: items,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}