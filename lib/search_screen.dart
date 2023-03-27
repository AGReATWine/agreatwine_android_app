import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'search_results.dart';
import 'main.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _sortByRS = false;
  bool _sortByQP = false;
  bool _showSortButtons = false;
  bool _sortAscending = false; // default sort order is ascending

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGReaTWine'),
      ),
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text('AGReaTWine'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        ListTile(
          title: Text('Search'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 16),
              ElevatedButton(
                child: Text('Search'),
                onPressed: () async {
                  String query = _searchController.text;
                  _searchResults = await _search(query);
                  setState(() {
                    _showSortButtons = true;
                  });
                },
              ),
              if (_showSortButtons) 
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: ElevatedButton(
                    child: Text('Sort by RS'),
                    onPressed: () async {
                      setState(() {
                        _sortByRS = !_sortByRS;
                        _sortByQP = false;
                        _sortAscending = !_sortAscending; // toggle sort order
                        _searchResults = List.from(_searchResults)..sort((a, b) {
                          int rsComparison = (_sortAscending ? b['RS'] ?? 0 : a['RS'] ?? 0).compareTo(_sortAscending ? a['RS'] ?? 0 : b['RS'] ?? 0);
                          if (rsComparison != 0) {
                            return rsComparison;
                          } else {
                            return (a['RANK'] ?? 0).compareTo(b['RANK'] ?? 0);
                          }
                        });
                      });
                    },
                  ),
                ),
              if (_showSortButtons) // conditionally render sort buttons
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: ElevatedButton(
                    child: Text('Sort by QP'),
                    onPressed: () {
                      setState(() {
                        _sortByQP = !_sortByQP;
                        _sortByRS = false;
                        _searchResults = List.from(_searchResults)..sort((a, b) => _sortByQP
                            ? (b['QP'] ?? 0).compareTo(a['QP'] ?? 0)
                            : (a['QP'] ?? 0).compareTo(b['QP'] ?? 0));
                      });
                    },
                  ),
                )
            ],
          ),
          Expanded(
            child: SearchResults(searchResults: _searchResults),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _search(String query) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines2.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
        'SELECT * FROM allwines WHERE FullName LIKE ? OR WineryName LIKE ?',
        ['%$query%', '%$query%']);

    return results;
  }
}