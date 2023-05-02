import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'search_results.dart';
import 'main.dart';
import 'translations.dart';
import 'navigation.dart';
import 'search_sort_buttons.dart';
import 'search_results.dart';

class SearchScreen extends StatefulWidget {
  final TextEditingController? controller;
  final bool isComingFromCellarWineDetails; // New parameter

  const SearchScreen({
    this.controller,
    required this.isComingFromCellarWineDetails, // Updated constructor
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _sortByRS = false;
  bool _sortByQP = false;
  bool _hasSearched = false;

  bool _showSortButtons = false;
  bool _sortAscending = false; // default sort order is ascending
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _searchController.text = widget.controller!.text;
    }
    debugPrint(widget.isComingFromCellarWineDetails.toString());
    if (widget.isComingFromCellarWineDetails) { // Check if coming from CellarWineDetails
      // Programmatically call search button's onPressed callback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final Function()? onPressed = IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            String query = _searchController.text;
            _searchResults = await _search(query);
            setState(() {
              _showSortButtons = true;
              _hasSearched = true;
            });
          },
        ).onPressed;
        onPressed?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('AAA' + _searchController.toString());
    // TextEditingController _searchController = controller;
    var translations = Translations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('AGReaTWine'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SearchResults(
              searchResults: _searchResults,
              hasSearched: _hasSearched,
            ),
          ),
          if (_showSortButtons) _buildSortButtons(),
          Container(
            padding: EdgeInsets.only(bottom: 15),
            height: 60,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 15,
                  right: 10,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for wines, wineries or pairings',
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 15,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      String query = _searchController.text;
                      _searchResults = await _search(query);
                      setState(() {
                        _showSortButtons = true;
                        _hasSearched = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH(
        currentIndex: _currentIndex,
      ),
    );
  }

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
           _searchResults = List.from(_searchResults)..sort((a, b) => sortByRS
              ? (b['RS'] ?? 0).compareTo(a['RS'] ?? 0)
              : (a['RS'] ?? 0).compareTo(b['RS'] ?? 0));
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

  Future<List<Map<String, dynamic>>> _search(String query) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
        'SELECT * FROM allwines WHERE FullName LIKE ? OR WineryName LIKE ? OR Pairing LIKE ?',
        ['%$query%', '%$query%', '%$query%']);

    return results;
  }
}