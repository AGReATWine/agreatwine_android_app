import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'details_screen.dart';
import 'search_results.dart';
import 'search_screen.dart';
import 'navigation.dart';


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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AGReaTWine'),
      ),
      drawer: const AGreatDrawer(),
      body: Center(
        child: FlutterLogo(
          size: 200,
        ),
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH(currentIndex: _currentIndex),
    );
  }
}
