import 'package:flutter/material.dart';
import 'single_wine_tile.dart';


class SearchResults extends StatefulWidget {
  final List<Map<String, dynamic>> searchResults;
  final bool hasSearched;

  SearchResults({required this.searchResults,
  required this.hasSearched});

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

  @override
  Widget build(BuildContext context) {
    final filteredResults = widget.searchResults
        .where((result) => result['Entry'] == "1")
        .toList();

    if (filteredResults.isEmpty && !widget.hasSearched) { // modified conditional statement
      return Center(
        child: Text('No search has been performed'),
      );
    } else if (filteredResults.isEmpty && widget.hasSearched) { // modified conditional statement
      return Center(
        child: Text('No results'),
      );
    } else {
       // added conditional statement
      return ListView.builder(
        itemCount: filteredResults.length,
        itemBuilder: (BuildContext context, int index) {
          final result = filteredResults[index];
          final isSecondLevel = false;
          final isThirdLevel = false;
          return SingleWineTile(result: result, isSecondLevel: isSecondLevel, isThirdLevel: isThirdLevel);
        },
      );
    }
  }
}