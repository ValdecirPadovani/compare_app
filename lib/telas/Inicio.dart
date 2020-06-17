import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  //var _format = new DateFormat('d/M/y','pt_BR').add_Hms();
  static const locale = 'pr_BR';


  Stream<QuerySnapshot> _adicionarListenerConversas(){
    final stream = db.collectionGroup("publicacao").orderBy('time', descending: true).getDocuments().asStream();
    stream.listen(
            (dados){_controller.add(dados);
        });
  }

  _recuperarUsuarioLogado() async{
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

    return  StreamBuilder<QuerySnapshot>(
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
                    //Publicacao publicacao = publicacoes[index];

                    List<DocumentSnapshot> publicacoes = querySnapshot.documents.toList();
                    DocumentSnapshot publicacao = publicacoes[index];
                    return Card(
                      elevation: 5,
                       child: GestureDetector(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
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
                                              //Preço do produto
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
                                        )
                                    )
                                  ],
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  publicacao["descricao"],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(
                        height: 15,
                      ),
                  itemCount: querySnapshot.documents.length,
                );
              }
          }
        }
    );
  }
}
