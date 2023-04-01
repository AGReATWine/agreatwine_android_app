import 'package:flutter/material.dart';
import 'search_results.dart';
import 'details_screen.dart';

class SingleWineTile extends StatelessWidget {
  double fontSizeName = 19.0;
  double fontSizeDesc = 17.0;
  double fontSizeSymbol = 17.0;
  final Map<String, dynamic> result;
  
  // static variable to store the height of the SingleWineTile widget
  static double tileHeight = 0;

  SingleWineTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // calculate height of the SingleWineTile widget based on its content
          double contentHeight = (fontSizeName + 40 + ((fontSizeSymbol * 2) + 2)) ;
          double rsSectionWidth = constraints.maxWidth * 0.6;
          double qpSectionWidth = constraints.maxWidth * 0.6;
          double rsBarWidth = result['RS'] / 100 * rsSectionWidth;
          double qpBarWidth = result['QP'] / 100 * qpSectionWidth;
          contentHeight += rsSectionWidth > 0 ? 26 : 0;
          contentHeight += qpSectionWidth > 0 ? 26 : 0;

          // update tileHeight with the actual calculated height
          tileHeight = contentHeight;  
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: ListTile(
              title: Text(result['FullName'],style: TextStyle(fontSize: fontSizeName,),maxLines: 1,overflow: TextOverflow.ellipsis,),
              subtitle: Column(
                children: [
                      Row(children: [
                        Text('${result['WineryName']} | ${result['AppellationLevel']} ${result['AppellationName']} | ${result['Region']}',style: TextStyle(fontSize: fontSizeDesc)),
                      ],),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40, // adjust the value as needed
                            child: Text(
                              '${result['Pairing']}',
                              style: TextStyle(fontSize: fontSizeDesc),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  rsSectionWidth > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('RS ',style: TextStyle(fontSize: fontSizeSymbol)),
                      Stack(
                        children: [
                          Container(
                            width: rsSectionWidth,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: rsBarWidth,
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
                  ) : SizedBox(),
                  SizedBox(height: 6),
                  qpSectionWidth > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('QP ',style: TextStyle(fontSize: fontSizeSymbol,)),
                      Stack(
                        children: [
                          Container(
                            width: qpSectionWidth,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: qpBarWidth,
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
                  ) : SizedBox(),
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
                'pairing': result['Pairing'],
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
            ),
          );
        },
      ),
    );
  }
}