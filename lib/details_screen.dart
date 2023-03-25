import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class WineDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> wineDetails;

  WineDetailsScreen(this.wineDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wine Details'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getWineDetails(wineDetails['fullName'], wineDetails['wineryName']),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            final details = snapshot.data!;
            final vintages = details.map((detail) => detail['Vintage'].toString()).toList();
            final evaluations = details.map((detail) => detail['EvaluationAvg']).toList();
            final scoreAvg = details.map((detail) => detail['ScoreAvg']).toList();
            final tasting = details.map((detail) => detail['Tasting']).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(wineDetails['fullName']),
                ],),
                Row(children: [
                    Text(wineDetails['wineryName']),
                    Text(' | '),
                    Text(wineDetails['appellationLevel']),
                    Text(' '),
                    Text(wineDetails['appellationName']),
                    Text(' | '),
                    Text(wineDetails['region']),
                ],),
                Row(children: [
                    Text(wineDetails['rsScore'].toInt().toString()),
                    Text(' | '),
                    Text(wineDetails['qpScore'].toInt().toString()),
                    Text(' | '),
                    Text('Rank '),
                    Text(wineDetails['rank'].toString()),
                ],),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Vintage(s):'),
                  ],
                ),
                SizedBox(height: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < vintages.length; i++)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(vintages[i]),
                              Text(' '),
                              Text(evaluations[i]),
                              Icon(Icons.star, size: 20, color: Colors.black),
                              Text(' - '),
                              Text(scoreAvg[i]),
                            ],
                          ),
                          ExpansionTile(
                            title: Text('Tasting Note'),
                            children: [
                              Text(tasting[i], softWrap: true),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                  ],
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getWineDetails(String fullName, String wineryName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines2.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
      'SELECT Vintage, EvaluationAvg, ScoreAvg, Tasting FROM allwines WHERE FullName = ? AND WineryName = ? AND Entry = ?',
      [fullName, wineryName, 2],
    );

    return results.toList();
  }
}