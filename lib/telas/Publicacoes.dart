import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder(
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
              if (snapshot.hasError) {
                return Expanded(
                  child: Text("Erro ao carregar os dados!"),
                );
              } else {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    List<DocumentSnapshot> publicacoes = querySnapshot.documents.toList();
                    DocumentSnapshot publicacao = publicacoes[index];
                    return Card(
                      child: GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Row(
                                children: <Widget>[
                                  //Correspondente a imagem para a publicação
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Image.network(publicacao["image"],height: 148,width: 150,fit: BoxFit.fill,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //Correspondente aos dados da publicação
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            //Descrição
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.attach_money,
                                                          color: Colors.deepOrangeAccent,
                                                        ),
                                                        Text(
                                                          publicacao['precoProduto'] == null
                                                              ? "Sempre preco" : publicacao['precoProduto'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            //Data publicação
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.deepOrangeAccent,
                                                        ),
                                                        Text(
                                                          publicacao['dataPublicacao'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            //Loja
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.room,
                                                          color: Colors.deepOrangeAccent,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            publicacao["lojaId"] == null
                                                                ? "" : publicacao["lojaId"],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(top: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.assignment_ind,
                                                          color: Colors.deepOrangeAccent,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            publicacao["clienteId"] == null
                                                                ? "nome" : publicacao["clienteId"]
                                                            ,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ListTile(
                              title: Text(
                                publicacao["descricao"],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text(""),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 15,
                  ),
                  itemCount: querySnapshot.documents.length,
                );
              }
          }
        });
  }
}
