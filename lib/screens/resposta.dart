import 'dart:convert';
import 'package:app_abramede_mg/models/alternativa.dart';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/pergunta.dart';
import 'package:app_abramede_mg/models/resposta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class RespostaScreen extends StatefulWidget {
  final String idCasoClinico;

  RespostaScreen(this.idCasoClinico);

  @override
  _RespostaScreenState createState() => _RespostaScreenState(idCasoClinico);
}

class _RespostaScreenState extends State<RespostaScreen> {
  final String idCasoClinico;
  late Resposta _resposta;
  List<Alternativa> _listaAlternativa = [];
  List<Alternativa> _listaAlternativaToDisplay = [];
  Pergunta _pergunta = new Pergunta("", "", "");
  String opcaoEscolhida = "";
  bool _loading = true;

  _RespostaScreenState(this.idCasoClinico);

  Future<Resposta> carregaResposta() async {
    Map<String, String> body = {
      'acao': 'get_pergunta_atual',
      'id_caso_clinico': idCasoClinico,
    };

    print("id_caso_clinico2:" + idCasoClinico);

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    // TODO: Verificar forma melhor
    List<Alternativa> listaAlternativa = [];

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapAlternativaJson = json.decode(response.body);

      _pergunta = new Pergunta(
          mapAlternativaJson["id_pergunta"],
          mapAlternativaJson["pergunta"],
          mapAlternativaJson["opcao_escolhida"]);

      List<dynamic> listaAlternativaJson =
          mapAlternativaJson["listaAlternativa"];

      for (var alternativaJson in listaAlternativaJson) {
        listaAlternativa.add(Alternativa.fromJson(alternativaJson));
      }
    }

    _resposta = new Resposta("", "", _pergunta, listaAlternativa);

    return _resposta;
  }

  @override
  void initState() {
    carregaResposta().then((value) {
      setState(() {
        _listaAlternativa.addAll(value.listAlternativa);
        _listaAlternativaToDisplay = _listaAlternativa;
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pergunta'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                  child: Text(
                    _pergunta.pergunta,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(Configuracao.primayColor)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return _listItem(index);
                    },
                    itemCount: _listaAlternativaToDisplay.length,
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

                        _enviarResposta(context, idCasoClinico, _pergunta.id,
                            opcaoEscolhida);
                      },
                      child: Text(
                        "Enviar",
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
            (!_loading && _listaAlternativaToDisplay.isEmpty)
                ? Center(
                    child: Text(
                        "Aguarde! Em breve as alternativas serão disponibilizadas."),
                  )
                : Container(),
          ],
        ));
  }

  _listItem(index) {
    return Card(
      elevation: 0.2,
      color: Colors.white70,
      child: RadioListTile(
        title: Text(_listaAlternativa[index].alternativa),
        value: _listaAlternativa[index].id,
        groupValue: opcaoEscolhida,
        onChanged: (String? valor) {
          setState(() {
            opcaoEscolhida = valor!;
          });
        },
      ),
    );
  }

  Future<void> _enviarResposta(context, String idCasoClinico, String idPergunta,
      String idAlternativa) async {
    if (idAlternativa == "")
      exibirMensagem(context, "Marque uma das opções.");
    else {
      Map<String, String> body = {
        'acao': 'registrar_resposta',
        'id_caso_clinico': idCasoClinico,
        'id_pergunta': idPergunta,
        'id_alternativa': idAlternativa,
      };

      var response = await http.post(
        Uri.parse(Configuracao.urlWebservice),
        headers: Configuracao.getHeaders(),
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);

        Navigator.of(context).pop();
      }
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
}
