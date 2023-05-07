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
  String path = join(databasesPath, 'allwines31.db');
  
  Database database = await openDatabase(path);
  List<Map<String, dynamic>> results = await database.rawQuery(
    "SELECT wineryName, COUNT(*) as count FROM allwines WHERE AppellationLevel = 'DOCG' AND Entry = 1",
  );
  await database.close();
  return results;
}


class WineryEntriesScreen extends StatefulWidget {
  final String wineryName;

  WineryEntriesScreen({required this.wineryName});

  @override
  _WineryEntriesScreenState createState() => _WineryEntriesScreenState();
}

class _WineryEntriesScreenState extends State<WineryEntriesScreen> {
  List<Map<String, dynamic>> entries = [];
  TextEditingController _searchController = TextEditingController();
  Map<String, bool> _sortDescendingMap = {}; // add map to track sorting of each wine type

  @override
  void initState() {
    super.initState();
    searchEntries().then((results) {
      setState(() {
        entries = results;
      });
    });
  }

  void _resetFilter() {
    _searchController.clear(); // clear the search text field
    searchEntries().then((results) {
      setState(() {
        entries = results;
      });
    });
  }

  Future<List<Map<String, dynamic>>> searchEntries() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'allwines31.db');

    Database database = await openDatabase(path);
    List<Map<String, dynamic>> results = await database.rawQuery(
      "SELECT * FROM allwines WHERE wineryName = ? AND Entry = 1 AND FullName LIKE ?",
      [widget.wineryName, '%${_searchController.text}%'], // filter by the search text field
    );
    await database.close();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.wineryName}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _resetFilter,
                ),
              ),
              onChanged: (value) {
                searchEntries().then((results) {
                  setState(() {
                    entries = results;
                  });
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final isSecondLevel = false;
                final isThirdLevel = false;
                return SingleWineTile(result: entry, isSecondLevel: isSecondLevel, isThirdLevel: isThirdLevel);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }
}