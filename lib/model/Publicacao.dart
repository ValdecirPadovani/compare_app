
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Cliente.dart';
import 'Loja.dart';
import 'Produto.dart';

class Publicacao{

  String?          _id;
  String?          _descricao;
  List<String>?    _image;
  //ToDo: Voltar para objeto loja depois de implantado
  //Loja            _loja;
  String?            _loja;
  Produto?         _produto;
  Cliente?         _cliente;
  String?          _nomeCliente;
  Timestamp?        _time;
  String?          _precoProduto;
  String?          _dataPublicacao;
  String?          _categoria;


  Publicacao.empty();

  Publicacao.gerarId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference publicacao = db.collection("publicacoes");
    this.id = publicacao.doc().id;
    this.image = [];
  }

  Publicacao.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id             = documentSnapshot.id;
    this.descricao      = documentSnapshot["descricao"];
    this.image          = List<String>.from(documentSnapshot["image"]);
    this.loja           = documentSnapshot["lojaId"];
    this.nomeCliente    = documentSnapshot["clienteId"];
    this.time           = documentSnapshot["time"];
    this.precoProduto   = documentSnapshot["precoProduto"];
    this.dataPublicacao = documentSnapshot["dataPublicacao"];
    this.categoria      = documentSnapshot["categoria"];
  }

  Map toMap(){
    Map<String, dynamic> map ={
      "id"              : this.id,
      "descricao"       : this._descricao,
      "image"           : this._image,
      "lojaId"          : this._loja,
      "clienteId"       :  this._cliente!.nome,
      "time"            : this._time,
      "dataPublicacao"  : this.dataPublicacao,
      "precoProduto"    : this.precoProduto,
      "categoria"       : this.categoria
    };

    if(this._id != null){
      map["id"] = this._id;
    }
    return map;
  }


  String? get nomeCliente => _nomeCliente;

  set nomeCliente(String? value) {
    _nomeCliente = value;
  }

  String? get loja => _loja;

  set loja(String? value) {
    _loja = value;
  }

  String? get categoria => _categoria;

  set categoria(String? value) {
    _categoria = value;
  }

  List<String>? get image => _image;

  set image(List<String>? value) {
    _image = value;
  }

  String? get dataPublicacao => _dataPublicacao;

  set dataPublicacao(String? value) {
    _dataPublicacao = value;
  }

  Timestamp? get time => _time;

  set time(Timestamp? value) {
    _time = value;
  }

  String? get precoProduto => _precoProduto;

  set precoProduto(String? value) {
    _precoProduto = value;
  }


  Cliente? get cliente => _cliente;

  set cliente(Cliente? value) {
    _cliente = value;
  }

  Produto? get produto => _produto;

  set produto(Produto? value) {
    _produto = value;
  }



  String? get descricao => _descricao;

  set descricao(String? value) {
    _descricao = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }
}