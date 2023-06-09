import 'dart:convert';
import 'package:app_abramede_mg/models/alternativa.dart';
import 'package:app_abramede_mg/models/caso_clinico.dart';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_equipes.dart';
import 'package:app_abramede_mg/models/olimpiadas_modalidades.dart';
import 'package:app_abramede_mg/models/pergunta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class OlimpiadasAvaliacaoAplicacaoScreen extends StatefulWidget {
  final OlimpiadasModalidades olimpiadasModalidades;
  final OlimpiadasEquipes olimpiadasEquipes;
  final CasoClinico casoClinico;

  OlimpiadasAvaliacaoAplicacaoScreen(
      this.olimpiadasModalidades, this.olimpiadasEquipes, this.casoClinico);

  @override
  _OlimpiadasAvaliacaoAplicacaoScreenState createState() =>
      _OlimpiadasAvaliacaoAplicacaoScreenState(
          olimpiadasModalidades, olimpiadasEquipes, casoClinico);
}

class _OlimpiadasAvaliacaoAplicacaoScreenState
    extends State<OlimpiadasAvaliacaoAplicacaoScreen> {
  final OlimpiadasModalidades _olimpiadasModalidades;
  final OlimpiadasEquipes _olimpiadasEquipes;
  final CasoClinico _casoClinico;

  _OlimpiadasAvaliacaoAplicacaoScreenState(
      this._olimpiadasModalidades, this._olimpiadasEquipes, this._casoClinico);

  late String idOlimpiadasPesquisa;
  List<Pergunta> _listaPergunta = [];
  List<Alternativa> _listaAlternativa = [];

  bool _loading = true;

  // ignore: missing_return
  Future<String> get carregaAvaliacaoAplicacao async {
    //Somente permite continuar na página se o usuário estiver logado e for um avaliador
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cpf = prefs.getString(Configuracao.spCpf);
    var spEhDaComissaoAvaliadoraDaOlimpiada =
        prefs.getInt(Configuracao.spEhDaComissaoAvaliadoraDaOlimpiada);

    if (cpf == null || spEhDaComissaoAvaliadoraDaOlimpiada != 1) {
      exibirMensagem(
          context,
          "Desculpe, você não possui acesso a esta página pois não está cadastrado para aplicar avaliações na olimpíada.",
          true);
    } else {
      Map<String, String> body = {
        'acao': 'get_avaliacao_aplicacao',
        'id_olimpiadas': _olimpiadasModalidades.id,
        'id_equipe': _olimpiadasEquipes.id,
        'id_pesquisa': _casoClinico.id,
        'cpf': cpf,
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
          idOlimpiadasPesquisa =
              mapDadosJson["id_olimpiadas_pesquisa"].toString();

          List<dynamic> listaPerguntaJson = mapDadosJson["listaPergunta"];
          for (var perguntaJson in listaPerguntaJson) {
            _listaPergunta.add(Pergunta.fromJson(perguntaJson));
          }

          List<dynamic> listaAlternativaJson = mapDadosJson["listaAlternativa"];
          for (var alternativaJson in listaAlternativaJson) {
            _listaAlternativa.add(Alternativa.fromJson(alternativaJson));
          }
        } else {
          exibirMensagem(context, mapDadosJson["mensagem"], true);
        }
      }

      return idOlimpiadasPesquisa;
    }

    // TODO: Verificar melhor forma;
    throw Exception('Ocorreu um erro.');
  }

  @override
  void initState() {
    carregaAvaliacaoAplicacao.then((value) {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Avaliação'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return listItemPergunta(index);
                    },
                    itemCount: _listaPergunta.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, right: 20, bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          _loading = true;
                        });

                        enviarResposta();
                      },
                      child: Text(
                        "Enviar avaliação",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Color(Configuracao.primayColor),
                    ),
                  ),
                ),
              ],
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            (!_loading && _listaPergunta.isEmpty)
                ? Center(
                    child: Text(
                        "Ainda não foram definidas perguntas e resposta para essa etapa."),
                  )
                : Container(),
          ],
        ));
  }

  listItemPergunta(indexPergunta) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 0.2,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_listaPergunta[indexPergunta].pergunta,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, indexAlternativa) {
                          return listItemAlternativa(
                              indexPergunta,
                              indexAlternativa,
                              getListaAlternativasByPergunta(
                                  _listaPergunta[indexPergunta]));
                        },
                        itemCount: getListaAlternativasByPergunta(
                                _listaPergunta[indexPergunta])
                            .length,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            height: 1,
            color: Color(Configuracao.primayColor),
            thickness: 0.7,
          ),
        ),
      ],
    );
  }

  listItemAlternativa(
      indexPergunta, indexAlternativa, List<Alternativa> listaAlternativas) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 0.1,
        color: Colors.white,
        child: RadioListTile(
          title: Text(listaAlternativas[indexAlternativa].alternativa),
          value: listaAlternativas[indexAlternativa].id,
          groupValue: _listaPergunta[indexAlternativa].opcaoEscolhida,
          onChanged: (String? valor) {
            setState(() {
              _listaPergunta[indexAlternativa].opcaoEscolhida = valor!;
            });
          },
        ),
      ),
    );
  }

  List<Alternativa> getListaAlternativasByPergunta(Pergunta pergunta) {
    List<Alternativa> listaAlternativaByPergunta = [];

    for (var i = 0; i < _listaAlternativa.length; i++) {
      if (_listaAlternativa[i].idPergunta == pergunta.id)
        listaAlternativaByPergunta.add(_listaAlternativa[i]);
    }

    return listaAlternativaByPergunta;
  }

  Future<void> enviarResposta() async {
    if (!marcouTodasPerguntas())
      exibirMensagem(context,
          "Favor assinalar uma resposta para todas as perguntas.", false);
    else {
      String respostas = "";
      for (var i = 0; i < _listaPergunta.length; i++)
        respostas += _listaPergunta[i].opcaoEscolhida + ",";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var idMatriculaComissaoAvaliadora =
          prefs.getString(Configuracao.idMatriculaComissaoAvaliadora);

      Map<String, String> body = {
        'acao': 'olimpiada_registrar_avaliacao',
        'id_olimpiadas_pesquisa': idOlimpiadasPesquisa,
        'id_matricula_comissao_avaliadora': idMatriculaComissaoAvaliadora!,
        'respostas': respostas,
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
          exibirMensagem(context, mapDadosJson["mensagem"], true);
        } else
          exibirMensagem(context, mapDadosJson["mensagem"], false);
      }
    }
  }

  bool marcouTodasPerguntas() {
    var marcouTodas = true;

    for (var i = 0; i < _listaPergunta.length; i++) {
      if (["", null, false, 0].contains(_listaPergunta[i].opcaoEscolhida))
        marcouTodas = false;
    }
    return marcouTodas;
  }

  exibirMensagem(BuildContext context, String mensagem, bool voltarPagina) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        setState(() {
          _loading = false;
        });

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
