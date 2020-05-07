import 'package:compareapp/Utils/ListPublicacao.dart';
import 'package:compareapp/model/Publicacao.dart';
import 'package:compareapp/telas/Destaques.dart';
import 'package:compareapp/telas/Inicio.dart';
import 'package:compareapp/telas/Publicacoes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _indice = 0;

  List<Publicacao> publicacoes = ListPublicacao.listaPublicacao();

  List<Widget> _telas = [
    Inicio(),
    Publicacoes(),
    Destaques()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Compare"),
      ),
      drawer: _myDrawer(),
      body: Container(
        color: Colors.white60,
        child: _telas[_indice]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.pushNamed(context,"/novaPublicacao");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.deepOrangeAccent,
        currentIndex: _indice,
        onTap: (index){
          setState(() {
            _indice = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              title: Text("Inicio"),
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              title: Text("Publicações"),
              icon: Icon(Icons.local_offer)
          ),
          BottomNavigationBarItem(
              title: Text("Destaques"),
              icon: Icon(Icons.grade)
          ),
          BottomNavigationBarItem(
              title: Text("Biblioteca"),
              icon: Icon(Icons.folder)
          )
        ],
      ),
    );
  }

  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context,"/login");
  }

  Widget _myDrawer(){
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Valdecir Padovani Junior"),
            accountEmail: Text("valdecir@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white30,
              backgroundImage: Image.asset("images/login.png").image,
            ),
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent
            ),
          ),
          SizedBox(height: 40),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text(
                "Minha conta",
                style: TextStyle(fontSize: 20),
            ),
            onTap: (){

            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Sair",
              style: TextStyle(fontSize: 20),
            ),
            onTap: (){
              _deslogarUsuario();
            },
          )
        ],
      ),
    );
  }
}
