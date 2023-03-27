import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'details_screen.dart';

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

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Search'),
            onPressed: () async {
              String query = _searchController.text;
              _searchResults = await _search(query);
              setState(() {});
            },
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _search(String query) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines2.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
        'SELECT * FROM allwines WHERE FullName LIKE ? OR WineryName LIKE ?',
        ['%$query%', '%$query%']);

    return results;
  }

  Widget _buildSearchResults() {
    final filteredResults =
        _searchResults.where((result) => result['Entry'] == "1").toList();
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