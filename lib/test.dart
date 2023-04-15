// ListView(
//               children: [
//                 SizedBox(height: 100),
//                 InkWell(
//                   onTap: () => Navigator.push(context, routes[0]),
//                   child: Stack(
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.15,
//                         decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [
//                           Color.fromRGBO(233, 145, 154, 1),
//                           Color.fromRGBO(255, 255, 255, 1)
//                         ],
//                       ),
//                       borderRadius:BorderRadius.circular(20) 
//                     ),
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Text('DOCG Comparisons', style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold, color: Colors.white)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height:MediaQuery.of(context).size.height * 0.0150,),
//                 InkWell(
//                   onTap: () => Navigator.push(context, routes[1]),
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.15,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [
//                           Color.fromRGBO(220, 104, 115, 1),
//                           Color.fromRGBO(255, 255, 255, 1)
//                         ],
//                       ),
//                       borderRadius:BorderRadius.circular(20) 
//                     ),
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('DOC Comparisons', style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold, color: Colors.white)),
//                     ),
//                 )), 
//                 SizedBox(height:MediaQuery.of(context).size.height * 0.0150,),
//                 InkWell(
//                   onTap: () => Navigator.push(context, routes[2]),
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.15,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [
//                           Color.fromRGBO(227, 67, 82, 1),
//                           Color.fromRGBO(255, 255, 255, 1)
//                         ],
//                       ),
//                       borderRadius:BorderRadius.circular(20) 
//                     ),
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('Varieties Comparisons', style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold, color: Colors.white)),
//                     ),
//                 )), 
//                 SizedBox(height:MediaQuery.of(context).size.height * 0.0150,),
//                 InkWell(
//                   onTap: () => Navigator.push(context, routes[3]),
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.15,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                         colors: [
//                           Color.fromRGBO(228, 50, 55, 1),
//                           Color.fromRGBO(255, 255, 255, 1)
//                         ],
//                       ),
//                       borderRadius:BorderRadius.circular(20) 
//                     ),
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Text('Regional Comparisons', style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold, color: Colors.white)),
//                     ),
//                 )), 
//               ],
//             ),