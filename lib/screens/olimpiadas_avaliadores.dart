import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_avaliacao.dart';
import 'package:app_abramede_mg/screens/olimpiadas_avaliacao_detalhamento.dart';
import 'package:app_abramede_mg/screens/olimpiadas_menu_inferior.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'olimpiadas_avaliacao_inicio.dart';

class OlimpiadasAvaliadoresScreen extends StatefulWidget {
  @override
  _OlimpiadasAvaliadoresScreenState createState() =>
      _OlimpiadasAvaliadoresScreenState();
}

class _OlimpiadasAvaliadoresScreenState
    extends State<OlimpiadasAvaliadoresScreen> {
  List<OlimpiadasAvaliacao> _listaOlimpiadasAvaliacao = [];
  bool _loading = true;

  // ignore: missing_return
  Future<List<OlimpiadasAvaliacao>> carregaOlimpiadasAvaliacoes() async {
    //Somente permite continuar na página se o usuário estiver logado e for um avaliador
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cpf = prefs.getString(Configuracao.spCpf);
    var spEhDaComissaoAvaliadoraDaOlimpiada =
        prefs.getInt(Configuracao.spEhDaComissaoAvaliadoraDaOlimpiada);

    if (cpf == null || spEhDaComissaoAvaliadoraDaOlimpiada != 1) {
      exibirMensagem(
          context,
          "Desculpe, você não possui acesso a esta página pois não está cadastrado como avaliador da olimpíada.",
          true);
    } else {
      Map<String, String> body = {
        'acao': 'olimpiadas_avaliacoes_por_avaliador',
        'cpf': cpf,
      };

      var response = await http.post(
        Uri.parse(Configuracao.urlWebservice),
        headers: Configuracao.getHeaders(),
        body: body,
      );

      // TODO: Verificar melhor forma;
      List<OlimpiadasAvaliacao> listaOlimpiadasAvaliacoesPorAvaliador = [];

      if (response.statusCode == 200) {
        print(response.body);

        Map<String, dynamic> mapOlimpiadasAvaliacaoJson =
            json.decode(response.body);

        List<dynamic> listaOlimpiadasAvaliacaoJson =
            mapOlimpiadasAvaliacaoJson["listaOlimpiadasAvaliacoesPorAvaliador"];

        for (var olimpiadasAvaliacaoJson in listaOlimpiadasAvaliacaoJson) {
          listaOlimpiadasAvaliacoesPorAvaliador
              .add(OlimpiadasAvaliacao.fromJson(olimpiadasAvaliacaoJson));
        }
      }
      return listaOlimpiadasAvaliacoesPorAvaliador;
    }

    // TODO: Verificar melhor forma;
    throw Exception('Ocorreu um erro.');
  }

  @override
  void initState() {
    carregaOlimpiadasAvaliacoes().then((value) {
      setState(() {
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
          title: Text('Olimpíadas'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OlimpiadasAvaliacaoInicioScreen(),
                ));
          },
          label: const Text('Adicionar'),
          icon: const Icon(FontAwesomeIcons.plus),
          backgroundColor: Color(Configuracao.primayColor),
        ),
        bottomNavigationBar:
            OlimpiadasMenuInferior(Configuracao.menuOlimpiadasAvaliadores),
        body: Column(
          children: [
            Container(
              color: Color(Configuracao.primayColor),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "Minhas Avaliações",
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
                    child: Text("Ainda não foram lançadas avaliações."),
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
