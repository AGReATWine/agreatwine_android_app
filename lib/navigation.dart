import 'package:flutter/material.dart';
import 'main.dart';
import 'search_screen.dart';
import 'appellation_docg.dart';
import 'appellation_doc.dart';
import 'appellation_second.dart';
import 'appellation_third.dart';
import 'comparisons_screen.dart';
import 'cellar.dart';

// class AGreatDrawer extends StatelessWidget {
//   const AGreatDrawer({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//     child: ListView(
//       padding: EdgeInsets.zero,
//       children: [
//         Container(
//           height: 118,
//           child: DrawerHeader(
//             child: Text('AGReaTWine'),
//           ),
//         ),
//         ListTile(
//           title: Text('DOCG Appellations'),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DocgScreen()),
//               );
//           },
//         ),
//         ListTile(
//           title: Text('DOC Appellations'),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DocScreen()),
//               );
//           },
//         ),
//         ListTile(
//           title: Text('2nd Level Comparisons'),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => DocgScreen()),
//               );
//           },
//         ),
//         ListTile(
//           title: Text('3rd Level Comparisons'),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => TlevelScreen()),
//               );
//           },
//         ),
//       ],
//     ),
//   );
//   }
// }

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
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.grey.shade500,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Appellations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shelves),
            label: 'MyCellar',
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
                MaterialPageRoute(builder: (context) => DocgScreen()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(isComingFromCellarWineDetails: false,)),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCellarScreen()),
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
  
  const AGreatBottomNavigationBarH({Key? key, required this.currentIndex}) : super(key: key);

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
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Appellations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shelves),
            label: 'MyCellar',
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
                MaterialPageRoute(builder: (context) => DocgScreen()),
              );
              break;
              case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(isComingFromCellarWineDetails: false,)),
              );
              break;
              case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCellarScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}