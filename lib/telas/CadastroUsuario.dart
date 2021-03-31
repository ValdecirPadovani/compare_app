import 'dart:async';
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

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _urlImage;
  String _idUsuarioLogado = "";
  File? _imagem;
  bool? _subindoImagem;
  late String _totalPublicado;
  String? _urlRecuperada;


  Future _recuperarNomeUsuario()async{
    await db.collection("usuarios").doc(_idUsuarioLogado).get().then((documento){
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

  Future _recuperarUsuarioLogado() async{
    //pegando usuário logado no sistema
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    setState(() {
      _idUsuarioLogado = usuarioLogado!.uid;
    });
    await _recuperarNomeUsuario();
  }

  _salvarDadosUsuario() async{
    Cliente cli = Cliente();
    cli.nome = _nomeController.text;
    cli.email = _emailController.text;
    cli.urlImage = _urlImage;
    await db.collection("usuarios").doc(_idUsuarioLogado).update(cli.toMap());
    Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
  }

  _mudarFotoUsuario() async{
    Cliente cli = Cliente();
    cli.nome = _nomeController.text;
    cli.email = _emailController.text;
    cli.urlImage = _urlImage;
    await db.collection("usuarios").doc(_idUsuarioLogado).update(cli.toMap());
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
                /*CachedNetworkImage(
                  imageUrl: _urlImage,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: 150,
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.image),
                )*/
                CircleAvatar(
                  backgroundColor: Colors.white30,
                  backgroundImage: _urlImage == null ? Image.asset("images/login.png").image : NetworkImage(_urlImage!),
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
    File? imagemSelecionada;
    final piker = ImagePicker();
    switch (origem) {
      case "camera":
        final pikedImageCamera = await (piker.getImage(source: ImageSource.camera) as FutureOr<PickedFile>);
        imagemSelecionada = File(pikedImageCamera.path);
        break;
      case "galeria":
        final pikedImageGallery = await (piker.getImage(source: ImageSource.gallery) as FutureOr<PickedFile>);
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
    Reference pastaRaiz = storage.ref();
    String nomeImagem = _idUsuarioLogado+"_"+_totalPublicado+ DateTime.now().millisecondsSinceEpoch.toString()+".jpg";
    Reference arquivo = pastaRaiz.child("usuarios").child(nomeImagem);
    //Progresso da imagem sendo enviada ao servidor
    print(_imagem!.path + " " + nomeImagem);
    UploadTask task = arquivo.putFile(_imagem!);

    task.snapshotEvents.listen((TaskSnapshot storageEvent){
      if(storageEvent.state ==  TaskState.success){
        setState(() {
          _subindoImagem = true;
        });
      }else if(storageEvent.state == TaskState.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });
    //Recuperar imagem
    task.then((TaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

  _recuperarUrlImagem(TaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _urlImage = url;
    });
    await _mudarFotoUsuario();
  }

  _recuperaQuantidadePublicada() async{
    var stream = db.collection("publicacoes").doc(_idUsuarioLogado).collection("publicacao");
    var snapShot = await stream.get();
    print(snapShot.docs.length);
    if(snapShot.docs.length == null){
      setState(() {
        _totalPublicado = "0";
      });
    }else{
      setState(() {
        _totalPublicado = snapShot.docs.length.toString();
      });
    }
  }
}
