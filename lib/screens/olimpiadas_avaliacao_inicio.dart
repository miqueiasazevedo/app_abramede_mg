import 'dart:convert';
import 'package:app_abramede_mg/models/caso_clinico.dart';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/olimpiadas_equipes.dart';
import 'package:app_abramede_mg/models/olimpiadas_modalidades.dart';
import 'package:app_abramede_mg/screens/olimpiadas_menu_inferior.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'olimpiadas_avaliacao_aplicacao.dart';

class OlimpiadasAvaliacaoInicioScreen extends StatefulWidget {
  @override
  _OlimpiadasAvaliacaoInicioScreenState createState() =>
      _OlimpiadasAvaliacaoInicioScreenState();
}

class _OlimpiadasAvaliacaoInicioScreenState
    extends State<OlimpiadasAvaliacaoInicioScreen> {
  List<OlimpiadasModalidades> _listaOlimpiadasModalidades = [];
  List<OlimpiadasEquipes> _listaOlimpiadasEquipes = [];
  List<CasoClinico> _listaCasoClinico = [];

  late List<DropdownMenuItem<OlimpiadasModalidades>>
      _dropdownOlimpiadasModalidadesItems;
  late OlimpiadasModalidades _selectedOlimpiadasModalidadesItem;

  late List<DropdownMenuItem<OlimpiadasEquipes>>
      _dropdownOlimpiadasEquipesItems;
  late OlimpiadasEquipes _selectedOlimpiadasEquipesItem;

  late List<DropdownMenuItem<CasoClinico>> _dropdownCasoClinicoItems;
  late CasoClinico _selectedCasoClinicoItem;

  bool _loading = true;

  // ignore: missing_return
  Future<List<OlimpiadasModalidades>> carregaOlimpiadasAvaliacaoInicio() async {
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
        'acao': 'olimpiadas_avaliacao_inicio',
        'cpf': cpf,
      };

      var response = await http.post(
        Uri.parse(Configuracao.urlWebservice),
        headers: Configuracao.getHeaders(),
        body: body,
      );

      // TODO: Verificar melhor forma;
      List<OlimpiadasModalidades> listaOlimpiadasModalidades = [];

      if (response.statusCode == 200) {
        print(response.body);

        Map<String, dynamic> mapOlimpiadasAvaliacaoInicioJson =
            json.decode(response.body);

        List<dynamic> listaOlimpiadasModalidadesJson =
            mapOlimpiadasAvaliacaoInicioJson["listaOlimpiadasModalidades"];
        for (var olimpiadasModalidadesJson in listaOlimpiadasModalidadesJson) {
          _listaOlimpiadasModalidades
              .add(OlimpiadasModalidades.fromJson(olimpiadasModalidadesJson));
        }

        List<dynamic> listaOlimpiadasEquipesJson =
            mapOlimpiadasAvaliacaoInicioJson["listaOlimpiadasEquipes"];
        for (var olimpiadasEquipesJson in listaOlimpiadasEquipesJson) {
          _listaOlimpiadasEquipes
              .add(OlimpiadasEquipes.fromJson(olimpiadasEquipesJson));
        }

        List<dynamic> listaOlimpiadasCasosClinicosJson =
            mapOlimpiadasAvaliacaoInicioJson["listaOlimpiadasCasosClinicos"];
        for (var olimpiadasCasosClinicosJson
            in listaOlimpiadasCasosClinicosJson) {
          _listaCasoClinico
              .add(CasoClinico.fromJson(olimpiadasCasosClinicosJson));
        }
      }

      return listaOlimpiadasModalidades;
    }
    // TODO: Verificar melhor forma;
    throw Exception('Ocorreu um erro.');
  }

  @override
  void initState() {
    carregaOlimpiadasAvaliacaoInicio().then((value) {
      setState(() {
        _listaOlimpiadasModalidades.addAll(value);
        _dropdownOlimpiadasModalidadesItems =
            buildDropDownMenuModalidadesItems(_listaOlimpiadasModalidades);
        _selectedOlimpiadasModalidadesItem =
            _dropdownOlimpiadasModalidadesItems[0].value!;

        _dropdownOlimpiadasEquipesItems =
            buildDropDownMenuEquipesItems(_listaOlimpiadasEquipes);
        _selectedOlimpiadasEquipesItem =
            _dropdownOlimpiadasEquipesItems[0].value!;

        _dropdownCasoClinicoItems =
            buildDropDownMenuCasoClinicoItems(_listaCasoClinico);
        _selectedCasoClinicoItem = _dropdownCasoClinicoItems[0].value!;

        _loading = false;
      });
    });
    super.initState();
  }

  List<DropdownMenuItem<OlimpiadasModalidades>>
      buildDropDownMenuModalidadesItems(List listItems) {
    List<DropdownMenuItem<OlimpiadasModalidades>> items = [];

    OlimpiadasModalidades blankOlimpiadasModalidades =
        new OlimpiadasModalidades("0", "SELECIONE");
    items.add(
      DropdownMenuItem(
        child: Text(blankOlimpiadasModalidades.sigla),
        value: blankOlimpiadasModalidades,
      ),
    );

    for (OlimpiadasModalidades listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.sigla),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<OlimpiadasEquipes>> buildDropDownMenuEquipesItems(
      List listItems) {
    List<DropdownMenuItem<OlimpiadasEquipes>> items = [];

    OlimpiadasEquipes blankOlimpiadasEquipes =
        new OlimpiadasEquipes("0", "SELECIONE", "", "", "");
    items.add(
      DropdownMenuItem(
        child: Text(blankOlimpiadasEquipes.nomeEquipe),
        value: blankOlimpiadasEquipes,
      ),
    );

    for (OlimpiadasEquipes listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.nomeEquipe),
          value: listItem,
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<CasoClinico>> buildDropDownMenuCasoClinicoItems(
      List listItems) {
    List<DropdownMenuItem<CasoClinico>> items = [];

    CasoClinico blankCasoClinico = new CasoClinico("0", "SELECIONE", "");
    items.add(
      DropdownMenuItem(
        child: Text(blankCasoClinico.nomeCasoClinico),
        value: blankCasoClinico,
      ),
    );

    for (CasoClinico listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.nomeCasoClinico),
          value: listItem,
        ),
      );
    }
    return items;
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
            if (_selectedOlimpiadasModalidadesItem.id == "0" ||
                _selectedOlimpiadasEquipesItem.id == "0" ||
                _selectedCasoClinicoItem.id == "0") {
              exibirMensagem(context,
                  "Para prosseguir favor selecionar todos os campos", false);
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OlimpiadasAvaliacaoAplicacaoScreen(
                        _selectedOlimpiadasModalidadesItem,
                        _selectedOlimpiadasEquipesItem,
                        _selectedCasoClinicoItem),
                  ));
            }
          },
          label: const Text('Iniciar avaliação'),
          icon: const Icon(FontAwesomeIcons.clock),
          backgroundColor: Color(Configuracao.primayColor),
        ),
        bottomNavigationBar:
            OlimpiadasMenuInferior(Configuracao.menuOlimpiadasAvaliadores),
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
                      "Parâmetros da avaliação",
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
                                  "Modalidade:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(Configuracao.primayColor)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: DropdownButton<OlimpiadasModalidades>(
                                      isExpanded: true,
                                      value: _selectedOlimpiadasModalidadesItem,
                                      items:
                                          _dropdownOlimpiadasModalidadesItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedOlimpiadasModalidadesItem =
                                              value!;
                                        });
                                      }),
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
                                  "Equipe:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(Configuracao.primayColor)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: DropdownButton<OlimpiadasEquipes>(
                                      isExpanded: true,
                                      value: _selectedOlimpiadasEquipesItem,
                                      items: _dropdownOlimpiadasEquipesItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedOlimpiadasEquipesItem =
                                              value!;
                                        });
                                      }),
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
                                  "Avaliação:",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(Configuracao.primayColor)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: DropdownButton<CasoClinico>(
                                      isExpanded: true,
                                      value: _selectedCasoClinicoItem,
                                      items: _dropdownCasoClinicoItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCasoClinicoItem = value!;
                                        });
                                      }),
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
                    // ignore: unnecessary_null_comparison
                    (!_loading && _listaOlimpiadasModalidades == null)
                        ? Center(
                            child: Text(
                                "Aguarde! Em breve iremos liberar o início das avaliações."),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
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
