
class Loja{

  String _id;
  String _nome;
  String _fone;
  String _endereco;

  Loja(this._id, this._nome, this._fone, this._endereco);

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get fone => _fone;

  set fone(String value) {
    _fone = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}