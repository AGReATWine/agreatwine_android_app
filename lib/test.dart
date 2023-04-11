import 'package:flutter/material.dart';
import 'navigation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'appellation.dart';
import 'winery.dart';
import 'dart:math' as math;
import 'package:syncfusion_flutter_charts/charts.dart';

class PriceChartData {
  PriceChartData(this.year, this.priceWine);
  final String year;
  final double priceWine;
}

final xxYears = List.generate(7, (index) => (2017 + index).toString());


class WineDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> wineDetails;
  final ratingYearsMedianPriceList = [];


  WineDetailsScreen(this.wineDetails);

  Future<List<Map<String, dynamic>>> _getWineDetails(String fullName, String wineryName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines8.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
        'SELECT AppellationNAme, RatingYear, Vintage, EvaluationAvg, ScoreAvg, Tasting, Grapes, AgingMonths, AgingType, Price FROM allwines WHERE FullName = ? AND WineryName = ? AND Entry = ?',
      [fullName, wineryName, 2],
    );

    final appellationName = results[0]['AppellationName'];
    final appellationEntries = await database.query(
      'allwines',
      where: 'AppellationName = ? AND Entry = ?',
      whereArgs: [appellationName, 2],
    );

  final Map<double, List<double>> ratingYearToPriceMap = {};
  appellationEntries.forEach((entry) {
    final double ratingYear = entry['RatingYear'] as double;
    final double priceAvg = entry['Price'] as double;
    if (ratingYearToPriceMap.containsKey(ratingYear)) {
      ratingYearToPriceMap[ratingYear]!.add(priceAvg);
    } else {
      ratingYearToPriceMap[ratingYear] = [priceAvg];
    }
  });
  final List<Map<String, dynamic>> ratingYearMedianPriceList = [];
  ratingYearToPriceMap.forEach((ratingYear, priceList) {
      priceList.sort();
      final double medianPrice = priceList.length % 2 == 0
          ? (priceList[priceList.length ~/ 2] + priceList[(priceList.length ~/ 2) - 1]) / 2
          : priceList[(priceList.length ~/ 2)];
      ratingYearsMedianPriceList.add({'RatingYear': ratingYear, 'MedianPrice': medianPrice});
    });

    final ratingYearsList = results.map((result) =>
      PriceChartData(result['RatingYear'].toString(), result['Price'] as double)
    ).toList();

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
            final priceWine = details.map((detail) => detail['Price'] as double).toList();
            final pairing = details.map((detail) => detail['Pairing']).toList();
            final xYears = details.map((detail) => detail['RatingYear']).toList();
            
            final ratingYearsList = priceWine
              .asMap()
              .entries
              .map((entry) => PriceChartData(xYears[entry.key].toInt().toString(), entry.value))
              .toList();


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
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDetailsWidget(context, wineDetails),
                  _buildPairingWidget(wineDetails),
                  _buildScoreWidget(wineDetails),
                  _buildVintageWidget(vintages, evaluations, scoreAvg, tasting, context),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: utils.primaryLight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(Icons.list, color: utils.primaryDark),
                          ),
                          Text(
                            ' Price Charts',
                            style: TextStyle(fontSize: 25, color: utils.primaryDark, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SfCartesianChart(
                     primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Rating Year'),
                  ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: 200,
                      labelFormat: '{value}€'
                    ),
                    legend: Legend(isVisible: true, position: LegendPosition.top),
                    series: <ChartSeries>[
                      SplineSeries<PriceChartData, String>(
                        dataSource: ratingYearsMedianPriceList.map((data) => PriceChartData(data['RatingYear'].toInt().toString(), data['MedianPrice'] as double)).toList(),
                        xValueMapper: (PriceChartData year, _) => year.year,
                        yValueMapper: (PriceChartData price, _) => price.priceWine,
                        name: 'Avg Appellation Price',
                        dataLabelSettings: DataLabelSettings(isVisible: false),
                      ),
                      SplineSeries<PriceChartData, String>(
                        dataSource: ratingYearsList,
                        xValueMapper: (PriceChartData year, _) => year.year,
                        yValueMapper: (PriceChartData price, _) => price.priceWine,
                        name: wineDetails['fullName'],
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
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
  Widget _buildDetailsWidget(BuildContext context, Map<String, dynamic> wineDetails) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: utils.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.list, color: utils.primaryDark),
                ),
                Text(
                  ' Details',
                  style: TextStyle(fontSize: 25, color: utils.primaryDark, fontWeight: FontWeight.bold),
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
                    Row(
                      children: [
                        Text('${wineDetails['wineryName']}' '  '),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WineryEntriesScreen(
                                  wineryName: wineDetails['wineryName'],
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.link,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                TableRow(
                  children: [
                    Text('Appellation'),
                    Row(
                      children: [
                        Expanded(
                          child: Text('${wineDetails['appellationLevel']}' ' ' '${wineDetails['appellationName']}' '  ', 
                          softWrap: true),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EntriesScreen(
                                  appellationName: wineDetails['appellationName'],
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.link,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
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
            color: utils.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.food_bank, color: utils.primaryDark),
                ),
                Text(
                  ' Pairings',
                  style: TextStyle(fontSize: 25, color: utils.primaryDark, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(wineDetails['pairing'].replaceAll(' – nd', '').replaceAll(' – ', '\n'), style: TextStyle(fontSize: 18))
            ]
          ),
        ),
      ],
    );
  }

  Future<int> _getRank(String appellationName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines8.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
      'SELECT COUNT(*) FROM allwines WHERE AppellationName = ? AND Entry = ?',
      [wineDetails['appellationName'], 1],
    );

     return (results.first.values.first as num).toInt();
  }
  /// Builds the score section of the screen
  Widget _buildScoreWidget(Map<String, dynamic> wineDetails) {
    Color _getScoreColor(double score) {
      if (score > 90) {
        return Colors.blue;
      } else if (score >= 75 && score <= 90) {
        return Colors.green;
      } else if (score >= 26 && score <= 74) {
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: utils.primaryLight,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Container(
                child: Icon(Icons.check_circle, color: utils.primaryDark),
              ),
              Text(
                ' Scores',
                style: TextStyle(fontSize: 25, color: utils.primaryDark, fontWeight: FontWeight.bold),
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
                Text(' '),
                FutureBuilder<int>(
                  future: _getRank(wineDetails['appellationName']),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Text(wineDetails['rank'], style: TextStyle(color: _getScoreColor(((int.parse(snapshot.data.toString()) - int.parse(wineDetails['rank']) + 1) / int.parse(snapshot.data.toString()) * 100)), fontWeight: FontWeight.bold, fontSize: 20)),
                          Text('/' + snapshot.data.toString())
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
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
            color: utils.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.calendar_month, color: utils.primaryDark),
                ),
                Text(
                  ' Vintage(s)',
                  style: TextStyle(fontSize: 25, color: utils.primaryDark, fontWeight: FontWeight.bold),
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
                                    padding: EdgeInsets.all(16.0), // add padding
                                    child: tasting[i] == null
                                      ? Text(
                                            "No tasting notes for this vintage", 
                                            softWrap: true, 
                                            textAlign: TextAlign.center, 
                                            style: TextStyle(fontSize: 20)
                                          )
                                      : Text(
                                          tasting[i], 
                                          softWrap: true, 
                                          style: TextStyle(fontSize: 20)
                                        ),
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
