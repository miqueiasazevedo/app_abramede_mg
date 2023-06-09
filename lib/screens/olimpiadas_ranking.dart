import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_equipes.dart';
import 'package:app_abramede_mg/models/olimpiadas_modalidades.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'olimpiadas_equipe.dart';
import 'olimpiadas_menu_inferior.dart';

class OlimpiadasRankingScreen extends StatefulWidget {
  final OlimpiadasModalidades olimpiadasModalidadeAtual;

  OlimpiadasRankingScreen(this.olimpiadasModalidadeAtual);

  @override
  _OlimpiadasRankingScreenState createState() =>
      _OlimpiadasRankingScreenState(olimpiadasModalidadeAtual);
}

class _OlimpiadasRankingScreenState extends State<OlimpiadasRankingScreen> {
  final OlimpiadasModalidades olimpiadasModalidadeAtual;
  List<OlimpiadasEquipes> _listaOlimpiadasEquipes = [];
  bool _loading = true;

  _OlimpiadasRankingScreenState(this.olimpiadasModalidadeAtual);

  Future<List<OlimpiadasEquipes>> carregaOlimpiadasEquipes() async {
    Map<String, String> body = {
      'acao': 'olimpiadas_equipes',
      'modalidade': this.olimpiadasModalidadeAtual.id,
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

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
        title: Text('Ranking'),
        backgroundColor: Color(Configuracao.primayColor),
        toolbarHeight: Configuracao.toolbarHeight,
      ),
      bottomNavigationBar:
          OlimpiadasMenuInferior(Configuracao.menuOlimpiadasTorcedores),
      body: Column(
        children: [
          Container(
            color: Color(Configuracao.primayColor),
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  this.olimpiadasModalidadeAtual.sigla,
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
                      "Aguarde! Em breve divulgaremos as equipes dessa modalidade."),
                )
              : Container(),
        ],
      ),
    );
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
