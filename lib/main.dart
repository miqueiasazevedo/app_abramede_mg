import 'package:flutter/material.dart';
import 'package:app_abramede_mg/screens/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Congresso Abramede MG',
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: Home(),
  ));
}
