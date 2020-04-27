
class Produto{

  String _id;
  String _nome;
  //Categoria categorias = new Categoria();
  //List<PrecoProduto> precoProduto = new ArrayList<>();

  Produto(this._id, this._nome);

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }


}