import 'package:flutter/material.dart';
import 'details_screen.dart';

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
        return ListTile(
          title: Text(result['FullName']),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(result['WineryName']),
                  Text(' | '),
                  Text(result['AppellationLevel']),
                  Text(' '),
                  Text(result['AppellationName']),
                  Text(' | '),
                  Text(result['Region']),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('RS '),
                  Text(result['RS'].toInt().toString()),
                  Text(' | Rank '),
                  Text(result['RANK']),
                  Text(' | '),
                  Text(result['EvaluationAvg'].toString()),
                  Text(''),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('QP '),
                  Text(result['QP'].toInt().toString()),
                  Text(' | '),
                  Text(result['Price']),
                ],
              ),
            ],
          ),
          onTap: () {
            final wineDetails = {
              'fullName': result['FullName'],
              'wineryName': result['WineryName'],
              'appellationLevel': result['AppellationLevel'],
              'appellationName': result['AppellationName'],
              'region': result['Region'],
              'rsScore': result['RS'],
              'qpScore': result['QP'],
              'rank': result['RANK'],
              'price': result['Price'],
            };
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineDetailsScreen(wineDetails),
              ),
            );
          },
        );
      },
    );
  }
}
