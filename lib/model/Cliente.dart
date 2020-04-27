
class Cliente{

  String _id;
  String _nome;
  String _email;
  //TipoCliente tipo;
  String senha;


  Cliente(this._id, this._nome, this._email, this.senha);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get nome => _nome;

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  set nome(String value) {
    _nome = value;
  }


}