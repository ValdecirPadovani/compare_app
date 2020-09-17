import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/telas/widgets/ItemAnuncio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Publicacoes extends StatefulWidget {
  @override
  _PublicacoesState createState() => _PublicacoesState();
}

class _PublicacoesState extends State<Publicacoes> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;
  Firestore db = Firestore.instance;

  Stream<QuerySnapshot> _adicionarListenerConversas() {
    final stream = db
        .collection("publicacoes")
        .document(_idUsuarioLogado)
        .collection("publicacao")
        .orderBy("time", descending: true)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarUsuarioLogado() async {
    //pegando usuário logado no sistema
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    setState(() {
      _idUsuarioLogado = usuarioLogado.uid;
    });
    _adicionarListenerConversas();
  }

  @override
  void initState() {
    _recuperarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            //indicação de progresso ao carregar dados
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("Carregando promoções"),
                    CircularProgressIndicator()
                  ],
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              QuerySnapshot querySnapshot = snapshot.data;
              if (querySnapshot.documents.length == 0) {}
              if (snapshot.hasError) {
                return Expanded(
                  child: Text("Erro ao carregar os dados!"),
                );
              } else {
                return ListView.separated(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (context, index) {
                    //Publicacao publicacao = publicacoes[index];

                    List<DocumentSnapshot> publicacoes =
                    querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = publicacoes[index];
                    Publicacao publicacao =
                    Publicacao.fromDocumentSnapshot(documentSnapshot);
                    return ItemAnuncio(
                      publicacao: publicacao,
                      onTapItem: () {
                        Navigator.pushNamed(context, "/detalhes-publicacao",
                            arguments: publicacao);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 15,
                  ),
                );
              }
          }
        });
  }
}
