import 'package:flutter/material.dart';
import 'navigation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'appellation.dart';
import 'winery.dart';

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
                  Text("test")
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

}
