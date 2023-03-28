import 'package:flutter/material.dart';
import 'details_screen.dart';

class WineListTile extends StatelessWidget {
  final Map<String, dynamic> wineData;

  WineListTile({required this.wineData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(wineData['FullName']),
      subtitle: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(wineData['WineryName']),
              Text(' | '),
              Text(wineData['AppellationLevel']),
              Text(' '),
              Text(wineData['AppellationName']),
              Text(' | '),
              Text(wineData['Region']),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('RS '),
              Text(wineData['RS'].toInt().toString()),
              Text(' | Rank '),
              Text(wineData['RANK']),
              Text(' | '),
              Text(wineData['EvaluationAvg'].toString()),
              Text(''),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('QP '),
              Text(wineData['QP'].toInt().toString()),
              Text(' | '),
              Text(wineData['Price']),
            ],
          ),
        ],
      ),
      onTap: () {
        final wineDetails = {
          'fullName': wineData['FullName'],
          'wineryName': wineData['WineryName'],
          'appellationLevel': wineData['AppellationLevel'],
          'appellationName': wineData['AppellationName'],
          'region': wineData['Region'],
          'rsScore': wineData['RS'],
          'qpScore': wineData['QP'],
          'rank': wineData['RANK'],
          'price': wineData['Price'],
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineDetailsScreen(wineDetails),
          ),
        );
      },
    );
  }
}

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
        return WineListTile(wineData: result);
      },
    );
  }
}
