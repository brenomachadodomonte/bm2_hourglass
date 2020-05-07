import 'package:flutter/material.dart';
import 'package:hourglass/screens/home.dart';

void main() => runApp(MaterialApp(
  home: Home(),
  theme: ThemeData(
    primarySwatch: Colors.grey,
  ),
  debugShowCheckedModeBanner: false,
));
