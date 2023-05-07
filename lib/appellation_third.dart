	import 'package:flutter/material.dart';	
import 'package:path/path.dart';	
import 'package:sqflite/sqflite.dart';	
import 'main.dart';	
import 'navigation.dart';	
import 'single_wine_tile.dart';	
import 'comparisons_screen.dart';	
import 'entries_screen.dart';


Future<List<Map<String, dynamic>>> searchWines() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'allwines29.db');
  
  Database database = await openDatabase(path);
  List<Map<String, dynamic>> results = await database.rawQuery(
    "SELECT TLC, COUNT(*) as count FROM allwines WHERE TLC IS NOT NULL AND Entry = 1 GROUP BY tlc",
  );
  await database.close();
  return results;
}

int _currentIndex = 1;
int _docIndex = 0;
int _docgIndex = 0;  
int _slevelIndex = 0;
int _tlevelIndex = 1;
String levelName = 'TLC';

class TlevelScreen extends StatefulWidget {
  @override
  _TlevelScreenState createState() => _TlevelScreenState();
}

class _TlevelScreenState extends State<TlevelScreen> {
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
                          level: wine['TLC'], levelName: levelName
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(wine['TLC']),
                        Text('${wine['count']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ComparisonsScreen(docIndex: _docIndex, docgIndex: _docgIndex, slevelIndex: _slevelIndex, tlevelIndex: _tlevelIndex)
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH( currentIndex: _currentIndex),
    );
  }
}