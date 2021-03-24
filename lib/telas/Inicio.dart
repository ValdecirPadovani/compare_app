import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/telas/widgets/ItemAnuncio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;
  Firestore db = Firestore.instance;
  static const locale = 'pr_BR';

  Future<Stream<QuerySnapshot>> _adicionarListenerConversas(){
    final stream = db.collectionGroup("publicacao").orderBy('time', descending: true).snapshots();
    stream.listen(
            (dados){_controller.add(dados);
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
