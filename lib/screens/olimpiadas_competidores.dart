import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_equipes.dart';
import 'package:app_abramede_mg/screens/olimpiadas_equipe.dart';
import 'package:app_abramede_mg/screens/olimpiadas_menu_inferior.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class OlimpiadasCompetidoresScreen extends StatefulWidget {
  @override
  _OlimpiadasCompetidoresScreenState createState() =>
      _OlimpiadasCompetidoresScreenState();
}

class _OlimpiadasCompetidoresScreenState
    extends State<OlimpiadasCompetidoresScreen> {
  List<OlimpiadasEquipes> _listaOlimpiadasEquipes = [];
  bool _loading = true;

  // ignore: missing_return
  Future<List<OlimpiadasEquipes>> carregaOlimpiadasEquipes() async {
    //Somente permite continuar na página se o usuário estiver logado e for um competidor
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cpf = prefs.getString(Configuracao.spCpf);
    var spEhAlunoDaOlimpiada = prefs.getInt(Configuracao.spEhAlunoDaOlimpiada);

    if (cpf == null || spEhAlunoDaOlimpiada != 1) {
      exibirMensagem(
          context,
          "Desculpe, você não possui acesso a esta página pois não está cadastrado como competidor da olimpíada.",
          true);
    } else {
      Map<String, String> body = {
        'acao': 'olimpiadas_equipes_por_competidor',
        'cpf': cpf,
      };

      var response = await http.post(
        Uri.parse(Configuracao.urlWebservice),
        headers: Configuracao.getHeaders(),
        body: body,
      );

      // TODO: Verificar melhor forma;
      List<OlimpiadasEquipes> listaOlimpiadasEquipes = [];

      if (response.statusCode == 200) {
        print(response.body);

        Map<String, dynamic> mapOlimpiadasEquipesJson =
            json.decode(response.body);

        List<dynamic> listaOlimpiadasEquipesJson =
            mapOlimpiadasEquipesJson["listaOlimpiadasEquipes"];

        for (var olimpiadasEquipesJson in listaOlimpiadasEquipesJson) {
          listaOlimpiadasEquipes
              .add(OlimpiadasEquipes.fromJson(olimpiadasEquipesJson));
        }
      }
      return listaOlimpiadasEquipes;
    }

    // TODO: Verificar melhor forma;
    throw Exception('Ocorreu um erro.');
  }

  @override
  void initState() {
    carregaOlimpiadasEquipes().then((value) {
      setState(() {
        _listaOlimpiadasEquipes.addAll(value);
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Olimpíadas'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        bottomNavigationBar:
            OlimpiadasMenuInferior(Configuracao.menuOlimpiadasCompetidores),
        body: Column(
          children: [
            Container(
              color: Color(Configuracao.primayColor),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Minhas Equipes",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _listItem(context, index);
              },
              itemCount: _listaOlimpiadasEquipes.length,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            (!_loading && _listaOlimpiadasEquipes.isEmpty)
                ? Center(
                    child: Text(
                        "Aguarde! Em breve divulgaremos as equipes em que você está cadastrado."),
                  )
                : Container(),
          ],
        ));
  }

  _listItem(context, index) {
    return Card(
        shape: Border(
            left: BorderSide(color: Color(Configuracao.primayColor), width: 2)),
        elevation: 0.2,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OlimpiadasEquipeScreen(
                        _listaOlimpiadasEquipes[index])));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listaOlimpiadasEquipes[index].nomeEquipe != null
                      ? _listaOlimpiadasEquipes[index].nomeEquipe
                      : '',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}

exibirMensagem(BuildContext context, String mensagem, bool voltarPagina) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();

      if (voltarPagina) Navigator.of(context).pop();
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
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
