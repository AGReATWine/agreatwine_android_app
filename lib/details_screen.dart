import 'package:flutter/material.dart';
import 'navigation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';

class WineDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> wineDetails;

  WineDetailsScreen(this.wineDetails);

  Future<List<Map<String, dynamic>>> _getWineDetails(String fullName, String wineryName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
      'SELECT Vintage, EvaluationAvg, ScoreAvg, Tasting, Grapes, AgingMonths, AgingType, Price FROM allwines WHERE FullName = ? AND WineryName = ? AND Entry = ?',
      [fullName, wineryName, 2],
    );

    return results.toList();
  }

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
            final pairing = details.map((detail) => detail['Pairing']).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${wineDetails['fullName']}',
                            style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDetailsWidget(wineDetails),
                  _buildPairingWidget(wineDetails),
                  _buildScoreWidget(wineDetails),
                  _buildVintageWidget(vintages, evaluations, scoreAvg, tasting, context),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }

  /// Builds the details section of the screen
  Widget _buildDetailsWidget(Map<String, dynamic> wineDetails) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.list, color: appColors.primaryDark),
                ),
                Text(
                  ' Details',
                  style: TextStyle(fontSize: 25, color: appColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 18, color: Colors.black87),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(0.35),
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
      ],
    );
  }

  Widget _buildPairingWidget(Map<String, dynamic> wineDetails) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.food_bank, color: appColors.primaryDark),
                ),
                Text(
                  ' Pairings',
                  style: TextStyle(fontSize: 25, color: appColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(wineDetails['pairing'].replaceAll(' – ', '\n'), style: TextStyle(fontSize: 18))
            ]
          ),
        ),
      ],
    );
  }

  /// Builds the score section of the screen
  Widget _buildScoreWidget(Map<String, dynamic> wineDetails) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.check_circle, color: appColors.primaryDark),
                ),
                Text(
                  ' Scores',
                  style: TextStyle(fontSize: 25, color: appColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text('RS ', style: TextStyle(fontSize: 21)),
                  _buildStack(
                    score: wineDetails['rsScore'],
                    color: Colors.blue,
                    height: 30,
                    width: 200,
                    iconColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.leaderboard),
                  ),
                  Text(wineDetails['rank']),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Text('QP ', style: TextStyle(fontSize: 21)),
                    _buildStack(
                      score: wineDetails['qpScore'],
                      color: Colors.green,
                      height: 30,
                      width: 200,
                      iconColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Returns a stacked widget to indicate the score
  Widget _buildStack({
    required double score,
    required Color color,
    required double height,
    required double width,
    required Color iconColor,
  }) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: score * 2,
            height: height,
            decoration: BoxDecoration(
              color: color,
            ),
          ),
        ),
        Positioned(
          top: 5, //magic number
          right: 2,
          child: Text(score.toInt().toString(),style:TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  /// Builds the vintage section of the screen
  Widget _buildVintageWidget(List vintages, List evaluations, List scoreAvg, List tasting, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: appColors.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.calendar_month, color: appColors.primaryDark),
                ),
                Text(
                  ' Vintage(s)',
                  style: TextStyle(fontSize: 25, color: appColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < vintages.length; i++)
                DefaultTextStyle(
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(vintages[i], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.star),
                              Text(evaluations[i]),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.rule),
                              Text(scoreAvg[i]),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    child: tasting[i] == null
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                        child: Text("No tasting notes for this vintage", softWrap: true, textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                                      ),
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
        ),
      ],
    );
  }
}