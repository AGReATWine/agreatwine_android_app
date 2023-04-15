import 'package:flutter/material.dart';
import 'search_results.dart';
import 'details_screen.dart';
import 'main.dart';



class SingleWineTile extends StatelessWidget {
  double fontSizeName = 19.0;
  double fontSizeDesc = 17.0;
  double fontSizeSymbol = 17.0;
  final Map<String, dynamic> result;
  //vars for secondLevel comparisons
  final bool isSecondLevel;
  final bool isThirdLevel;
  
  // static variable to store the height of the SingleWineTile widget
  static double tileHeight = 0;

  SingleWineTile({required this.result, required this.isSecondLevel, required this.isThirdLevel});



  @override
  Widget build(BuildContext context) {
  debugPrint(isThirdLevel.toString());
    
    return SizedBox(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // calculate height of the SingleWineTile widget based on its content
          double contentHeight = (fontSizeName + (fontSizeDesc * 3) + ((fontSizeSymbol * 2))) ;
          double rsSectionWidth = constraints.maxWidth * 0.6;
          double qpSectionWidth = constraints.maxWidth * 0.6;
          double rsBarWidth = result['RS'] / 100 * rsSectionWidth;
          rsBarWidth = isThirdLevel ?
            result['RS3'] / 100 * rsSectionWidth : (isSecondLevel ? result['RS2'] / 100 * rsSectionWidth :
            rsBarWidth);
          double qpBarWidth = result['QP'] / 100 * qpSectionWidth;
          qpBarWidth = isThirdLevel ?
            result['QP3'] / 100 * qpSectionWidth : (isSecondLevel ? result['QP2'] / 100 * qpSectionWidth :
            qpBarWidth);
          contentHeight += rsSectionWidth > 0 ? 26 : 0;
          contentHeight += qpSectionWidth > 0 ? 26 : 0;
          //vars for second level
          final rankCalc = isThirdLevel ?
                result['RANK3'] : (isSecondLevel ? result['RANK2'] :
                result['RANK']);  

          // update tileHeight with the actual calculated height
          tileHeight = 173;  
          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.5))
            ),
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(result['FullName'],style: TextStyle(fontSize: fontSizeName, color: utils.primaryLight),maxLines: 1,overflow: TextOverflow.ellipsis,),
                subtitle: Column(
                  children: [
                    Row(children: [
                      Text('${result['WineryName']} | ',style: TextStyle(fontSize: fontSizeDesc, fontWeight: FontWeight.bold)),
                      Expanded(
                      child: Text('${result['AppellationLevel']} ${result['AppellationName']} | ${result['Region']}',style: TextStyle(fontSize: fontSizeDesc), maxLines: 1, overflow: TextOverflow.ellipsis),
                      )
                    ],),
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
                    rsSectionWidth > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        isThirdLevel 
                            ? 'RS³ ' : (isSecondLevel ? 'RS² ' 
                            : 'RS '), 
                        style: TextStyle(fontSize: fontSizeSymbol)
                      ),
                      Stack(
                        children: [
                          Container(
                            width: rsSectionWidth,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5),
                              
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: rsBarWidth,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Utils.getScoreColor(((rsBarWidth) - rankCalc + 1) / rsBarWidth * 100),
                                  boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    spreadRadius: 0,
                                    blurRadius: 0,
                                    offset: Offset(1, 0.5), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 1,
                            child: Text(result['RS'].toInt().toString(), style: TextStyle(
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
                      Icon(Icons.leaderboard, color: utils.iconsColor, shadows: <Shadow>[Shadow(color: Colors.grey, blurRadius: 1.0, offset: Offset(.5, .5))]),
                      Text(result['RANK'].toInt().toString() + ' ',style: TextStyle(fontSize: fontSizeSymbol)),
                      Icon(Icons.star, color: utils.iconsColor, shadows: <Shadow>[Shadow(color: Colors.grey, blurRadius: 1.0, offset: Offset(.5, .5))]),
                      Text(result['EvaluationAvg'],style: TextStyle(fontSize: fontSizeSymbol))
                    ],
                  ) : SizedBox(),
                  SizedBox(height: 6),
                    qpSectionWidth > 0 ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          isThirdLevel 
                              ? 'QP³ ' : (isSecondLevel ? 'QP² ' 
                              : 'QP '), 
                          style: TextStyle(fontSize: fontSizeSymbol)
                        ),
                        Stack(
                          children: [
                            Container(
                              width: qpSectionWidth,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                width: qpBarWidth,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Utils.getScoreColor(((qpBarWidth) - result['QPRANK'] + 1) / qpBarWidth * 100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: Offset(1, 0.5), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 1,
                              child: Text(result['QP'].toInt().toString(), style: TextStyle(
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 10.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),),
                            ),
                          ],
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.euro, color: utils.iconsColor, shadows: <Shadow>[Shadow(color: Colors.grey, blurRadius: 1.0, offset: Offset(.5, .5))]),
                        Text('${result['Price'].toInt()}',style: TextStyle(fontSize: fontSizeSymbol,)),
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
          );
        },
      ),
    );
  }
}