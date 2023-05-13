import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


import 'main.dart';
import 'navigation.dart';
import 'single_wine_tile.dart';
import 'comparisons_screen.dart';
import 'entries_screen.dart';

int _currentIndex = 1;
int _docIndex = 0;
int _docgIndex = 0;
int _slevelIndex = 1;
int _tlevelIndex = 0;
String levelName = 'SLC';

Future<List<Map<String, dynamic>>> searchWines() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'allwines33.db');

  Database database = await openDatabase(path);
  List<Map<String, dynamic>> results = await database.rawQuery(
    "SELECT SLC, COUNT(*) as count FROM allwines WHERE SLC IS NOT NULL AND Entry = 1 GROUP BY slc",
  );
  await database.close();
  return results;
}

class SlevelScreen extends StatefulWidget {
  @override
  _SlevelScreenState createState() => _SlevelScreenState();
}

class _SlevelScreenState extends State<SlevelScreen> {
  List<Map<String, dynamic>> wines = [];

  @override
  void initState() {
    super.initState();
    searchWines().then((results) {
      setState(() {
        wines = results;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGReaTWine'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: wines.length,
              itemBuilder: (context, index) {
                final wine = wines[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntriesScreen(level: wine['SLC'], levelName: levelName,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(wine['SLC']),
                        Text('${wine['count']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ComparisonsScreen(
              docIndex: _docIndex,
              docgIndex: _docgIndex,
              slevelIndex: _slevelIndex,
              tlevelIndex: _tlevelIndex)
        ],
      ),
      bottomNavigationBar:
          AGreatBottomNavigationBarH(currentIndex: _currentIndex),
    );
  }
}

