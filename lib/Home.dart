import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? _accountName;
  String? _accountEmail;
  String? _urlImage;
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Widget> _telas = [Inicio(), Publicacoes(), Destaques()];

  @override
  void initState() {
    _recuperarNomeUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Compare"),
      ),
      drawer: _myDrawer(),
      body: Container(color: Colors.white60, child: _telas[_indice]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/novaPublicacao");
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.deepOrangeAccent,
        currentIndex: _indice,
        onTap: (index) {
          setState(() {
            _indice = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              label: "Inicio", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
              label: "Publicações", icon: Icon(Icons.local_offer)),
          BottomNavigationBarItem(
              label: "Destaques", icon: Icon(Icons.grade)),
        ],
      ),
    );
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  _recuperarNomeUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;

    await db
        .collection("usuarios")
        .doc(usuarioLogado.uid)
        .get()
        .then((documento) {
      var doc = documento['nome'];
      var docEmail = documento['email'];
      var urlImage = documento['urlImage'];
      assert(doc is String);
      setState(() {
        _accountName = doc;
        _accountEmail = docEmail;
        _urlImage = urlImage;
      });
    });
  }

  _dadosUsuario() {
    Navigator.pushNamed(context, "/dadosUsuario");
  }

  Widget _myDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(_accountName.toString()),
              accountEmail: Text(_accountEmail.toString()),
              currentAccountPicture: _urlImage != null
                  ? CircleAvatar(backgroundImage: NetworkImage(_urlImage!),)/*CachedNetworkImage(
                      imageUrl: _urlImage,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 150,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image),
                    )*/
                  : Image.asset("usuario.png")),

          SizedBox(height: 40),
          ListTile(
            leading: Icon(Icons.account_box),
            title: Text(
              "Minha conta",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              _dadosUsuario();
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Sair",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              _deslogarUsuario();
            },
          )
        ],
      ),
    );
  }
}
