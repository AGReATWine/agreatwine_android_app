import 'package:flutter/material.dart';
import 'search_results.dart';
import 'details_screen.dart';

class SingleWineTile extends StatelessWidget {
  final Map<String, dynamic> result;

  SingleWineTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
        child: ListTile(
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
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: result['RS'],
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Text(result['RS'].toInt().toString()),
                    ),
                  ],
                ),
                Icon(Icons.leaderboard),
                Text(result['RANK']),
                Text(' | '),
                Text(result['EvaluationAvg'].toString()),
                Text(''),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('QP '),
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: result['QP'],
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
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
      )
    );
  }
}