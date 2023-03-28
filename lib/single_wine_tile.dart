import 'package:flutter/material.dart';
import 'search_results.dart';

class SingleWineTile extends StatelessWidget {
  final Map<String, dynamic> result;

  SingleWineTile({required this.result});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}