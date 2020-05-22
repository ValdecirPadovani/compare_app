import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compareapp/model/Loja.dart';
import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/model/Cliente.dart';
import 'package:compareapp/model/Produto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';


class NovaPublicacao extends StatefulWidget {
  @override
  _NovaPublicacaoState createState() => _NovaPublicacaoState();
}

class _NovaPublicacaoState extends State<NovaPublicacao> {

  Firestore db = Firestore.instance;
  TextEditingController _precoController = TextEditingController();
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _lojaController = TextEditingController();
  String _idUsuarioLogado = "";
  File _imagem;
  bool _subindoImagem;
  String _urlRecuperada;
  String _totalPublicado;
  String _nomeUsuario;

  @override
  void initState() {
    _recuperarUsuarioLogado();
    super.initState();
  }

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
                 padding: EdgeInsets.all(3),
                    child:Container(
                      height: 170,
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                            image:_urlRecuperada == null ?
                            AssetImage("images/compare.png"):
                            NetworkImage(_urlRecuperada ),
                            fit: BoxFit.cover
                        ),
                        border: Border.all(color: Colors.redAccent)
                      ),
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
                          _recuperarImagem("camera");
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
                          _recuperarImagem("galeria");
                        },
                      ),
                    ],
                  ),
                //Titulo
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
                    //inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                    controller: _precoController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "Preço do produto",
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
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          _urlRecuperada == null ? _createDialog(context) : _salvarPublicacao();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      RaisedButton(
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
                            Navigator.pushNamedAndRemoveUntil(context,"/home",(_)=>false);
                          },
                        ),
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

   _createDialog( BuildContext context){
    return showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Selecione uma imagem"),
          actions: <Widget>[
            MaterialButton(
              elevation: 6,
              child: Text("OK"),
              onPressed: (){
                  Navigator.of(context).pop();
              },
            )
          ],
        );
    });
  }

  _salvarPublicacao() async {

    //adicionando o id do usuário
    Cliente cliente = new Cliente();
    cliente.id = _idUsuarioLogado;
    cliente.nome  = _nomeUsuario;

    Publicacao publicacao = new Publicacao.empty();
    publicacao.descricao= _tituloController.text;
    publicacao.dataPublicacao = DateTime.now().toIso8601String();
    publicacao.image = _urlRecuperada;
    publicacao.loja = new Loja("10", _lojaController.text, "16 3987 4540", "Habib Jabali 1500");
    publicacao.cliente = cliente;
    publicacao.precoProduto = _precoController.text;
    publicacao.produto = new Produto("02", "Arroz tipo 1 5Kg");

    Firestore db = Firestore.instance;

    await db.collection("publicacoes")
        .document( _idUsuarioLogado )
        .collection("publicacao")
        .add(publicacao.toMap());

    Navigator.pushReplacementNamed(context, "/home");
  }

  _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _urlRecuperada = url;
    });
  }

  _recuperarUsuarioLogado() async{
    //pegando usuário logado no sistema
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    setState(() {
      _idUsuarioLogado = usuarioLogado.uid;
    });
    _recuperarNomeUsuario();
  }

  _recuperaQuantidadePublicada() async{

    var stream = db.collection("publicacoes").document(_idUsuarioLogado).collection("publicacao");
    var snapShot = await stream.getDocuments();
    print(snapShot.documents.length);
    if(snapShot.documents.length == null){
      setState(() {
        _totalPublicado = "0";
      });
    }else{
      setState(() {
        _totalPublicado = snapShot.documents.length.toString();
      });
    }
  }

  _recuperarNomeUsuario()async{
     db.collection("usuarios").document(_idUsuarioLogado).get().then((documento){
       var doc = documento['nome'];
       assert(doc is String);
       setState(() {
         _nomeUsuario = doc;
       });
     });
  }

  Future _uploadImagem() async{

    await _recuperaQuantidadePublicada();

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    String nomeImagem = _idUsuarioLogado+"_"+_totalPublicado+".jpg";
    StorageReference arquivo = pastaRaiz.child("publicacoes").child(nomeImagem);
    //Progresso da imagem sendo enviada ao servidor
    StorageUploadTask task = arquivo.putFile(_imagem);

    task.events.listen((StorageTaskEvent storageEvent){
      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _subindoImagem = true;
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    //Recuperar imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarImagem(String origem) async{
    File imagemSelecionada;
    switch(origem){
      case "camera":
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }
    print(imagemSelecionada);
    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

}


