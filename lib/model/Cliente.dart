
class Cliente{

  String _id;
  String _nome;
  String _email;
  //TipoCliente tipo;
  String senha;

  Cliente();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email
    };
    return map;
  }

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