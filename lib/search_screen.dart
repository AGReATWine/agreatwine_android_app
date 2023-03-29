import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'search_results.dart';
import 'main.dart';
import 'navigation.dart';
import 'search_sort_buttons.dart';

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
  int _currentIndex = 1;

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
          _searchResults = List.from(_searchResults)..sort((a, b) {
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
          _searchResults = List.from(_searchResults)..sort((a, b) => sortByQP
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
        title: Text('AGReaTWine'),
      ),
      drawer: const AGreatDrawer(),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
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
              if (_showSortButtons) _buildSortButtons()
            ],
          ),
          Expanded(
            child: SearchResults(searchResults: _searchResults),
          ),
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH(currentIndex: _currentIndex),
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