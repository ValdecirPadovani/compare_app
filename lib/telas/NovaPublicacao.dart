import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compareapp/model/Cliente.dart';
import 'package:compareapp/model/Loja.dart';
import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/telas/widgets/BotaoCustomizado.dart';
import 'package:compareapp/telas/widgets/ImputCustomzado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:validadores/Validador.dart';


class NovaPublicacao extends StatefulWidget {
  @override
  _NovaPublicacaoState createState() => _NovaPublicacaoState();
}

class _NovaPublicacaoState extends State<NovaPublicacao> {

  Firestore db = Firestore.instance;
  String _idUsuarioLogado = "";
  String _nomeUsuario;
  var _format = new DateFormat('d/M/y').add_Hms();
  BuildContext _dialogContext;

  //Novas variaveis
  List<File> _listImagens = List();
  final _formKey = GlobalKey<FormState>();
  Publicacao _publicacao;

  @override
  void initState() {
    _recuperarUsuarioLogado();
    super.initState();
    _publicacao = Publicacao.gerarId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Nova publicação"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Imagem
                FormField<List>(
                  initialValue: _listImagens,
                  validator: (imagens) {
                    if (imagens.length == 0) {
                      return "Necessário uma imagem";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listImagens.length + 1,
                            itemBuilder: (context, indice) {
                              if (indice == _listImagens.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 40,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                                color: Colors.grey[100]),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (_listImagens.length > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              Dialog(
                                                child: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: <Widget>[
                                                    Image.file(
                                                        _listImagens[indice]),
                                                    FlatButton(
                                                      child: Text("Excluir"),
                                                      textColor: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                          _listImagens
                                                              .removeAt(indice);
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                      FileImage(_listImagens[indice]),
                                      child: Container(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.4),
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        if(state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(
                                  color: Colors.red, fontSize: 14
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
                //Titulo
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: ImputCustomizado(
                    hint: "Título da publicação",
                    label: "Títudo da promoção",
                    onSaved: (descricao) {
                      _publicacao.descricao = descricao;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(50, msg: "Máximo de caracteres")
                          .valido(valor);
                    },
                  ),
                ),
                //Preco
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: ImputCustomizado(
                    type: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                    hint: "Preço do produto",
                    label: "Preço",
                    onSaved: (preco) {
                      _publicacao.precoProduto = preco;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                //Loja
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: ImputCustomizado(
                    hint: "Loja",
                    label: "Loja",
                    onSaved: (loja) {
                      //ToDo: Resolver o problema da loja... Decidir se vai ser usado mapa ou livre pra digitação
                      Loja _loja = new Loja(
                          "10", loja, "16 3987 4540", "Habib Jabali 1500");
                      _publicacao.loja = loja;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),
                //Enviar - Cancelar
                Padding(
                  padding: EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BotaoCustomizado(
                        texto: "Enviar",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            _dialogContext = context;

                            _salvarNovaPublicacao();
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      BotaoCustomizado(
                        texto: "Descartar",
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/home", (_) => false);
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

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for (var imagem in _listImagens) {
      String nomeImagem = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      StorageReference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_publicacao.id)
          .child(nomeImagem);

      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      _publicacao.image.add(url);
    }
  }

  _salvarNovaPublicacao() async {
    _abrirDialog(_dialogContext);

    await _uploadImagens();

    Cliente cliente = new Cliente();
    cliente.id = _idUsuarioLogado;
    cliente.nome = _nomeUsuario;

    _publicacao.cliente = cliente;
    _publicacao.time = Timestamp.now();
    _publicacao.dataPublicacao = _format.format(DateTime.now()).toString();

    await db
        .collection("publicacoes")
        .document(_idUsuarioLogado)
        .collection("publicacao")
        .add(_publicacao.toMap());

    Navigator.pop(_dialogContext);
    Navigator.pop(context);
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

  _recuperarNomeUsuario()async{
     db.collection("usuarios").document(_idUsuarioLogado).get().then((documento){
       var doc = documento['nome'];
       assert(doc is String);
       setState(() {
         _nomeUsuario = doc;
       });
     });
  }

  Future _selecionarImagemGaleria() async {
    final _piker = ImagePicker();
    File _image;

    final imagemSelecionada =
    await _piker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(imagemSelecionada.path);
    });

    print(_image);
    if (_image != null) {
      setState(() {
        _listImagens.add(_image);
      });
    }
  }

  _abrirDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio...")
              ],
            ),
          );
        }
    );
  }

}


