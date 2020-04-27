import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/Utils/ListPublicacao.dart';
import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  List<Publicacao> publicacoes = ListPublicacao.listaPublicacao();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: ListView.separated(
        itemBuilder: (context, index) {
          Publicacao publicacao = publicacoes[index];
          return GestureDetector(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: Row(
                    children: <Widget>[
                      //Correspondente a imagem para a publicação
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Container(
                            child: Image.asset("images/" + publicacao.image),
                            color: Colors.deepOrangeAccent,
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
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 50),
                                        child: Text(
                                          publicacao.descricao,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                              "Publicado dia: 10/03/2020",
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
                                              Icons.room,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                            Text(
                                              publicacao.loja.nome,
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
                                              Icons.assignment_ind,
                                              color: Colors.deepOrangeAccent,
                                            ),
                                            Text(
                                              publicacao.cliente.nome,
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
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
                    publicacao.descricao,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Text("Não tenho"),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) =>
            Divider(
              height: 3,
              color: Colors.red,
            ),
        itemCount: publicacoes.length,
      ),
    );
  }
}
