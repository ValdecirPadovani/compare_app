import 'package:compareapp/Home.dart';
import 'package:compareapp/telas/CadastroUsuario.dart';
import 'package:compareapp/telas/Login.dart';
import 'package:compareapp/telas/NovaPublicacao.dart';
import 'package:flutter/material.dart';

import 'DetalhesPublicacao.dart';

class RouterGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){

      case "/":
        return MaterialPageRoute(
          builder: (_) => Login()
        );

      case "/home":
        return MaterialPageRoute(
          builder: (_) => Home()
        );

      case "/inicio":
        return MaterialPageRoute(
          builder: (_) => Home()
        );

      case "/login":
        return MaterialPageRoute(
          builder: (_) => Login()
        );

      case "/novaPublicacao":
        return MaterialPageRoute(
          builder: (context) => NovaPublicacao(),
        );

      case "/publicacoes":
        return MaterialPageRoute(
          builder: (_) => Home()
        );

      case "/dadosUsuario":
        return MaterialPageRoute(
            builder: (_) => CadastroUsuario()
        );

      case "/detalhes-publicacao":
        return MaterialPageRoute(
            builder: (_) => DetalhesPublicacao(args)
        );

      default:
        _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada"),),
            body: Center(
              child: Text("Tela não encontrada"),
            ),
          );
        }
    );
  }
}

