
import 'package:compareapp/model/Cliente.dart';
import 'package:compareapp/model/Loja.dart';
import 'package:compareapp/model/Produto.dart';
import 'package:compareapp/model/Publicacao.dart';

class ListPublicacao{

  static List<Publicacao> listaPublicacao(){
    Publicacao publicacao ;
    List<Publicacao> publicacoes = new List<Publicacao>();

    publicacao = new Publicacao.empty();
    publicacao.id = '1';
    publicacao.loja = new Loja("10", "Copercana", "16 3987 4540", "Habib Jabali 1500");
    publicacao.descricao= "Cerveja Skol Lata 350ml";
    publicacao.image = "cerveja.png";
    publicacao.cliente = new Cliente("7", "Valdecir", "valdecir@gmail.com", "1010");
    publicacao.produto = new Produto("05", "Skol Lata 350 ML");
    publicacoes.add(publicacao);

    publicacao = new Publicacao.empty();
    publicacao.id = "2";
    publicacao.descricao= "Contra filé KG";
    publicacao.image = "contra.png";
    publicacao.loja = new Loja("10", "Copercana", "16 3987 4540", "Habib Jabali 1500");
    publicacao.cliente = new Cliente("1", "João", "joão@gmail.com", "1010");
    publicacao.produto = new Produto("15", "Contra filé");
    publicacoes.add(publicacao);

    publicacao = new Publicacao.empty();
    publicacao.id = "3";
    publicacao.descricao= "Arroz Camil tipo 1 5Kg";
    publicacao.image = "arroz.png";
    publicacao.loja = new Loja("10", "Copercana", "16 3987 4540", "Habib Jabali 1500");
    publicacao.cliente = new Cliente("3", "Maria", "maria@gmail.com", "1010");
    publicacao.produto = new Produto("02", "Arroz tipo 1 5Kg");
    publicacoes.add(publicacao);

    publicacao = new Publicacao.empty();
    publicacao.id = "4";
    publicacao.descricao= "Sabão em pó Omo 2Kg vem que ta barato";
    publicacao.image = "sabao.png";
    publicacao.loja = new Loja("10", "Copercana", "16 3987 4540", "Habib Jabali 1500");
    publicacao.cliente = new Cliente("2", "José", "josé@gmail.com", "1010");
    publicacao.produto = new Produto("02", "Sabão em pó Omo 5kg");
    publicacoes.add(publicacao);

    publicacao = new Publicacao.empty();
    publicacao.id = "5";
    publicacao.descricao= "Cerveja Sub-zero Lata 350ml só 2,99";
    publicacao.image = "sub.png";
    publicacao.loja = new Loja("10", "Copercana", "16 3987 4540", "Habib Jabali 1500");
    publicacao.cliente = new Cliente("7", "Valdecir", "valdecir@gmail.com", "1010");
    publicacao.produto = new Produto("05", "Skol Lata 350 ML");
    publicacoes.add(publicacao);

    return publicacoes;
  }

}