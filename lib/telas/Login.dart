import 'package:compareapp/model/Cliente.dart';
import 'package:compareapp/telas/NovoCliente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos(){

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && senha.length > 6){
        setState(() {
          _mensagemErro = "";
        });
        Cliente usuario = Cliente();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);

      }else{
        setState(() {
          _mensagemErro = "Digite a senha";
        });
      }
    }else{
      setState(() {
        _mensagemErro = "Digite um e-mail válido";
      });
    }
  }


  Future _verificarUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();
    UserInfo usuarioLogado = await auth.currentUser();
    if(usuarioLogado != null){
      Navigator.pushReplacementNamed(context,"/home");
    }
  }

  _logarUsuario(Cliente cliente) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: cliente.email,
        password: cliente.senha
    ).then((firebase) {
      Navigator.pushReplacementNamed(context,"/home");
    }).catchError((error) {
      print(error.toString());
      print(cliente.email);
      print(cliente.senha);
      setState(() {
        _mensagemErro = "Erro ao fazer login";
      });
    });
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Compare"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "images/compare.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    controller: _controllerEmail,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                        hintText: "Digite seu e-mail",
                        labelText: "E-mail" ,
                        filled: true,
                        fillColor: Colors.white,
                        border:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                            )
                        )
                    ),
                  ),
                ),
                TextField(
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  controller: _controllerSenha,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 12),
                      hintText: "Digite sua senha",
                      labelText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32),
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.deepOrangeAccent,
                    padding: EdgeInsets.fromLTRB(42, 16, 42, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    onPressed: (){

                      _validarCampos();
                    },
                  ),
                ),
                RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: Image.asset("images/face2.jpg").image,
                        height: 20,
                      ),
                      Padding(padding: EdgeInsets.only(left: 20)),
                      Text(
                        "Entrar com Facebook",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  color: Color(0xFF2A5297),
                  padding: EdgeInsets.fromLTRB(32, 6, 32, 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: (){
                    _validarCampos();
                  },
                ),
                RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: Image.asset("images/login_gmail.png").image,
                        height: 20,
                      ),
                      Padding(padding: EdgeInsets.only(left: 20)),
                      Text(
                        "Entrar com Gmail",
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),

                    ],
                  ),
                  color: Colors.white70,
                  padding: EdgeInsets.fromLTRB(32, 6, 32, 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: (){
                    _validarCampos();
                  },
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 20
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => NovoCliente()
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
