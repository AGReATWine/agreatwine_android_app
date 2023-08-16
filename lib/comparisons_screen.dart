import 'package:flutter/material.dart';
import 'main.dart';
import 'translations.dart';
import 'appellation_docg.dart';
import 'appellation_doc.dart';
import 'appellation_second.dart';
import 'appellation_third.dart';

class ComparisonsScreen extends StatefulWidget {
  final int docgIndex;
  final int docIndex;
  final int slevelIndex;
  final int tlevelIndex;

 ComparisonsScreen({required this.docgIndex, required this.docIndex, required this.slevelIndex, required this.tlevelIndex});

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

  @override
  Widget build(BuildContext context) {
    var translations = Translations.of(context);
    return Container(
      color: utils.primaryLight,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => Navigator.push(context, routes[0]),
            child: Text('DOCG', style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              decoration: widget.docgIndex == 1 ? TextDecoration.underline : null, 
              decorationColor: Colors.white, 
              decorationThickness: 3,
              decorationStyle: TextDecorationStyle.double
            ))
          ),
          InkWell(
            onTap: () => Navigator.push(context, routes[1]),
            child: Text('DOC', style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              decoration: widget.docIndex == 1 ? TextDecoration.underline : null, 
              decorationColor: Colors.white, 
              decorationThickness: 3,
              decorationStyle: TextDecorationStyle.double
            ))
          ),
          InkWell(
            onTap: () => Navigator.push(context, routes[2]),
            child: Text('Varieties', style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              decoration: widget.slevelIndex == 1 ? TextDecoration.underline : null, 
              decorationColor: Colors.white, 
              decorationThickness: 3,
              decorationStyle: TextDecorationStyle.double
            ))
          ),
          InkWell(
            onTap: () => Navigator.push(context, routes[3]),
            child: Text('Regional', style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              decoration: widget.tlevelIndex == 1 ? TextDecoration.underline : null, 
              decorationColor: Colors.white, 
              decorationThickness: 3,
              decorationStyle: TextDecorationStyle.double
            ))
          ),
        ],
      ),
    );
  }
}