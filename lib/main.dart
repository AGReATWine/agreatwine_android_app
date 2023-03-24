import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _copyDatabase();
  runApp(MyApp());
}

Future<void> _copyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'allwines2.db');

  // Check if the database file already exists
  final fileExists = await databaseExists(path);
  if (!fileExists) {
    // Copy the database from the assets folder to the device's local storage
    final data = await rootBundle.load('assets/allwines2.db');
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Search Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

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
      'SELECT Vintage, EvaluationAvg, ScoreAvg FROM allwines WHERE FullName = ? AND WineryName = ? AND Entry = ?',
      [fullName, wineryName, 2],
    );

    return results.toList();
  }
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildSearchResults(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          String query = _searchController.text;
          _searchResults = await _search(query);
          setState(() {});
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _search(String query) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines2.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery('SELECT * FROM allwines WHERE FullName LIKE ? OR WineryName LIKE ?', ['%$query%', '%$query%']);


    return results;
  }

  Widget _buildSearchResults() {
    final filteredResults = _searchResults.where((result) => result['Entry'] == "1").toList();
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
                  Text(result['RS'].toString()),
                  Text(' | Rank '),
                  Text(result['RANK']),
                  Text(' | '),
                  Text(result['Price']),
                  Text('€'),
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