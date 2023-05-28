import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'navigation.dart';
import 'entries_screen.dart';
import 'comparisons_screen.dart';


Future<List<Map<String, dynamic>>> searchWines(String query) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'allwines40.db');
  
  Database database = await openDatabase(path);
  List<Map<String, dynamic>> results = await database.rawQuery(
    "SELECT AppellationName, COUNT(*) as count FROM allwines WHERE AppellationLevel = 'DOCG' AND Entry = 1 AND AppellationName LIKE '%$query%' GROUP BY AppellationName",
  );
  await database.close();
  return results;
}

int _currentIndex = 1;
  int _docIndex = 0;
  int _docgIndex = 1;  
  int _slevelIndex = 0;
  int _tlevelIndex = 0;
  String levelName = 'DOC';

class DocgScreen extends StatefulWidget {
  @override
  _DocgScreenState createState() => _DocgScreenState();
}

class _DocgScreenState extends State<DocgScreen> {
  List<Map<String, dynamic>> wines = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchWines('').then((results) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Filter by name',
                border: UnderlineInputBorder(),
              ),
              onChanged: (query) {
                searchWines(query).then((results) {
                  setState(() {
                    wines = results;
                  });
                });
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