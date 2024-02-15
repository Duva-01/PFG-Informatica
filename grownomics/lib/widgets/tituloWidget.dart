import 'package:flutter/material.dart';

Widget buildTitulo(String titulo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
      Divider(
        color: Colors.blueGrey[800],
        thickness: 2,
        height: 20,
        indent: 16,
        endIndent: 16,
      ),
    ],
  );
}