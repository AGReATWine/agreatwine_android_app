import 'package:flutter/material.dart';
import 'navigation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'entries_screen.dart';
import 'appellation_third.dart';
import 'winery.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class WineDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> wineDetails;

  late List<double> appellationPricesList = [];
  late List<double> slcList = [];
  late List<double> tlcList = [];

  late List<Map<String, dynamic>> medianPricesList = [];

  WineDetailsScreen(this.wineDetails);

  Future<List<Map<String, dynamic>>> _getWineDetails(String fullName, String wineryName) async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'allwines41.db');
      final database = await openDatabase(path);

      final results = await database.rawQuery(
        'SELECT AppellationName, RatingYear, Vintage, EvaluationAvg, ScoreAvg, Tasting, Grapes, AgingMonths, AgingType, SLC, TLC, Price FROM allwines WHERE FullName = ? AND WineryName = ? AND Entry = ?',
        [fullName, wineryName, 2],
      );

      //all appellation wines
      final appellationName = results[0]['AppellationName'];
      final appellationEntries = await database.query(
        'allwines',
        where: 'AppellationName = ? AND Entry = ?',
        whereArgs: [appellationName, 2],
      );
      //array of prices
      appellationPricesList = appellationEntries.map<double>((entry) => entry['Price'] as double).toList();

      // //all slc wines
      final slcName = results[0]['SLC'];
      final slcEntries = await database.query(
        'allwines',
        where: 'SLC = ? AND Entry = ?',
        whereArgs: [slcName, 1],
      );
      //array of slc ranks
      if (results[0]['SLC'] != '') {
        slcList = slcEntries.map<double>((entry) => entry['Price'] as double).toList();
      } else {
        slcList;
      }

      // //all tlc wines
      final tlcName = results[0]['TLC'];
      final tlcEntries = await database.query(
        'allwines',
        where: 'TLC = ? AND Entry = ?',
        whereArgs: [tlcName, 1],
      );
      //array of slc ranks
      if (results[0]['TLC'] != '') {
        tlcList = tlcEntries.map<double>((entry) => entry['Price'] as double).toList();
      } else {
        tlcList;
      }


      //pair RatingYear-Price
      final Map<double, List<double>> pairRatingsPrice = {};

      for (final entry in appellationEntries) {
        final ratingYear = entry['RatingYear'] as double;
        final price = entry['Price'] as double;
        pairRatingsPrice.putIfAbsent(ratingYear, () => []).add(price);
      }

      medianPricesList = [];

      for (final ratingYear in pairRatingsPrice.keys) {
    final pricesList = pairRatingsPrice[ratingYear]!;
    pricesList.sort();
    final medianIndex = pricesList.length ~/ 2;
    final medianPrice = pricesList.length.isOdd
        ? pricesList[medianIndex]
        : (pricesList[medianIndex - 1] + pricesList[medianIndex]) / 2;
    medianPricesList.add({'RatingYear': ratingYear, 'MedianPrice': medianPrice});
  }
  medianPricesList.sort((a, b) => a['RatingYear'].compareTo(b['RatingYear']));

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
            final slc = details.map((detail) => detail['SLC']).toList();
            final tlc = details.map((detail) => detail['TLC']).toList();

            final xAxisYears = List.generate(7, (index) => (2017 + index));
            final xMin = xAxisYears.reduce((value, element) => value < element ? value : element);
            final xMax = xAxisYears.reduce((value, element) => value > element ? value : element);

            final yMin = appellationPricesList.reduce((value, element) => value < element ? value : element);
            final yMax = appellationPricesList.reduce((value, element) => value > element ? value : element);

            final wineMax = price.reduce((value, element) => value > element ? value : element);
            final wineMin = price.reduce((value, element) => value < element ? value : element);

            final slcCount = slcList.length;
            final tlcCount = tlcList.length;


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
                  _buildDetailsWidget(context, wineDetails),
                  _buildPairingWidget(wineDetails),
                  _buildScoreWidget(wineDetails, slcCount, tlcCount),
                  _buildVintageWidget(vintages, evaluations, scoreAvg, tasting, context),
                  _buildChartWidget(xMin.toDouble(), xMax.toDouble(), yMin.toDouble(), yMax.toDouble(), wineMin, wineMax, details),
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

  Widget _buildChartWidget(double xMin, double xMax, double yMin, double yMax,
      wineMin, wineMax, List<Map<String, dynamic>> details) {
    
    String fullName = wineDetails['fullName'];
    final String legendLabel; 
    if (fullName.length > 10) {
      legendLabel = fullName.substring(0, 10);
    } else {
      legendLabel = fullName;
    }
    return Column(children: [
      Container(    
        margin: EdgeInsets.only(top: 15, bottom: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Container(
                child: Icon(Icons.euro, color: utils.primaryLight),
              ),
              Text(
                ' Prices Chart',
                style: TextStyle(
                    fontSize: 25,
                    color: utils.primaryLight,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SfCartesianChart(
          primaryXAxis:
              NumericAxis(minimum: xMin.toDouble(), maximum: xMax.toDouble()),
          primaryYAxis: NumericAxis(
              minimum: yMin > wineMin ? wineMin : yMin,
              maximum: yMax > wineMax ? yMax : wineMax,
              labelFormat: '{value}€'),
          legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap),
          series: <SplineSeries<dynamic, double>>[
            SplineSeries<dynamic, double>(
              dataSource: medianPricesList,
              width: 1,
              xValueMapper: (data, _) => data['RatingYear'],
              yValueMapper: (data, _) => data['MedianPrice'],
              name: 'Median Appellation Price',
              dataLabelSettings: DataLabelSettings(isVisible: false),
            ),
            SplineSeries<dynamic, double>(
              dataSource: details,
              xValueMapper: (data, _) => data['RatingYear'],
              yValueMapper: (data, _) => data['Price'],
              name: legendLabel,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(
                isVisible: true
              ),
            )
          ],
        ),
      )
    ]);
  }

  /// Builds the details section of the screen
  Widget _buildDetailsWidget(BuildContext context, Map<String, dynamic> wineDetails) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.list, color: utils.primaryLight),
                ),
                Text(
                  ' Details',
                  style: TextStyle(fontSize: 25, color: utils.primaryLight, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.shade600))
          ),
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 15),
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
                        Text('${wineDetails['appellationLevel']}' ' ' '${wineDetails['appellationName']}' '  ', 
                          softWrap: true),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EntriesScreen(
                                  level: wineDetails['appellationName'], levelName: 'DOC'
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
                if (wineDetails['slc'] != "")
                TableRow(
                  children: [
                    Text('Varieties²'),
                    Row(
                      children: [
                        Text('${wineDetails['slc']} ', softWrap: true),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntriesScreen(
                                  level: wineDetails['slc'], levelName: 'SLC'
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
                if (wineDetails['tlc'] != "")
                TableRow(
                  children: [
                    Text('Regional³ Comparison'),
                    Row(
                      children: [
                        Text('${wineDetails['tlc']} ', softWrap: true),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntriesScreen(
                                  level: wineDetails['tlc'], levelName: 'TLC'
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
                    Text('${wineDetails['agingType']} | ${wineDetails['agingMonths']} months'),
                  ],
                ),
                TableRow(
                  children: [
                    Text('Price'),
                    Text('${wineDetails['price'].toInt()}' '€'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget _buildPairingWidget(Map<String, dynamic> wineDetails) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.food_bank, color: utils.primaryLight),
                ),
                Text(
                  ' Pairings',
                  style: TextStyle(fontSize: 25, color: utils.primaryLight, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.shade600))
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    final path = join(dbPath, 'allwines41.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
      'SELECT COUNT(*) FROM allwines WHERE AppellationName = ? AND Entry = ?',
      [wineDetails['appellationName'], 1],
    );

     return (results.first.values.first as num).toInt();
  }
  /// Builds the score section of the screen
  Widget _buildScoreWidget(Map<String, dynamic> wineDetails, slcCount, tlcCount) {
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: 10, bottom: 0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            children: [
              Container(
                child: Icon(Icons.check_circle, color: utils.primaryLight),
              ),
              Text(
                ' Scores',
                style: TextStyle(fontSize: 25, color: utils.primaryLight, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.shade600))
          ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                FutureBuilder<int>(
                  future: _getRank(wineDetails['appellationName']),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Text('RS  ', style: TextStyle(fontSize: 21)),
                          _buildStack(
                            score: wineDetails['rsScore'],
                            color: Utils.getScoreColor(((wineDetails['rsScore'] - wineDetails['rank'] + 1) / wineDetails['rsScore'] * 100)),
                            height: 20,
                            width: 200,
                            iconColor: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.leaderboard, color: utils.iconsColor),
                          ),
                          Text(' '),
                          Text(wineDetails['rank'].toInt().toString(), style: TextStyle(color: Utils.getScoreColor(((wineDetails['rsScore'] - wineDetails['rank'] + 1) / wineDetails['rsScore'] * 100)), fontWeight: FontWeight.bold, fontSize: 20)),
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
            if (wineDetails['slc'] != "")
            Row(
              children: [
                FutureBuilder<int>(
                  future: _getRank(wineDetails['slc']),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Text('RS² ', style: TextStyle(fontSize: 21)),
                          _buildStack(
                            score: wineDetails['rs2Score'],
                            color: Utils.getScoreColor(((wineDetails['rs2Score'] - wineDetails['rank2'] + 1) / wineDetails['rs2Score'] * 100)),
                            height: 20,
                            width: 200,
                            iconColor: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.leaderboard, color: utils.iconsColor),
                          ),
                          Text(' '),
                          Text(wineDetails['rank2'].toInt().toString(), style: TextStyle(color: Utils.getScoreColor(((wineDetails['rs2Score'] - wineDetails['rank2'] + 1) / wineDetails['rs2Score'] * 100)), fontWeight: FontWeight.bold, fontSize: 20)),
                          Text('/' + slcCount.toString())
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
            if (wineDetails['tlc'] != "")
            Row(
              children: [
                FutureBuilder<int>(
                  future: _getRank(wineDetails['tlc']),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Text('RS³ ', style: TextStyle(fontSize: 21)),
                          _buildStack(
                            score: wineDetails['rs3Score'],
                            color: Utils.getScoreColor(((wineDetails['rs3Score'] - wineDetails['rank3'] + 1) / wineDetails['rs3Score'] * 100)),
                            height: 20,
                            width: 200,
                            iconColor: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.leaderboard, color: utils.iconsColor),
                          ),
                          Text(' '),
                          Text(wineDetails['rank3'].toInt().toString(), style: TextStyle(color: Utils.getScoreColor(((wineDetails['rs3Score'] - wineDetails['rank3'] + 1) / wineDetails['rs3Score'] * 100)), fontWeight: FontWeight.bold, fontSize: 20)),
                          Text('/' + tlcCount.toString())
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
            Row(
              children: [
                FutureBuilder<int>(
                  future: _getRank(wineDetails['appellationName']),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Text('QP  ', style: TextStyle(fontSize: 21)),
                          _buildStack(
                            score: wineDetails['qpScore'],
                            color: Utils.getScoreColor(((wineDetails['qpScore'] - wineDetails['qprank'] + 1) / wineDetails['qpScore'] * 100)),
                            height: 20,
                            width: 200,
                            iconColor: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.leaderboard, color: utils.iconsColor),
                          ),
                          Text(' '),
                          Text(wineDetails['qprank'].toInt().toString(), style: TextStyle(color: Utils.getScoreColor(((wineDetails['qpScore'] - wineDetails['qprank'] + 1) / wineDetails['qpScore'] * 100)), fontWeight: FontWeight.bold, fontSize: 20)),
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
            borderRadius: BorderRadius.circular(5),
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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(1, 0.5), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(5)
            ),
          ),
        ),
        Positioned(
          top: 0, //magic number
          right: 2,
          child: Text(score.toInt().toString(),),
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
          margin: EdgeInsets.only(top: 10, bottom: 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  child: Icon(Icons.calendar_month, color: utils.primaryLight),
                ),
                Text(
                  ' Vintage(s)',
                  style: TextStyle(fontSize: 25, color: utils.primaryLight, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.5, color: Colors.grey.shade600))
          ),
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
                          Text(vintages[i].substring(0,4), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.star, color: utils.iconsColor, shadows: <Shadow>[Shadow(color: Colors.grey, blurRadius: 1.0, offset: Offset(.5, .5))]),
                              Text(evaluations[i]),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.rule, color: utils.iconsColor, shadows: <Shadow>[Shadow(color: Colors.grey, blurRadius: 1.0, offset: Offset(.5, .5))]),
                              Text(scoreAvg[i].replaceAll('.00', '')),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(16.0), // add padding
                                    child: tasting[i] == ''
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
                            icon: Icon(
                              Icons.notes, 
                              color: tasting[i] == '' ? Colors.grey : utils.iconsColor, 
                              shadows: <Shadow>[
                                Shadow(color: Colors.grey, blurRadius: 1.0, offset: Offset(.5, .5))
                              ]
                            ),
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