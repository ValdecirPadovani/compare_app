import 'package:compareapp/model/Publicacao.dart';
import 'package:flutter/material.dart';

class ItemAnuncio extends StatelessWidget {

  Publicacao publicacao;
  VoidCallback? onTapItem;
  VoidCallback? onTapRemover;

  ItemAnuncio({
    required this.publicacao,
    this.onTapRemover,
    this.onTapItem
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: this.onTapItem,
        child: Card(
          elevation: 5,
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
                          Text("Teste")
                           /* CachedNetworkImage(
                              imageUrl: publicacao.image[0],
                              height: 148,
                              width: 150,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            )*/,
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
                                            publicacao.precoProduto == null
                                                ? "Sempre preco" : publicacao.precoProduto!,
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
                                            publicacao.dataPublicacao!,
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
                                              publicacao.loja == null
                                                  ? "" : publicacao.loja!,
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
                                              publicacao.nomeCliente == null
                                                  ? "nome" : publicacao.nomeCliente!
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
                  publicacao.descricao!,
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
  }
}
