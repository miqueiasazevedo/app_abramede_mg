import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_modalidades.dart';
import 'package:app_abramede_mg/screens/olimpiadas_menu_inferior.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'olimpiadas_ranking.dart';

class OlimpiadasModalidadesScreen extends StatefulWidget {
  @override
  _OlimpiadasModalidadesScreenState createState() =>
      _OlimpiadasModalidadesScreenState();
}

class _OlimpiadasModalidadesScreenState
    extends State<OlimpiadasModalidadesScreen> {
  List<OlimpiadasModalidades> _listaOlimpiadasModalidades = [];
  bool _loading = true;

  Future<List<OlimpiadasModalidades>> carregaOlimpiadasModalidades() async {
    Map<String, String> body = {
      'acao': 'olimpiadas_modalidades',
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    List<OlimpiadasModalidades> listaOlimpiadasModalidades = [];

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapOlimpiadasModalidadesJson =
          json.decode(response.body);

      List<dynamic> listaOlimpiadasModalidadesJson =
          mapOlimpiadasModalidadesJson["listaOlimpiadasModalidades"];

      for (var olimpiadasModalidadesJson in listaOlimpiadasModalidadesJson) {
        listaOlimpiadasModalidades
            .add(OlimpiadasModalidades.fromJson(olimpiadasModalidadesJson));
      }
    }
    return listaOlimpiadasModalidades;
  }

  @override
  void initState() {
    carregaOlimpiadasModalidades().then((value) {
      setState(() {
        _listaOlimpiadasModalidades.addAll(value);
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
            OlimpiadasMenuInferior(Configuracao.menuOlimpiadasTorcedores),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color(Configuracao.primayColor),
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "Modalidades",
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
                itemCount: _listaOlimpiadasModalidades.length,
              ),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              (!_loading && _listaOlimpiadasModalidades.isEmpty)
                  ? Center(
                      child: Text(
                          "Aguarde! Em breve divulgaremos as modalidades das olimpíadas."),
                    )
                  : Container(),
            ],
          ),
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
                    builder: (context) => OlimpiadasRankingScreen(
                        _listaOlimpiadasModalidades[index])));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listaOlimpiadasModalidades[index].sigla != null
                      ? _listaOlimpiadasModalidades[index].sigla
                      : '',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }
}
