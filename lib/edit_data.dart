import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


Future<void> editData(BuildContext context, Map<String, dynamic> row, bool showAddFields) async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'mycellar.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE mycellar(ref INTEGER PRIMARY KEY, cFullName TEXT, cWinery TEXT, cAppellationLevel TEXT, cAppellationName TEXT, cRegion TEXT, cCountry TEXT, cPrice FLOAT, cVintage INTEGER, cDrinkingYear INTEGER, cGrapes TEXT, cWineType TEXT, cAlcohol FLOAT, cAgingMonths INTEGER, cAgingType TEXT, cTastingNotes TEXT, cMethod TEXT, cSweetness TEXT)',
      );
    },
    version: 1,
  );
  final cFullNameController = TextEditingController(
    text: row['cFullName'].toString(),
  );
  final cWineryController = TextEditingController(
    text: row['cWinery'].toString(),
  );
  final cAppellationNameController = TextEditingController(
    text: row['cAppellationName'].toString(),
  );
  final cVintageController = TextEditingController(
    text: row['cVintage'].toString(),
  );
  final cWineTypeController = TextEditingController(
    text: row['cWineType'].toString(),
  );
  final cTastingNotesController = TextEditingController(
    text: row['cTastingNotes'].toString(),
  );
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      
      return AlertDialog(
        title: Text('Edit Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: cFullNameController,
              decoration: InputDecoration(labelText: 'Wine name'),
            ),
            TextFormField(
              controller: cWineryController,              
              decoration: InputDecoration(labelText: 'Winery'),
            ),
            TextFormField(
              controller: cAppellationNameController,
              decoration: InputDecoration(labelText: 'Appellation'),
            ),
            TextFormField(
              controller: cVintageController, 
              decoration: InputDecoration(labelText: 'Vintage'),
            ),
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(
                  value: 'Red wine',
                  child: const Text('Red wine'),
                ),
                DropdownMenuItem(
                  value: 'White wine',
                  child: const Text('White wine'),
                ),
                DropdownMenuItem(
                  value: 'Sparkling white',
                  child: const Text('Sparkiling white'),
                ),
              ],
              onChanged: (value) {
                cWineTypeController.text = value!;
              },
              decoration: InputDecoration(labelText: 'Wine type'),
            ),
            if (showAddFields) TextFormField(
              controller: cTastingNotesController, 
              decoration: InputDecoration(labelText: 'Tasting Notes'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            child: Text('Save'),
            onPressed: () async {
              await database.update(
                'mycellar',
                {
                  'cFullName': cFullNameController.text,
                  'cWinery': cWineryController.text,
                  'cAppellationName': cAppellationNameController.text,
                  'cVintage': cVintageController.text,
                  'cWineType': cWineTypeController.text,
                  'cTastingNotes': cTastingNotesController.text,
                },
                where: 'ref = ?',
                whereArgs: [row['ref']],
              );

              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

