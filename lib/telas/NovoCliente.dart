import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compareapp/model/Cliente.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NovoCliente extends StatefulWidget {
  @override
  _NovoClienteState createState() => _NovoClienteState();
}

class _NovoClienteState extends State<NovoCliente> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _cadastrarUsuario(Cliente cliente) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: cliente.email,
        password: cliente.senha
    ).then((firebaseUser) {
      Firestore db = Firestore.instance;
      db.collection("usuarios")
          .document(firebaseUser.user.uid)
          .setData(cliente.toMap());
      Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
    }).catchError((error) {
      setState(() {
        print(error.toString());
        _mensagemErro = "Falha ao cadastrar o usuário" + error.toString();
      });
    });
  }

  _validarCampos(){
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){
        if(senha.isNotEmpty && senha.length > 6){
          setState(() {
            _mensagemErro = "";
          });
          Cliente cliente = Cliente();
          cliente.email = email;
          cliente.senha = senha;
          cliente.nome  = nome;

          _cadastrarUsuario(cliente);

        }else{
          setState(() {
            _mensagemErro = "Digite a senha com mais de 6 caracteres";
          });
        }
      }else{
        setState(() {
          _mensagemErro = "Digite um e-mail válido";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });
    }

  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Novo cadastro"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                //Imagem usuário
                Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 0),
                  child: Image.asset(
                      "images/usuario.png",
                      width: 200,
                      height: 50,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                //TextField Nome
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerNome,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "Nome",
                        labelText: "Digite seu nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  ),
                ),
                //TextField email
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "E-mail",
                        labelText: "Digite seu e-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        )
                    ),
                  ),
                ),
                //TextField senha
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    obscureText: true,
                    controller: _controllerSenha,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "Senha",
                        labelText: "Senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                    ),

                  ),
                ),
                //TextField confirmar senha
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                          hintText: "Confirmar senha",
                          labelText: "Confirmar senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)
                          )
                      ),
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 25),
                  child: Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          "Cadastrar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.deepOrangeAccent,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),

                        ),
                        onPressed: (){
                          _validarCampos();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                      ),
                      RaisedButton(
                        child: Text(
                          "Cancelar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ],
                  ) ,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
