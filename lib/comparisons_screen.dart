import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'main.dart';
import 'translations.dart';
import 'navigation.dart';
import 'appellation_docg.dart';
import 'appellation_doc.dart';
import 'appellation_second.dart';
import 'appellation_third.dart';

class ComparisonsScreen extends StatefulWidget {
  @override
  _ComparisonsScreenState createState() => _ComparisonsScreenState();
}

class _ComparisonsScreenState extends State<ComparisonsScreen> {
  List<MaterialPageRoute> routes = [
    MaterialPageRoute(builder: (context) => DocgScreen()),
    MaterialPageRoute(builder: (context) => DocScreen()),
    MaterialPageRoute(builder: (context) => SlevelScreen()),
    MaterialPageRoute(builder: (context) => TlevelScreen()),
  ];

  int _currentIndex = 1;

  @override
Widget build(BuildContext context) {
  var translations = Translations.of(context);
  return GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          childAspectRatio: 4,
          children: [
            InkWell(
              onTap: () => Navigator.push(context, routes[0]),
              child: Text('DOCG', style: TextStyle(fontSize: 24))),
            InkWell(
              onTap: () => Navigator.push(context, routes[1]),
              child: Text('DOC', style: TextStyle(fontSize: 24))),
            InkWell(
              onTap: () => Navigator.push(context, routes[2]),
              child: Text('Vineyard', style: TextStyle(fontSize: 24))
            ),
            InkWell(
              onTap: () => Navigator.push(context, routes[3]),
              child: Text('Regional', style: TextStyle(fontSize: 24))
            ),
          ],
        );
}

}