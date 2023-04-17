import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';
import 'navigation.dart';
import 'single_wine_tile.dart';
import 'comparisons_screen.dart';
import 'appellation_second.dart';

int _currentIndex = 1;
bool isSecondLevel = false;
bool isThirdLevel = false;

class EntriesScreen extends StatefulWidget {
  final String level;
  final String levelName;

  EntriesScreen({required this.level, required this.levelName});

  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  List<Map<String, dynamic>> entries = [];
  List<Map<String, dynamic>> originalEntries =
      []; // New variable to store unfiltered entries
  List<String> wineTypes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchEntries().then((results) {
      setState(() {
        entries = results;
        originalEntries =
            List.from(results); // Store a copy of the unfiltered entries
      });
    });
  }

  Future<List<Map<String, dynamic>>> searchEntries() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'allwines10.db');
    Database database = await openDatabase(path);
    List<Map<String, dynamic>> results;
    if (widget.levelName == 'SLC') {
      results = await database.rawQuery(
        "SELECT * FROM allwines WHERE SLC = ? AND Entry = 1",
        [
          widget.level,
        ],
      );
    } else if (widget.levelName == 'TLC') {
      results = await database.rawQuery(
        "SELECT * FROM allwines WHERE TLC = ? AND Entry = 1",
        [
          widget.level,
        ],
      );
    } else {
      results = await database.rawQuery(
        "SELECT * FROM allwines WHERE AppellationName = ? AND Entry = 1",
        [widget.level],
      );
    }

    await database.close();
    // Extract unique WineType values
    Set<String> wineTypeSet = Set<String>();
    results.forEach((entry) {
      wineTypeSet.add(entry['WineType']);
    });
    wineTypes = wineTypeSet.toList();
    return results;
  }

  void filterEntriesByWineType(String wineType) {
    if (wineType == 'All') {
      setState(() {
        entries = List.from(originalEntries);
      });
    } else {
      List<Map<String, dynamic>> filteredEntries =
          originalEntries.where((entry) {
        return entry['WineType'] == wineType;
      }).toList();
      setState(() {
        entries = filteredEntries;
      });
    }
  }

void filterEntries(String query) {
  List<Map<String, dynamic>> filteredEntries = originalEntries.where((entry) {
    return entry['FullName'] != null && entry['FullName'].toLowerCase().contains(query.toLowerCase()) ||
           entry['WineryName'] != null && entry['WineryName'].toLowerCase().contains(query.toLowerCase()) ||
           entry['Pairings'] != null && entry['Pairings'].toLowerCase().contains(query.toLowerCase());
  }).toList();
  setState(() {
    entries = filteredEntries;
  });
}

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.level.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.level} Wine List"),
      ),
      body: Column(
        children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter search query'
              ),
              onChanged: (query) {
                filterEntries(query);
              },
            ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                final entry = entries[index];
                if (widget.levelName == 'SLC') {
                  isSecondLevel = true;
                  isThirdLevel = false;
                } else if (widget.levelName == 'TLC') {
                  isSecondLevel = false;
                  isThirdLevel = true;
                } else {
                  isSecondLevel = false;
                  isThirdLevel = false;
                }
                return SingleWineTile(
                    result: entry,
                    isSecondLevel: isSecondLevel,
                    isThirdLevel: isThirdLevel);
              },
            ),
          ),
          if(wineTypes.length > 1) Container(
  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              entries = List.from(originalEntries);
            });
          },
          child: Text("All"),
        ),
        ...wineTypes.map((wineType) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              onPressed: () {
                filterEntriesByWineType(wineType);
              },
              child: Text(wineType),
            ),
          );
        }).toList(),
      ],
    ),
  ),
),
        ],
      ),
      bottomNavigationBar:
          AGreatBottomNavigationBarH(currentIndex: _currentIndex),
    );
  }
}
