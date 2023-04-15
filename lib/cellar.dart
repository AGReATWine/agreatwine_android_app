import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'cellar_wine_details.dart';
import 'navigation.dart';
import 'edit_data.dart';

class MyCellarScreen extends StatefulWidget {
  @override
  _MyCellarScreenState createState() => _MyCellarScreenState();
}

class _MyCellarScreenState extends State<MyCellarScreen> {
  final _formKey = GlobalKey<FormState>();
  final cFullNameController = TextEditingController();
  final cWineryController = TextEditingController();
  final cAppellationLevelController = TextEditingController();
  final cAppellationNameController = TextEditingController();
  final cRegionController = TextEditingController();
  final cCountryController = TextEditingController();
  final cPriceController = TextEditingController();
  final cVintageController = TextEditingController(); 
  final cDrinkingYearController = TextEditingController();
  final cGrapesController = TextEditingController();
  final cWineTypeController = TextEditingController();
  final cAlcoholController = TextEditingController(); 
  final cAgingMonthsController = TextEditingController();
  final cAgingTypeController = TextEditingController();
  final cTastingNotesController = TextEditingController();
  final cMethodController = TextEditingController();  
  final cSweetnessController = TextEditingController();
  int ref = 1;
  final int _currentIndex = 3;

  //dropdown types
  final redwine = 'Red wine'; 
  final whitewine = 'White wine';
  final sparklingwhite = 'Sparkling white';
  final sparklingred = 'Sparkling red'; 

  @override
  void dispose() {
    cFullNameController.dispose();
    cWineryController.dispose();
    cAppellationLevelController.dispose();
    cAppellationNameController.dispose(); 
    cRegionController.dispose();
    cCountryController.dispose();
    cPriceController.dispose();
    cVintageController.dispose();
    cDrinkingYearController.dispose();
    cGrapesController.dispose();
    cWineTypeController.dispose();
    cAlcoholController.dispose();
    cAgingMonthsController.dispose();
    cAgingTypeController.dispose();
    cTastingNotesController.dispose();
    cMethodController.dispose();
    cSweetnessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cellar'),
      ),
      body: Column(
        children: [
          Container(
            child: _buildTable(),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: AlertDialog(
                      content: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: cFullNameController,
                              decoration: const InputDecoration(
                                labelText: 'Wine name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This is a required field';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: cWineryController,
                              decoration: const InputDecoration(
                                labelText: 'Winery',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  cWineryController.text = 'NA';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: cAppellationNameController,
                              decoration: const InputDecoration(
                                labelText: 'Appellation',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  cAppellationNameController.text = 'NA';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: cVintageController,
                              decoration: const InputDecoration(
                                labelText: 'Vintage',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  cVintageController.text = 'NA';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField(
                              items: [
                                DropdownMenuItem(
                                  value: redwine,
                                  child: const Text('Red wine'),
                                ),
                                DropdownMenuItem(
                                  value: whitewine,
                                  child: const Text('White wine'),
                                ),
                                DropdownMenuItem(
                                  value: sparklingwhite,
                                  child: const Text('Sparkiling white'),
                                ),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This is a required field';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                cWineTypeController.text = value!;
                              },
                              decoration: const InputDecoration(
                                labelText: 'Wine type'
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() == true) {
                                      _saveData(); // call the _saveData() function here
                                      Navigator.of(context)
                                          .pop(); // close the dialog
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Data saved successfully!'),
                                              duration: Duration(seconds: 1),
                                            ),
                                          )
                                          .closed
                                          .then((_) {
                                        // Refresh the screen after the snackBar disappears
                                        setState(() {
                                          ref++;
                                        });
                                      });
                                    }
                                  },
                                  child: const Text('Save'),
                                ),
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text('Add a new wine'),
          ),
        ],
      ),
      bottomNavigationBar: AGreatBottomNavigationBarH(
        currentIndex: _currentIndex,
      ),
    );
  }


  Widget _buildTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final row = snapshot.data![index];
              return ListTile(
                title: Text(row['cFullName'].toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('${row['cWinery'].toString()} | ${row['cAppellationName'].toString()} | ${row['cWineType'].toString()}'),
                    ]),
                    Row(children: [
                      Text('${row['cVintage'].toString()}'),
                    ])
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await editData(context, row, false);
                        setState(() {});
                        },
                      child: const Icon(Icons.edit)
                    ),
                    GestureDetector(
                      onTap: () async {
                        final database = await openDatabase(
                          join(await getDatabasesPath(), 'mycellar.db'),
                          onCreate: (db, version) {
                            return db.execute(
                              'CREATE TABLE mycellar(ref INTEGER PRIMARY KEY, cFullName TEXT, cWinery TEXT, cAppellationLevel TEXT, cAppellationName TEXT, cRegion TEXT, cCountry TEXT, cPrice FLOAT, cVintage INTEGER, cDrinkingYear INTEGER, cGrapes TEXT, cWineType TEXT, cAlcohol FLOAT, cAgingMonths INTEGER, cAgingType TEXT, cTastingNotes TEXT, cMethod TEXT, cSweetness TEXT)',
                            );
                          },
                          version: 1,
                        );
                        await database.delete('mycellar',
                            where: 'ref = ?', whereArgs: [row['ref']]);
                        setState(() {});
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CellarWineDetails(row: row),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'mycellar.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE mycellar(ref INTEGER PRIMARY KEY, cFullName TEXT, cWinery TEXT, cAppellationLevel TEXT, cAppellationName TEXT, cRegion TEXT, cCountry TEXT, cPrice FLOAT, cVintage INTEGER, cDrinkingYear INTEGER, cGrapes TEXT, cWineType TEXT, cAlcohol FLOAT, cAgingMonths INTEGER, cAgingType TEXT, cTastingNotes TEXT, cMethod TEXT, cSweetness TEXT)',
        );
      },
      version: 1,
    );
    return await database.query('mycellar');
  }

  void _saveData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'mycellar.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE mycellar(ref INTEGER PRIMARY KEY, cFullName TEXT, cWinery TEXT, cAppellationLevel TEXT, cAppellationName TEXT, cRegion TEXT, cCountry TEXT, cPrice FLOAT, cVintage INTEGER, cDrinkingYear INTEGER, cGrapes TEXT, cWineType TEXT, cAlcohol FLOAT, cAgingMonths INTEGER, cAgingType TEXT, cTastingNotes TEXT, cMethod TEXT, cSweetness TEXT)',
        );
      },
      version: 1,
    );

    await database.insert(
      'mycellar',
      {
        'cFullName': cFullNameController.text,
        'cWinery': cWineryController.text,
        'cAppellationName': cAppellationNameController.text,
        'cWineType': cWineTypeController.text,
        'cTastingNotes': cTastingNotesController.text,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    _formKey.currentState?.reset();
    cFullNameController.clear();
    cWineryController.clear();
    cAppellationNameController.clear();
    cVintageController.clear();
    cWineTypeController.clear();
    cTastingNotesController.clear();
  }

  
}