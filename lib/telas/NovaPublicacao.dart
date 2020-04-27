import 'dart:io';

import 'package:compareapp/Home.dart';
import 'package:compareapp/model/Loja.dart';
import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/model/Cliente.dart';
import 'package:compareapp/model/Produto.dart';
import 'package:compareapp/utils/PublicacaoHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class NovaPublicacao extends StatefulWidget {
  @override
  _NovaPublicacaoState createState() => _NovaPublicacaoState();
}

class _NovaPublicacaoState extends State<NovaPublicacao> {


  TextEditingController _precoController = TextEditingController();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _lojaController = TextEditingController();

  String _path = "";
  String _nomeImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
      backgroundColor: Colors.deepOrangeAccent,
      title: Text("Nova publicação"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //Imagem
               Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Image.asset(
                       _path,
                      width: 200,
                      height: 250,
                    ),
                  ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.green,
                            size: 40,
                          ),
                          padding: EdgeInsets.only(bottom: 8),
                        ),
                        onPressed: (){
                          _newPhoto("camera");
                        },
                      ),
                      FlatButton(
                        child: IconButton(
                          icon: Icon(
                              Icons.folder_shared,
                            color: Colors.blue,
                            size: 40,
                          ),
                          padding: EdgeInsets.only(bottom: 8),
                        ),
                        onPressed: (){
                          _newPhoto("galeria");
                        },
                      ),
                    ],
                  ),
                //Titulo
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: TextField(
                    controller: _tituloController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                      hintText: "Títudo da promoção",
                      labelText: "Títudo da promoção",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      )
                    ),
                  ),
                ),
                //Preco
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _precoController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "Preço",
                        labelText: "Preço",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        )
                    ),
                  ),
                ),
                //Loja
                Padding(padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _lojaController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "Loja",
                        labelText: "Loja",
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        )
                    ),
                  ),
                ),
                //Enviar - Cancelar
                Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 60),
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          "Enviar",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        color: Colors.deepOrangeAccent,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: (){
                          _insetProd();
                          /*
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context)=> Home()
                              ));
                           */
                        },
                      ),
                      Padding(
                        padding:EdgeInsets.only( left: 20),
                        child: RaisedButton(
                          child: Text(
                            "Descartar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                            ),
                          ),
                          color: Colors.deepOrangeAccent,
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                          ),
                          onPressed: (){
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context)=> Home()
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Chamado após acionar o botão enviar
  _insetProd() async{

    if(_path.isEmpty){
      AlertDialog(
        title: Text(
          "path VAZIO"
        ),
      );
    }

    Publicacao publicacao = new Publicacao.empty();
    publicacao.descricao= _tituloController.text;
    publicacao.dataPublicacao = DateTime.now().toIso8601String();
    publicacao.image = "arroz.png";
    publicacao.loja = new Loja("10", _lojaController.text, "16 3987 4540", "Habib Jabali 1500");
    publicacao.cliente = new Cliente("3", "Maria", "maria@gmail.com", "1010");
    publicacao.produto = new Produto("02", "Arroz tipo 1 5Kg");

    var helper = PublicacaoHelper();
    var teste = await helper.salvarAnotacao(publicacao);
  }

  _newPhoto( String pathPhoto){
    switch(pathPhoto){
      case "camera":
        getImageFromCam();
        break;

      case "galeria":
        getImageFromGalery();
        break;
    }
  }

  Future getImageFromCam() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    var path = await getApplicationDocumentsDirectory();
    File newImaeg = await image.copy(path.path+"/"+_nomeImg);
    setState(() {
      _path = newImaeg.path;
    });
  }
  Future getImageFromGalery() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var path = await getApplicationDocumentsDirectory();
    getIdPub();
    File newImaeg = await image.copy(path.path+"/"+_nomeImg);
    setState(() {
      _path = newImaeg.path;
    });
  }

  Future getIdPub() async{
    var helper = PublicacaoHelper();
    int qtyAnotacao  =  await helper.recuperarNumAnotacao();
    _nomeImg = qtyAnotacao.toString() +".png";
  }

}


