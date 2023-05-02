import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


import 'navigation.dart';
import 'entries_screen.dart';
import 'comparisons_screen.dart';


Future<List<Map<String, dynamic>>> searchWines() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'allwines24.db');
  
  Database database = await openDatabase(path);
  List<Map<String, dynamic>> results = await database.rawQuery(
    "SELECT AppellationName, COUNT(*) as count FROM allwines WHERE AppellationLevel = 'DOC' AND Entry = 1 GROUP BY AppellationName",
  );
  await database.close();
  return results;
}

  int _currentIndex = 1;
  int _docIndex = 1;
  int _docgIndex = 0;  
  int _slevelIndex = 0;
  int _tlevelIndex = 0;
  String levelName = 'DOC';

class DocScreen extends StatefulWidget {
  @override
  _DocScreenState createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
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
                        builder: (context) => EntriesScreen(
                          level: wine['AppellationName'], levelName: levelName
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(wine['AppellationName']),
                        Text('${wine['count']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ComparisonsScreen( docIndex: _docIndex, docgIndex: _docgIndex, slevelIndex: _slevelIndex, tlevelIndex: _tlevelIndex)
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH( currentIndex: _currentIndex),
    );
  }
}