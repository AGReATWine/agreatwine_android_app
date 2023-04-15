import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'navigation.dart';
import 'search_screen.dart';
import 'edit_data.dart';

class CellarWineDetails extends StatefulWidget {
  final Map<String, dynamic> row;

  CellarWineDetails({Key? key, required this.row}) : super(key: key);

  @override
  _CellarWineDetailsState createState() => _CellarWineDetailsState();
}

class _CellarWineDetailsState extends State<CellarWineDetails> {
  final TextEditingController _searchController = TextEditingController();
  late Map<String, dynamic> _rowData;

  @override
  void initState() {
    super.initState();
    _rowData = widget.row; // Initialize _rowData with the value of row
  }

  Future<Map<String, dynamic>> fetchData() async {
    final db = await openDatabase(join(await getDatabasesPath(), 'mycellar.db'));

    final List<Map<String, dynamic>> wines = await db.query(
      'mycellar',
      where: "ref = ?",
      whereArgs: [_rowData['ref']],
    );
    
    return wines.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_rowData['cFullName'].toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,          
          children: [
            Text('Winery: ${_rowData['cWinery'].toString()}'),
            const SizedBox(height: 8),
            Text('Appellation: ${_rowData['cAppellationName'].toString()}'),
            const SizedBox(height: 8),
            Text('Vintage: ${_rowData['cVintage'].toString()}'),
            const SizedBox(height: 8),
            Text('Grapes: ${_rowData['cGrapes'].toString()}'),
            const SizedBox(height: 8),
            Text('Region: ${_rowData['cRegion'].toString()}'),
            const SizedBox(height: 8),
            Text('Price: ${_rowData['cPrice'].toString()}'),
            const SizedBox(height: 8),
            Text('Drinking year: ${_rowData['cDrinkingYear'].toString()}'),
            const SizedBox(height: 8),
            const Text('Tasting notes:'),
            Text(_rowData['cTastingNotes'].toString()),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _searchController.text =
                        _rowData['cFullName'].toString();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(
                            controller: _searchController,
                            isComingFromCellarWineDetails: true),
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                  tooltip: 'Search this wine in the database',
                ),
                GestureDetector(
                  onTap: () async {
                    final updatedRow = await editData(context, _rowData, true);
                    final fetchedData = await fetchData();
                    setState(() {
                      _rowData = fetchedData; // assign the updated value to _rowData
                    });
                  },
                  child: const Icon(Icons.edit)
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AGreatBottomNavigationBar(),
    );
  }
}