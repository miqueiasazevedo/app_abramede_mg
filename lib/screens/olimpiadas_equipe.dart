import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_avaliacao.dart';
import 'package:app_abramede_mg/models/olimpiadas_equipes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'olimpiadas_avaliacao_detalhamento.dart';
import 'olimpiadas_menu_inferior.dart';

class OlimpiadasEquipeScreen extends StatefulWidget {
  final OlimpiadasEquipes olimpiadasEquipeAtual;

  OlimpiadasEquipeScreen(this.olimpiadasEquipeAtual);

  @override
  _OlimpiadasEquipeScreenState createState() =>
      _OlimpiadasEquipeScreenState(olimpiadasEquipeAtual);
}

class _OlimpiadasEquipeScreenState extends State<OlimpiadasEquipeScreen>
    with TickerProviderStateMixin {
  final OlimpiadasEquipes olimpiadasEquipeAtual;
  List<OlimpiadasAvaliacao> _listaOlimpiadasAvaliacao = [];
  late TabController _tabController;
  bool _loading = true;

  _OlimpiadasEquipeScreenState(this.olimpiadasEquipeAtual);

  // ignore: missing_return
  Future<List<OlimpiadasAvaliacao>> carregaOlimpiadasAvaliacoes() async {
    Map<String, String> body = {
      'acao': 'olimpiadas_avaliacoes_por_equipe',
      'id_olimpiadas_equipe': olimpiadasEquipeAtual.id,
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    // TODO: Verificar melhor forma;
    List<OlimpiadasAvaliacao> listaOlimpiadasAvaliacoesPorEquipe = [];

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapDadosJson = json.decode(response.body);

      if (mapDadosJson["sucesso"]) {
        List<dynamic> listaOlimpiadasAvaliacaoJson =
            mapDadosJson["listaOlimpiadasAvaliacoesPorEquipe"];

        for (var olimpiadasAvaliacaoJson in listaOlimpiadasAvaliacaoJson) {
          listaOlimpiadasAvaliacoesPorEquipe
              .add(OlimpiadasAvaliacao.fromJson(olimpiadasAvaliacaoJson));
        }
      } else {
        exibirMensagem(context, mapDadosJson["mensagem"], true);
      }

      return listaOlimpiadasAvaliacoesPorEquipe;
    }

    // TODO: Verificar melhor forma;
    throw Exception('Ocorreu um erro.');
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    carregaOlimpiadasAvaliacoes().then((value) {
      setState(() {
        _tabController = TabController(length: 2, vsync: this);
        _listaOlimpiadasAvaliacao.addAll(value);
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
        title: Text(this.olimpiadasEquipeAtual.nomeEquipe),
        backgroundColor: Color(Configuracao.primayColor),
        toolbarHeight: Configuracao.toolbarHeight * 1.5,
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Dados da equipe',
            ),
            Tab(
              text: 'Avaliações',
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          OlimpiadasMenuInferior(Configuracao.menuOlimpiadasTorcedores),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Color(Configuracao.primayColor),
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        "Informações cadastrais",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 30.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Líder:",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(Configuracao.primayColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child:
                                        Text(olimpiadasEquipeAtual.nomeEquipe,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Membros:",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(Configuracao.primayColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        olimpiadasEquipeAtual.membros != null
                                            ? olimpiadasEquipeAtual.membros
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Professor responsável:",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(Configuracao.primayColor)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        olimpiadasEquipeAtual
                                                    .nomeProfessorResponsavel !=
                                                null
                                            ? olimpiadasEquipeAtual
                                                .nomeProfessorResponsavel
                                            : '',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _loading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(),
                      (!_loading && olimpiadasEquipeAtual == null)
                          ? Center(
                              child: Text(
                                  "Aguarde! Em breve divulgaremos os dados dessa equipe."),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
              child: Column(
            children: [
              Container(
                color: Color(Configuracao.primayColor),
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "Avaliações aplicadas para a equipe",
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
                itemCount: _listaOlimpiadasAvaliacao.length,
              ),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              (!_loading && _listaOlimpiadasAvaliacao.isEmpty)
                  ? Center(
                      child: Text(
                          "Ainda não foram lançadas avaliações para esta equipe."),
                    )
                  : Container(),
            ],
          )),
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
                    builder: (context) => OlimpiadasAvaliacaoDetalhamentoScreen(
                        _listaOlimpiadasAvaliacao[index])));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listaOlimpiadasAvaliacao[index].nomePesquisaInstantanea !=
                          null
                      ? _listaOlimpiadasAvaliacao[index].nomePesquisaInstantanea
                      : '',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
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
}
