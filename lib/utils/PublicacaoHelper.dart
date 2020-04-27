import 'package:compareapp/model/Publicacao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PublicacaoHelper {

  static final String tableName = "publicacao";
  static final String colunaId = "id";
  static final String colunaDescricao = "descricao";
  static final String colunaImage = "imagem";
  static final String colunaLoja = "lojaId";
  static final String colunaProduto = "produtoId";
  static final String colunaDataPublicacao = "dataPublicacao";
  static final String colunaCliente = "clienteId";

  static final PublicacaoHelper _publicacaoHelper = PublicacaoHelper._internal();
  Database _db;

  factory PublicacaoHelper(){
    return _publicacaoHelper;
  }

  PublicacaoHelper._internal(){ }

  get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async{
    String sql = "CREATE TABLE $tableName ($colunaId INTEGER PRIMARY KEY AUTOINCREMENT, $colunaDescricao VARCHAR,$colunaImage VARCHAR, $colunaLoja INTEGER, $colunaProduto INTEGER, $colunaDataPublicacao TEXT,$colunaCliente INTEGER, image VARCHAR)";
    await db.execute(sql);
  }

  inicializarDB() async{
    print("TEste Brunão");
    final caminhoBancoDados = await getDatabasesPath();
    print(caminhoBancoDados+"  Caminho do banco");
    final localBancoDados = join(caminhoBancoDados, "compare_teste.db");
    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> salvarAnotacao(Publicacao publicacao) async{
    var bancoDados = await db;
    int resultado = await bancoDados.insert(tableName, publicacao.toMap());
    print(resultado);
    return resultado;
  }

  recuperarAnotacoes() async{
    var bancoDados = await db;
    String sql = "SELECT * FROM $tableName ORDER BY $colunaDataPublicacao DESC";
    List anotacoes = await bancoDados.rawQuery( sql );
    return anotacoes;
  }

  recuperarNumAnotacao() async{
    var bancoDados = await db;
    String sql = "SELECT COUNT($colunaId) FROM $tableName";
    int anotacoes = await bancoDados.rawQuery( sql );
    return anotacoes;
  }

  Future<int> atualizarAnotacao(Publicacao publicacao) async{
    var bancoDados = await db;
    return await bancoDados.update(
        tableName,
        publicacao.toMap(),
        where: "id = ?",
        whereArgs:[publicacao.id]
    );
  }

  Future<int> removerAnotacao(int id) async{
    var bancoDados = await db;
    return await bancoDados.delete(
        tableName,
        where: "id = ?",
        whereArgs:[id]
    );
  }

}