import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_avaliacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'olimpiadas_menu_inferior.dart';

class OlimpiadasAvaliacaoDetalhamentoScreen extends StatefulWidget {
  final OlimpiadasAvaliacao olimpiadasAvaliacaoAtual;

  OlimpiadasAvaliacaoDetalhamentoScreen(this.olimpiadasAvaliacaoAtual);

  @override
  _OlimpiadasAvaliacaoDetalhamentoScreenState createState() =>
      _OlimpiadasAvaliacaoDetalhamentoScreenState(olimpiadasAvaliacaoAtual);
}

class _OlimpiadasAvaliacaoDetalhamentoScreenState
    extends State<OlimpiadasAvaliacaoDetalhamentoScreen> {
  final OlimpiadasAvaliacao olimpiadasAvaliacaoAtual;
  String detalhamentoHtml = "";
  bool _loading = true;

  _OlimpiadasAvaliacaoDetalhamentoScreenState(this.olimpiadasAvaliacaoAtual);

  // ignore: missing_return
  Future<String> carregaOlimpiadasAvaliacaoDetalhamento() async {
    Map<String, String> body = {
      'acao': 'olimpiadas_avaliacoes_detalhamento',
      'id_olimpiadas_pesquisa': olimpiadasAvaliacaoAtual.id,
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapDadosJson = json.decode(response.body);

      if (mapDadosJson["sucesso"]) {
        detalhamentoHtml = mapDadosJson["detalhamentoHtml"];
      } else {
        exibirMensagem(context, mapDadosJson["mensagem"], true);
      }

      return detalhamentoHtml;
    }
    // TODO: Verificar melhor forma;
    throw Exception('Ocorreu um erro.');
  }

  @override
  void initState() {
    carregaOlimpiadasAvaliacaoDetalhamento().then((value) {
      setState(() {
        detalhamentoHtml = value;
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
          title: Text(this.olimpiadasAvaliacaoAtual.nomeEquipe),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        bottomNavigationBar:
            OlimpiadasMenuInferior(Configuracao.menuOlimpiadasTorcedores),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Color(Configuracao.primayColor),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Detalhamento da avaliação aplicada",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 20, bottom: 20, right: 20),
                    child: Column(
                      children: [
                        Html(data: detalhamentoHtml),
                        _loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(),
                        (!_loading && detalhamentoHtml == "")
                            ? Center(
                                child: Text(
                                    "Aguarde! Em breve divulgaremos o detalhamento da avaliação aplicada para esta equipe."),
                              )
                            : Container(),
                      ],
                    )))
          ]),
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
