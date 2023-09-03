import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'search_results.dart';
import 'translations.dart';
import 'navigation.dart';
import 'search_sort_buttons.dart';

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
    if (widget.isComingFromCellarWineDetails) {
      // Check if coming from CellarWineDetails
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
    debugPrint('AAA' + _searchController.text);
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

  double parseValue(dynamic value) {
    if (value == null || value == '') return 0.0;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('Failed to parse: $value');
        return 0.0; // default value
      }
    }
    if (value is double) return value;
    return 0.0; // default value for any other unexpected type
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
          _searchResults = List.from(_searchResults)
            ..sort((a, b) {
              double valueA = parseValue(a['RS']);
              double valueB = parseValue(b['RS']);

              return _sortByRS
                ? valueB.compareTo(valueA)
                : valueA.compareTo(valueB);
            });
        });
      },
      onPressedQP: (sortByRS, sortByQP, sortAscending) {
        setState(() {
          _sortByRS = sortByRS;
          _sortByQP = sortByQP;
          _sortAscending = sortAscending;
          _searchResults = List.from(_searchResults)
          ..sort((a, b) {
            double valueA = parseValue(a['QP']);
            double valueB = parseValue(b['QP']);

            return sortByQP
              ? valueB.compareTo(valueA)
              : valueA.compareTo(valueB);
          });
        });
      },
    );
  }


  Future<List<Map<String, dynamic>>> _search(String query) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines43.db');
    final database = await openDatabase(path);

    // Split the query based on the "&" character
    List<String> lists = query.split('&&').map((s) => s.trim()).toList();

    List<String> conditions = [];
    List<String> arguments = [];

    if (lists.length == 1) {
      // No "&" character, treat entire query as a single list of words
      List<String> wordsList = lists[0].split(' ').map((s) => s.trim()).toList();
      for (String word in wordsList) {
        conditions.add('FullName LIKE ? OR WineryName LIKE ? OR Pairing LIKE ?');
        arguments.addAll(['%$word%', '%$word%', '%$word%']);
      }
    } else if (lists.length == 2) {
      // Split each list into individual words
      List<String> wordsList1 = lists[0].split(' ').map((s) => s.trim()).toList();
      List<String> wordsList2 = lists[1].split(' ').map((s) => s.trim()).toList();

      for (String word1 in wordsList1) {
        for (String word2 in wordsList2) {
          conditions.add('(FullName LIKE ? OR WineryName LIKE ? OR Pairing LIKE ?) AND (FullName LIKE ? OR WineryName LIKE ? OR Pairing LIKE ?)');
          arguments.addAll(['%$word1%', '%$word1%', '%$word1%', '%$word2%', '%$word2%', '%$word2%']);
        }
      }
    }

    String sql = 'SELECT * FROM allwines WHERE ' + conditions.join(' OR ');

    final results = await database.rawQuery(sql, arguments);

    return results;
  }
}
