import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'search_results.dart';
import 'main.dart';
import 'navigation.dart';
import 'search_sort_buttons.dart';
import 'single_wine_tile.dart';

Future<List<Map<String, dynamic>>> searchWines() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'allwines2.db');
  
  Database database = await openDatabase(path);
  List<Map<String, dynamic>> results = await database.rawQuery(
    "SELECT AppellationName, COUNT(*) as count FROM allwines WHERE AppellationLevel = 'DOCG' AND Entry = 1 GROUP BY AppellationName",
  );
  await database.close();
  return results;
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
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
      drawer: const AGreatDrawer(),
      body: ListView.builder(
        itemCount: wines.length,
        itemBuilder: (context, index) {
          final wine = wines[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntriesScreen(
                    appellationName: wine['AppellationName'],
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
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }
}

class EntriesScreen extends StatefulWidget {
  final String appellationName;

  EntriesScreen({required this.appellationName});

  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  List<Map<String, dynamic>> entries = [];
  List<Map<String, dynamic>> groupedEntries = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchEntries().then((results) {
      setState(() {
        entries = results;
        _groupEntriesByWineType();
      });
    });
  }

  void _groupEntriesByWineType() {
    groupedEntries = [];
    Map<String, List<Map<String, dynamic>>> wineTypeMap = {};
    entries.forEach((entry) {
      String wineType = entry['WineType'];
      if (!wineTypeMap.containsKey(wineType)) {
        wineTypeMap[wineType] = [];
      }
      wineTypeMap[wineType]!.add(entry);
    });
    wineTypeMap.forEach((wineType, entries) {
      if (entries.isNotEmpty) {
        groupedEntries.add({
          'WineType': wineType,
          'Entries': entries,
        });
      }
    });
  }

  void _resetFilter() {
    _searchController.clear(); // clear the search text field
    searchEntries().then((results) {
      setState(() {
        entries = results;
        _groupEntriesByWineType();
      });
    });
  }

  Future<List<Map<String, dynamic>>> searchEntries() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'allwines2.db');

    Database database = await openDatabase(path);
    List<Map<String, dynamic>> results = await database.rawQuery(
      "SELECT * FROM allwines WHERE AppellationName = ? AND Entry = 1 AND FullName LIKE ?",
      [widget.appellationName, '%${_searchController.text}%'], // filter by the search text field
    );
    await database.close();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.appellationName} Appellation Wine List"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupedEntries.length,
              itemBuilder: (context, index) {
                final group = groupedEntries[index];
                return group['Entries'].isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              group['WineType'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: group['Entries'].length,
                            itemBuilder: (context, index) {
                              final entry = group['Entries'][index];
                              return SingleWineTile(result: entry);
                            },
                          ),
                        ],
                      )
                    : SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }
}