import 'package:compareapp/Home.dart';
import 'package:flutter/material.dart';

import 'telas/Login.dart';


void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,

    theme: ThemeData(
      focusColor: Colors.deepOrangeAccent,
      primaryColor: Colors.deepOrangeAccent

    ),
    home: Login(),
  )
);