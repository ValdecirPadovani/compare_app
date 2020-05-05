import 'package:compareapp/Home.dart';
import 'package:compareapp/telas/RouterGenerator.dart';
import 'package:flutter/material.dart';

import 'telas/Login.dart';


void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,

    theme: ThemeData(
      focusColor: Colors.deepOrangeAccent,
      primaryColor: Colors.deepOrangeAccent
    ),
     initialRoute: "/",
    onGenerateRoute: RouterGenerator.generateRoute,
  )
);