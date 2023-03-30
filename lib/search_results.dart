import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'single_wine_tile.dart';

class SearchResults extends StatefulWidget {
  final List<Map<String, dynamic>> searchResults;

  SearchResults({required this.searchResults});

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    final filteredResults = widget.searchResults
        .where((result) => result['Entry'] == "1")
        .toList();

    if (filteredResults.isEmpty) {
      return Center(
        child: Text('No results'),
      );
    }

    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (BuildContext context, int index) {
        final result = filteredResults[index];
        return SingleWineTile(result: result);
      },
    );
  }
}
