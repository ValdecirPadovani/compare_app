import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class SqLitHelper{

  static final SqLitHelper _anotacaoHelper = SqLitHelper._internal();
  Database _db;

  factory SqLitHelper(){
    return _anotacaoHelper;
  }

  SqLitHelper._internal(){ }

  get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async{
    String sql = "CREATE TABLE publicacao (id INTEGER PRIMARY KEY AUTOINCREMENT, descricao VARCHAR,descricao VARCHAR, lojaId INTEGER, produtoId INTEGER, dataPublicacao DATETIME,clienteId INTEGER)";
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
}

