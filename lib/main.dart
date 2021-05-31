import 'package:compareapp/telas/RouterGenerator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
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
}