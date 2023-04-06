import 'package:flutter/material.dart';

class SortButtons extends StatelessWidget {
  final bool sortByRS;
  final bool sortByQP;
  final bool sortAscending;
  final Function(bool, bool, bool) onPressedRS;
  final Function(bool, bool, bool) onPressedQP;

  const SortButtons({
    Key? key,
    required this.sortByRS,
    required this.sortByQP,
    required this.sortAscending,
    required this.onPressedRS,
    required this.onPressedQP,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Color(0xFAFAFA).withOpacity(1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, -1), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                child: Text('Sort by RS'),
                onPressed: () => onPressedRS(!sortByRS, false, !sortAscending),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                child: Text('Sort by QP'),
                onPressed: () => onPressedQP(false, !sortByQP, sortAscending),
              ),
            ),
          ],
        ),
      ),
    );
  }
}