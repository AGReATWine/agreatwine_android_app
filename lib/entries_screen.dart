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
  bool isAscending = true;
  bool isSelected = false;
  String selectedWineType = '';

  final unselectedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.red.shade50, 
    foregroundColor: utils.primaryLight, 
  );

  final selectedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.red.shade50, 
    backgroundColor: utils.primaryLight, 
  );

@override
void initState() {
  super.initState();
  searchEntries().then((results) {
    setState(() {
      entries = results;
      originalEntries =
          List.from(results); // Store a copy of the unfiltered entries
      isSelected = true; // Set isSelected to true by default
    });
  });
}

  Future<List<Map<String, dynamic>>> searchEntries() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'allwines31.db');
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
        selectedWineType = ''; // reset selectedWineType when All is pressed
      });
    } else {
      List<Map<String, dynamic>> filteredEntries =
          originalEntries.where((entry) {
        return entry['WineType'] == wineType;
      }).toList();
      setState(() {
        entries = filteredEntries;
        selectedWineType =
            wineType; // update selectedWineType with the selected wine type
      });
    }
  }

void filterEntries(String query) {
  List<Map<String, dynamic>> filteredEntries = originalEntries.where((entry) {
    return (entry['FullName'] != null && entry['FullName'].isNotEmpty && entry['FullName'].toLowerCase().contains(query.toLowerCase())) ||
           (entry['WineryName'] != null && entry['WineryName'].isNotEmpty && entry['WineryName'].toLowerCase().contains(query.toLowerCase())) ||
           (entry['Pairings'] != null && entry['Pairings'].isNotEmpty && entry['Pairings'].toLowerCase().contains(query.toLowerCase()));
  }).toList();
  setState(() {
    entries = filteredEntries;
  });
}

  void sortEntries(String field, bool isAscending) {
    List<Map<String, dynamic>> sortedEntries = List.from(entries);
    sortedEntries.sort((a, b) {
      if (widget.levelName == 'SLC') {
        if (isAscending) {
          return a['RS2'].compareTo(b['RS2']);
        } else {
          return b['RS2'].compareTo(a['RS2']);
        }
      } else if (widget.levelName == 'TLC') {
        if (isAscending) {
          return a['RS3'].compareTo(b['RS3']);
        } else {
          return b['RS3'].compareTo(a['RS3']);
        }
      } else {
        if (isAscending) {
          return a[field].compareTo(b[field]);
        } else {
          return b[field].compareTo(a[field]);
        }
      }
    });
    setState(() {
      entries = sortedEntries;
      this.isAscending = isAscending;
    });
  }

  String _value = 'RS';
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.level.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.level} Wine List"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Sort by: '),
              DropdownButton<String>(
                value: _value,
                onChanged: (String? field) {
                  if (field == 'QP') {
                    setState(() {
                      _value = 'QP';
                    });
                    sortEntries(field!, isAscending);
                  } else if (field == 'RS') {
                    setState(() {
                      _value = 'RS';
                    });
                    sortEntries(field!, isAscending);
                  }
                },
                items: [
                  DropdownMenuItem(value: 'RS', child: Text('RS')),
                  DropdownMenuItem(value: 'QP', child: Text('QP')),
                ],
              ),
              IconButton(
                icon: Icon(isAscending ? Icons.swap_vert : Icons.swap_vert),
                onPressed: () {
                  sortEntries('RS', !isAscending);
                },
              ),
            ],
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
          if (wineTypes.length > 1)
  Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                entries = List.from(originalEntries);
                isSelected = true;
                selectedWineType = ''; // reset isSelected and selectedWineType when All is pressed
              });
            },
            style: isSelected && selectedWineType == ''
                ? selectedButtonStyle
                : unselectedButtonStyle, // update style based on isSelected and selectedWineType
            child: Text("All"),
          ),
          ...wineTypes.map((wineType) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  filterEntriesByWineType(wineType);
                  setState(() {
                    isSelected = true;
                    selectedWineType = wineType; // update isSelected and selectedWineType when this button is clicked
                  });
                },
                style: isSelected && selectedWineType == wineType
                    ? selectedButtonStyle
                    : unselectedButtonStyle, // update style based on isSelected and selectedWineType
                child: Text(wineType),
              ),
            );
          }).toList(),
        ],
      ),
    ),
  ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(hintText: 'Filter for name, winery or pairing'),
              onChanged: (query) {
                filterEntries(query);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          AGreatBottomNavigationBarH(currentIndex: _currentIndex),
    );
  }
}
