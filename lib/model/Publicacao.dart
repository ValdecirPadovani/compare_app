
import 'Cliente.dart';
import 'Loja.dart';
import 'Produto.dart';

class Publicacao{

  String    _id;
  String    _descricao;
  String    _image;
  Loja      _loja;
  Produto   _produto;
  Cliente   _cliente;
  String  _dataPublicacao;


  Publicacao(this._id, this._descricao, this._loja, this._produto,
      this._cliente,this._image, this._dataPublicacao);

  Publicacao.empty();

  Map toMap(){
    Map<String, dynamic> map ={
    "descricao" : this._descricao,
    "image" : this._image,
    "lojaId" : this._loja.nome,
    "produtoId" : this._produto.nome,
    "clienteId" :  this._cliente.id,
    "dataPublicacao" : this._dataPublicacao
    };

    if(this._id != null){
      map["id"] = this._id;
    }
    return map;
  }

  String get dataPublicacao => _dataPublicacao;

  set dataPublicacao(String value) {
    _dataPublicacao = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  Cliente get cliente => _cliente;

  set cliente(Cliente value) {
    _cliente = value;
  }

  Produto get produto => _produto;

  set produto(Produto value) {
    _produto = value;
  }

  Loja get loja => _loja;

  set loja(Loja value) {
    _loja = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}