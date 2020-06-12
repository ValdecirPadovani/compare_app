import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compareapp/model/Cliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {

  Firestore db = Firestore.instance;
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String _urlImage;
  String _idUsuarioLogado = "";
  File _imagem;
  bool _subindoImagem;
  String _totalPublicado;
  String _urlRecuperada;


  _recuperarNomeUsuario()async{
    db.collection("usuarios").document(_idUsuarioLogado).get().then((documento){
      var doc = documento['nome'];
      var docEmail = documento['email'];
      var urlImage = documento['urlImage'];
      assert(doc is String);
      setState(() {
        _nomeController.text = doc;
        _emailController.text = docEmail;
        _urlImage = urlImage;
      });
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

  _salvarDadosUsuario() async{
    Cliente cli = Cliente();
    cli.nome = _nomeController.text;
    cli.email = _emailController.text;
    cli.urlImage = _urlImage;
    await db.collection("usuarios").document(_idUsuarioLogado).updateData(cli.toMap());
    Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
  }

  _mudarFotoUsuario() async{
    Cliente cli = Cliente();
    cli.nome = _nomeController.text;
    cli.email = _emailController.text;
    cli.urlImage = _urlImage;
    await db.collection("usuarios").document(_idUsuarioLogado).updateData(cli.toMap());
  }

  @override
  void initState() {
    _recuperarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Compare"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(12),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white30,
                  backgroundImage: _urlImage == null ? Image.asset("images/login.png").image : NetworkImage(_urlImage),
                  radius: 65,
                  child: GestureDetector(
                    onTap: (){
                      _dialogImage(context);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _nomeController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                      hintText: "Nome",
                      labelText: "Nome",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _emailController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                      hintText: "E-mail",
                      labelText: "E-mail",
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 70),
                    ),
                    RaisedButton(
                        child: Text("Salvar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                        color: Colors.deepOrangeAccent,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          _salvarDadosUsuario();
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _dialogImage(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("De onde deseja selecionar sua foto de perfil?"),
        actions: <Widget>[
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             RaisedButton(
               elevation: 50,
                 child: Icon(Icons.add_a_photo,color: Colors.deepOrangeAccent,),
                 color: Colors.white,
                 padding: EdgeInsets.fromLTRB(22, 16, 22, 16),
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(32)),
                 onPressed: () {
                   _recuperarImagem("camera");
                 }
             ),
             Padding(padding: EdgeInsets.only(left: 30),),
             RaisedButton(
                 child:  Icon(Icons.photo,color: Colors.deepOrangeAccent,),
                 color: Colors.white,
                 padding: EdgeInsets.fromLTRB(22, 16, 22, 16),
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(32)),
                 onPressed: () {
                   _recuperarImagem("galeria");
                 }
             ),
            Padding(padding: EdgeInsets.only(left: 70),)
           ],
         ),

        ],
      );
    });
  }

  Future _recuperarImagem(String origem) async {
    File imagemSelecionada;
    final piker = ImagePicker();
    switch (origem) {
      case "camera":
        final pikedImageCamera = await piker.getImage(source: ImageSource.camera);
        imagemSelecionada = File(pikedImageCamera.path);
        break;
      case "galeria":
        final pikedImageGallery = await piker.getImage(source: ImageSource.gallery);
        imagemSelecionada = File(pikedImageGallery.path);
        break;
    }
    setState(() {
      _imagem = imagemSelecionada;
      if(_imagem != null){
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async{

    await _recuperaQuantidadePublicada();

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    String nomeImagem = _idUsuarioLogado+"_"+_totalPublicado+ DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
    StorageReference arquivo = pastaRaiz.child("usuarios").child(nomeImagem);
    //Progresso da imagem sendo enviada ao servidor
    print(_imagem.path + " " + nomeImagem);
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

  _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _urlImage = url;
    });
    await _mudarFotoUsuario();
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
}
