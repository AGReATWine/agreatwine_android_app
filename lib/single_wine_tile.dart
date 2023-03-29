import 'package:flutter/material.dart';
import 'search_results.dart';
import 'details_screen.dart';

class SingleWineTile extends StatelessWidget {
  double fontSizeName = 19.0;
  double fontSizeDesc = 17.0;
  double fontSizeSymbol = 17.0;
  final Map<String, dynamic> result;

  SingleWineTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
        child: ListTile(
        title: Text(result['FullName'],style: TextStyle(fontSize: fontSizeName,)),
        subtitle: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('${result['WineryName']} | ${result['AppellationLevel']} ${result['AppellationName']} | ${result['Region']}',style: TextStyle(fontSize: fontSizeDesc)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('RS ',style: TextStyle(fontSize: fontSizeSymbol)),
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.5),
                        //     spreadRadius: 1,
                        //     blurRadius: 3,
                        //     offset: Offset(0, 2),
                        //   ),
                        // ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: result['RS'],
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Text(result['RS'].toInt().toString()),
                    ),
                  ],
                ),
                SizedBox(width: 6),
                Icon(Icons.leaderboard),
                Text(result['RANK'],style: TextStyle(fontSize: fontSizeSymbol)),
                Icon(Icons.star),
                Text(result['EvaluationAvg'],style: TextStyle(fontSize: fontSizeSymbol))
              ],
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('QP ',style: TextStyle(fontSize: fontSizeSymbol,)),
                Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: result['QP'],
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Text(result['QP'].toInt().toString()),
                    ),
                  ],
                ),
                SizedBox(width: 6),
                Icon(Icons.euro),
                Text('${result['Price']}',style: TextStyle(fontSize: fontSizeSymbol,)),
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
          'grapes': result['Grapes'],
          'agingMonths': result['AgingMonths'],
          'agingType': result['AgingType'],
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
      )
    );
  }
}