import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SingleWineTile extends StatelessWidget {
  final double fontSizeName = 19.0;
  final double fontSizeDesc = 17.0;
  final double fontSizeSymbol = 17.0;
  final Map<String, dynamic> result;

  //vars for secondLevel comparisons
  final bool isSecondLevel;
  final bool isThirdLevel;

  // static variable to store the height of the SingleWineTile widget
  static double tileHeight =
      0; // If you need to update this value outside the class, then you should reconsider its design.

  SingleWineTile(
      {required this.result,
      required this.isSecondLevel,
      required this.isThirdLevel});

  Future<int> _getWineCountForAppellation(String appellationName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'allwines43.db');
    final database = await openDatabase(path);

    final results = await database.rawQuery(
      'SELECT COUNT(*) FROM allwines WHERE AppellationName = ? AND Entry = ?',
      [appellationName, 1],
    );

    // Removed the database.close(); line
    return (results.first.values.first as num).toInt();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(isThirdLevel.toString());

    return SizedBox(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // calculate height of the SingleWineTile widget based on its content
          double contentHeight =
              (fontSizeName + (fontSizeDesc * 3) + ((fontSizeSymbol * 2)));
          double rsSectionWidth = constraints.maxWidth * 0.5;
          double qpSectionWidth = constraints.maxWidth * 0.5;
          double rsBarWidth = result['RS'] / 100 * rsSectionWidth;
          rsBarWidth = isThirdLevel
              ? result['RS3'] / 100 * rsSectionWidth
              : (isSecondLevel
                  ? result['RS2'] / 100 * rsSectionWidth
                  : rsBarWidth);
          double qpBarWidth = result['QP'] / 100 * qpSectionWidth;
          qpBarWidth = isThirdLevel
              ? result['QP3'] / 100 * qpSectionWidth
              : (isSecondLevel
                  ? result['QP2'] / 100 * qpSectionWidth
                  : qpBarWidth);
          contentHeight += rsSectionWidth > 0 ? 26 : 0;
          contentHeight += qpSectionWidth > 0 ? 26 : 0;
          //vars for second level
          final rankCalc = isThirdLevel
              ? result['RANK3']
              : (isSecondLevel ? result['RANK2'] : result['RANK']);

          // update tileHeight with the actual calculated height
          tileHeight = 173;
          return Container(
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      result['FullName'],
                      style: TextStyle(
                          fontSize: fontSizeName, color: utils.primaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text('${result['WineryName']} | ',
                                style: TextStyle(
                                    fontSize: fontSizeDesc,
                                    fontWeight: FontWeight.bold)),
                            Expanded(
                              child: Text(
                                  '${result['AppellationLevel']} ${result['AppellationName']} | ${result['Region']}',
                                  style: TextStyle(fontSize: fontSizeDesc),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50, // adjust the value as needed
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
                        rsSectionWidth > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      isThirdLevel
                                          ? 'RS³ '
                                          : (isSecondLevel ? 'RS² ' : 'RS '),
                                      style:
                                          TextStyle(fontSize: fontSizeSymbol)),
                                  Stack(
                                    children: [
                                      Container(
                                        width: rsSectionWidth,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: rsBarWidth,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: Utils.getScoreColor(
                                                  ((result['RS']) -
                                                          rankCalc +
                                                          1) /
                                                      result['RS'] *
                                                      100),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade500,
                                                  spreadRadius: 0,
                                                  blurRadius: 0,
                                                  offset: Offset(1,
                                                      0.5), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 1,
                                        child: Text(
                                            result['RS'].toInt().toString(),
                                            style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0, 0),
                                                  blurRadius: 10.0,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.leaderboard,
                                      color: utils.iconsColor,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color: Colors.grey,
                                            blurRadius: 1.0,
                                            offset: Offset(.5, .5))
                                      ]),
                                  FutureBuilder<int>(
                                    future: _getWineCountForAppellation(
                                        result['AppellationName']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (snapshot.hasData) {
                                        return Row(
                                          children: [
                                            Text(
                                              '${result['RANK'].toInt()}/',
                                              style: TextStyle(
                                                  fontSize: fontSizeSymbol),
                                            ),
                                            Text(
                                              '${snapshot.data}',
                                              style: TextStyle(
                                                  fontSize: fontSizeSymbol - 3),
                                            ),
                                          ],
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        return CircularProgressIndicator(); // or a small sized box if you don't want a loader here.
                                      }
                                    },
                                  ),
                                  Icon(Icons.star,
                                      color: utils.iconsColor,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color: Colors.grey,
                                            blurRadius: 1.0,
                                            offset: Offset(.5, .5))
                                      ]),
                                  Text(result['EvaluationAvg'],
                                      style:
                                          TextStyle(fontSize: fontSizeSymbol))
                                ],
                              )
                            : SizedBox(),
                        SizedBox(height: 6),
                        qpSectionWidth > 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      isThirdLevel
                                          ? 'QP³ '
                                          : (isSecondLevel ? 'QP² ' : 'QP '),
                                      style:
                                          TextStyle(fontSize: fontSizeSymbol)),
                                  Stack(
                                    children: [
                                      Container(
                                        width: qpSectionWidth,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Container(
                                          width: qpBarWidth,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Utils.getScoreColor(
                                                ((result['QP']) -
                                                        result['QPRANK'] +
                                                        1) /
                                                    result['QP'] *
                                                    100),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade500,
                                                spreadRadius: 0,
                                                blurRadius: 0,
                                                offset: Offset(1,
                                                    0.5), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 1,
                                        child: Text(
                                          result['QP'].toInt().toString(),
                                          style: TextStyle(
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(0, 0),
                                                blurRadius: 10.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.euro,
                                      color: utils.iconsColor,
                                      shadows: <Shadow>[
                                        Shadow(
                                            color: Colors.grey,
                                            blurRadius: 1.0,
                                            offset: Offset(.5, .5))
                                      ]),
                                  Text('${result['Price'].toInt()}',
                                      style: TextStyle(
                                        fontSize: fontSizeSymbol,
                                      )),
                                ],
                              )
                            : SizedBox(),
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
                        'rs2Score': result['RS2'],
                        'rs3Score': result['RS3'],
                        'qpScore': result['QP'],
                        'qp2Score': result['QP2'],
                        'qp3core': result['QP'],
                        'rank': result['RANK'],
                        'rank2': result['RANK2'],
                        'rank3': result['RANK3'],
                        'qprank': result['QPRANK'],
                        'price': result['Price'],
                        'slc': result['SLC'],
                        'tlc': result['TLC'],
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WineDetailsScreen(wineDetails),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
