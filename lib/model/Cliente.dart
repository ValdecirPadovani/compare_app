
class Cliente{

  String? _id;
  String? _nome;
  String? _email;
  String? _urlImage;
  String? senha;

  Cliente();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "urlImage" : this.urlImage
    };
    return map;
  }

  String? get urlImage => _urlImage;

  set urlImage(String? value) {
    _urlImage = value;
  }

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get nome => _nome;

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  set nome(String? value) {
    _nome = value;
  }
}