import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Widget proximaTela;

  LoginScreen(this.proximaTela);
  @override
  _LoginScreenState createState() => new _LoginScreenState(proximaTela);
}

class _LoginScreenState extends State<LoginScreen> {
  final Widget proximaTela;
  final cpfController = TextEditingController();

  _LoginScreenState(this.proximaTela);

  @override
  void dispose() {
    cpfController.dispose();
    super.dispose();
  }

  Future<bool> realizarLogin() async {
    Map<String, String> body = {
      'acao': 'teste',
      'data': cpfController.text,
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapResposta = json.decode(response.body);

      if (mapResposta["ehUsuario"] == 0)
        exibirMensagem(context, "Usuário não encontrado no sistema");
      else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(Configuracao.spCpf, cpfController.text);
        prefs.setString(Configuracao.spNome, mapResposta["nome"]);
        prefs.setInt(Configuracao.spEhAlunoDaOlimpiada,
            mapResposta["ehAlunoDaOlimpiada"]);
        prefs.setInt(Configuracao.spEhDaComissaoAvaliadoraDaOlimpiada,
            mapResposta["ehDaComissaoAvaliadoraDaOlimpiada"]);
        prefs.setString(Configuracao.idMatriculaComissaoAvaliadora,
            mapResposta["id_matricula_comissao_avaliadora"]);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext ctx) => proximaTela));
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 72.0,
        child: Image.asset('images/logotipo-abramede-2021.png'),
      ),
    );

    final cpf = TextFormField(
      controller: cpfController,
      maxLength: 11,
      keyboardType: TextInputType.number,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'CPF (Somente números)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //Navigator.of(context).pushNamed(HomePage.tag);
          if (cpfController.text.isEmpty == true) {
            exibirMensagem(context, "Favor preencher o valor do campo CPF.");
          } else {
            realizarLogin().then((value) {
              print("Está logado");
            });
          }
        },
        padding: EdgeInsets.all(16),
        color: Color(Configuracao.primayColor),
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(Configuracao.primayColor),
        elevation: 0,
        toolbarHeight: Configuracao.toolbarHeight,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            cpf,
            SizedBox(height: 8.0),
            loginButton
          ],
        ),
      ),
    );
  }
}

exibirMensagem(BuildContext context, String mensagem) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Congresso Abramede MG"),
    content: Text(mensagem),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
