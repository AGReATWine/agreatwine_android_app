import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'details_screen.dart';
import 'navigation.dart';
import 'search_results.dart';
import 'search_screen.dart';
import 'translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await copyDatabase();
  runApp(Agreatwine());
}



Future<void> copyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'allwines9.db');

  final fileExists = await databaseExists(path);
  if (!fileExists) {
    final data = await rootBundle.load('assets/allwines9.db');
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes);
  }
}

class Utils {
  Color primaryLight = Colors.red.shade800;
  Color primaryDark = Color(0xFF689F38);
  Color euroSymbol = Color(0xFF3E9C35);
  Color iconsColor = Colors.red.shade200;
  Color barYellow = Color(0xFFFEBD09);
  Color barRed = Color(0xFFF44336);
  Color barBlue = Color(0xFF1976D2);
  Color barGreen = Color(0xFF4CAF50);

  static Color getScoreColor(double score) {
    if (score > 90) {
      return utils.barBlue;
    } else if (score >= 75 && score <= 90) {
      return utils.barGreen;
    } else if (score >= 26 && score <= 74) {
      return utils.barYellow;
    } else {
      return utils.barRed;
    }
  }
}

final utils = Utils();

class Agreatwine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        const TranslationsDelegate(),
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('fr', ''),
      ],
      title: 'AGReATWine',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: utils.primaryLight
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var translations = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(translations.appTitle),
      ),
      body: Center(
        child: FlutterLogo(
          size: 200,
        ),
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            label: translations.home,
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: translations.list,
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: translations.search,
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}