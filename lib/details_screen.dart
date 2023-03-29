import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'navigation.dart';

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
            final grapes = details.map((detail) => detail['Grapes']).toList();
            final agingMonths = details.map((detail) => detail['AgingMonths']).toList();
            final agingType = details.map((detail) => detail['AgingType']).toList();
            final rank = details.map((detail) => detail['RANK']).toList();
            final price = details.map((detail) => detail['Price']).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text('' '${wineDetails['fullName']}',style: TextStyle(fontSize: 30, color:Colors.black87)),
                ],),
                Row(children: [
                  Text('Details',style: TextStyle(fontSize: 25, color:Colors.black87)),
                ],),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultTextStyle(style: TextStyle(fontSize: 18, color: Colors.black87),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(0.3),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text('Winery'),
                              Text(wineDetails['wineryName']),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Appellation'),
                              Text('${wineDetails['appellationLevel']}' ' ' '${wineDetails['appellationName']}'),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Region'),
                              Text(wineDetails['region']),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Grapes'),
                              Text(wineDetails['grapes']),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Aging'),
                              Text('${wineDetails['agingMonths']}' ' months ' '${wineDetails['agingType']}'),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Price'),
                              Text('${wineDetails['price']}' '€'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                Row(children: [
                  Text('Scores',style: TextStyle(fontSize: 25, color:Colors.black87)),
                ],),
                Row(children: [
                  Text('RS ',style: TextStyle(fontSize: 21)),
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.5),
                          //     spreadRadius: 1,
                          //     blurRadius: 3,
                          //     offset: Offset(0, 2),
                          //   ),
                          // ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: wineDetails['rsScore'],
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Text(wineDetails['rsScore'].toInt().toString()),
                      ),
                    ],
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.leaderboard),
                  Text(wineDetails['rank'])
                ],),
                Row(children: [
                  Text('QP ',style: TextStyle(fontSize: 21)),
                  Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.5),
                            //     spreadRadius: 1,
                            //     blurRadius: 3,
                            //     offset: Offset(0, 2),
                            //   ),
                            // ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            width: wineDetails['qpScore'],
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Text(wineDetails['qpScore'].toInt().toString()),
                        ),
                      ],
                    ),
                ],),
                SizedBox(height: 8),
                Row(children: [
                  Text('Vintage(s)',style: TextStyle(fontSize: 25, color:Colors.black87)),
                ],),
                SizedBox(height: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < vintages.length; i++)
                      DefaultTextStyle(style: TextStyle(fontSize: 18, color:Colors.black87), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [Text(vintages[i]),],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.star),
                              Text(evaluations[i]),
                              Text('  '),
                              Icon(Icons.rule),
                              Text(scoreAvg[i]),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        child: tasting[i] == null 
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(vertical: 20),
 //                                               child: Center(
                                                  child: Text("No tasting notes for this vintage", softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
   //                                             ),
                                              )
                                            : Text(tasting[i], softWrap: true, style: TextStyle(fontSize: 20)),
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.notes),
                                tooltip: 'Show Tasting Notes',
                              ),
                            ],
                          ),
                        ],
                      ),
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
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }

  Future<List<Map<String, dynamic>>> _getWineDetails(String fullName, String wineryName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines2.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
      'SELECT Vintage, EvaluationAvg, ScoreAvg, Tasting, Grapes, AgingMonths, AgingType, Price FROM allwines WHERE FullName = ? AND WineryName = ? AND Entry = ?',
      [fullName, wineryName, 2],
    );

    return results.toList();
  }
}