import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'search_results.dart';
import 'main.dart';
import 'navigation.dart';
import 'search_sort_buttons.dart';

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

  @override
  void initState() {
    super.initState();
    searchEntries().then((results) {
      setState(() {
        entries = results;
      });
    });
  }

  Future<List<Map<String, dynamic>>> searchEntries() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'allwines2.db');
  
    Database database = await openDatabase(path);
    List<Map<String, dynamic>> results = await database.rawQuery(
      "SELECT * FROM allwines WHERE AppellationName = ? AND Entry = 1",
      [widget.appellationName],
    );
    await database.close();
    return results;
  }

  bool _sortByRS = false;
  bool _sortByQP = false;
  bool _showSortButtons = false;
  bool _sortAscending = false; // default sort order is ascending

  Widget _buildSortButtons() {
    return SortButtons(
      sortByRS: _sortByRS,
      sortByQP: _sortByQP,
      sortAscending: _sortAscending,
      onPressedRS: (sortByRS, sortByQP, sortAscending) {
        setState(() {
          _sortByRS = sortByRS;
          _sortByQP = sortByQP;
          _sortAscending = sortAscending;
          entries = List.from(entries)..sort((a, b) {
            int rsComparison =
                (_sortAscending ? b['RS'] ?? 0 : a['RS'] ?? 0).compareTo(
                    _sortAscending ? a['RS'] ?? 0 : b['RS'] ?? 0);
            if (rsComparison != 0) {
              return rsComparison;
            } else {
              return (a['RANK'] ?? 0).compareTo(b['RANK'] ?? 0);
            }
          });
        });
      },
      onPressedQP: (sortByRS, sortByQP, sortAscending) {
        setState(() {
          _sortByRS = sortByRS;
          _sortByQP = sortByQP;
          _sortAscending = sortAscending;
          entries = List.from(entries)..sort((a, b) => sortByQP
              ? (b['QP'] ?? 0).compareTo(a['QP'] ?? 0)
              : (a['QP'] ?? 0).compareTo(b['QP'] ?? 0));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.appellationName} Appellation Wine List"),
      ),
      body: Column(
        children: [
          _buildSortButtons(), // add the sort buttons widget
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return WineListTile(wineData: entry);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }
}