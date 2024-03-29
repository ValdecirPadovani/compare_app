import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {

  final String texto;
  final Color corTexto;
  final VoidCallback? onPressed;

  BotaoCustomizado({
    required this.texto,
    this.corTexto = Colors.white,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32)
      ),
      child: Text(
        this.texto,
        style: TextStyle(color: this.corTexto, fontSize: 15),
      ),
      color: Colors.deepOrangeAccent,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      onPressed: this.onPressed,
    );
  }
}
