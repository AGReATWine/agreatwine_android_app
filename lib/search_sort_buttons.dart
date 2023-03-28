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
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: ElevatedButton(
            child: Text('Sort by RS'),
            onPressed: () => onPressedRS(!sortByRS, false, !sortAscending),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: ElevatedButton(
            child: Text('Sort by QP'),
            onPressed: () => onPressedQP(false, !sortByQP, sortAscending),
          ),
        ),
      ],
    );
  }
}