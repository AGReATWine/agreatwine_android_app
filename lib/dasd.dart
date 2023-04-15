// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// import 'main.dart';
// import 'search_screen.dart';
// import 'navigation.dart';

// class MyCellarScreen extends StatefulWidget {
//   @override
//   _MyCellarScreenState createState() => _MyCellarScreenState();
// }

// class _MyCellarScreenState extends State<MyCellarScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final cRatingYearController = TextEditingController();
//   final cVintageController = TextEditingController();
//   final cQtermsController = TextEditingController();
//   int ref = 1;
//   int _currentIndex = 3;

//   @override
//   void dispose() {
//     cRatingYearController.dispose();
//     cVintageController.dispose();
//     cQtermsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Form'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             child: _buildTable(),
//           ),   
//           ElevatedButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return SingleChildScrollView(
//                     child: AlertDialog(
//                       content: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextFormField(
//                               controller: cRatingYearController,
//                               decoration: InputDecoration(
//                                 labelText: 'Rating Year',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a value';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             TextFormField(
//                               controller: cVintageController,
//                               decoration: InputDecoration(
//                                 labelText: 'Vintage',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a value';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             TextFormField(
//                               controller: cQtermsController,
//                               decoration: InputDecoration(
//                                 labelText: 'Qterms',
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter a value';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState?.validate() == true) {
//                                   _saveData(); // call the _saveData() function here
//                                   Navigator.of(context).pop(); // close the dialog
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Data saved successfully!'),
//                                       duration: Duration(seconds: 2),
//                                     ),
//                                   );
//                                 }
//                               },
//                               child: Text('Save'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: Text('Add a new wine'),
//           ),
//         ],
//       ),
//       bottomNavigationBar: AGreatBottomNavigationBarH(
//       currentIndex: _currentIndex,
//     ),
//     );
//   }

//   Widget _buildTable() {
//   return FutureBuilder<List<Map<String, dynamic>>>(
//     future: _getData(),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: snapshot.data!.length,
//           itemBuilder: (context, index) {
//             final row = snapshot.data![index];
//             return ListTile(
//               title: Text(row['cRatingYear'].toString()),
//               subtitle: Text(row['cVintage'].toString()),
//               trailing: Text(row['cQterms']),
//             );
//           },
//         );
//       } else if (snapshot.hasError) {
//         return Text('Error: ${snapshot.error}');
//       } else {
//         return CircularProgressIndicator();
//       }
//     },
//   );
// }

// Future<List<Map<String, dynamic>>> _getData() async {
//   final database = await openDatabase(
//     join(await getDatabasesPath(), 'mycellar.db'),
//     onCreate: (db, version) {
//       return db.execute(
//         'CREATE TABLE mycellar(ref INTEGER PRIMARY KEY, cRatingYear INTEGER, cVintage INTEGER, cQterms TEXT)',
//       );
//     },
//     version: 1,
//   );
//   return await database.query('mycellar');
// }

// void _saveData() async {
//   final database = await openDatabase(
//     join(await getDatabasesPath(), 'mycellar.db'),
//     onCreate: (db, version) {
//       return db.execute(
//         'CREATE TABLE mycellar(ref INTEGER PRIMARY KEY, cRatingYear INTEGER, cVintage INTEGER, cQterms TEXT)',
//       );
//     },
//     version: 1,
//   );

//   await database.insert(
//     'mycellar',
//     {
//       'cRatingYear': cRatingYearController.text,
//       'cVintage': cVintageController.text,
//       'cQterms': cQtermsController.text,
//     },
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );

//   _formKey.currentState?.reset();
//   cRatingYearController.clear();
//   cVintageController.clear();
//   cQtermsController.clear();
// }
// }