import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String note, date;

  NoteItem({this.note, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            note,
            style: TextStyle(fontSize: 18),
          ),
          Text(date,
            style: TextStyle(fontSize: 10)
          )

        ],
      ),
    );
  }
}
