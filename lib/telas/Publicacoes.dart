import 'package:flutter/material.dart';


class Publicacoes extends StatefulWidget {
  @override
  _PublicacoesState createState() => _PublicacoesState();
}

class _PublicacoesState extends State<Publicacoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            "Minhas Publicações",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

