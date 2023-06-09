import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/programacao.dart';
import 'package:app_abramede_mg/screens/programacao_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ProgramacaoScreen extends StatefulWidget {
  @override
  _ProgramacaoScreenState createState() => _ProgramacaoScreenState();
}

class _ProgramacaoScreenState extends State<ProgramacaoScreen> {
  List<String> _listaDatas = [];
  List<String> _listaAreas = [];
  List<Programacao> _listaProgramacao = [];
  List<Programacao> _listaProgramacaoToDisplay = [];
  bool _loading = true;
  int _dataSelecionada = 0;
  int _areaSelecionada = 0;

  final campoPesquisaController = TextEditingController();
  @override
  void dispose() {
    campoPesquisaController.dispose();
    super.dispose();
  }

  Future<List<Programacao>> carregaProgramacao() async {
    Map<String, String> body = {
      'acao': 'programacao',
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    List<Programacao> listaProgramacao = [];

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapProgramacaoJson = json.decode(response.body);

      List<dynamic> listaAreasJson = mapProgramacaoJson["listaAreas"];
      _listaAreas.add("");
      for (var areasJson in listaAreasJson) {
        _listaAreas.add(areasJson);
      }

      List<dynamic> listaDatasJson = mapProgramacaoJson["listaDatas"];
      _listaDatas.add("");
      for (var dataJson in listaDatasJson) {
        _listaDatas.add(dataJson);
      }

      List<dynamic> listaProgramacaoJson =
          mapProgramacaoJson["listaProgramacao"];
      for (var programacaoJson in listaProgramacaoJson) {
        listaProgramacao.add(Programacao.fromJson(programacaoJson));
      }
    }

    return listaProgramacao;
  }

  @override
  void initState() {
    carregaProgramacao().then((value) {
      setState(() {
        _listaProgramacao.addAll(value);
        _listaProgramacaoToDisplay = _listaProgramacao;
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Programação'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return index == 0
                    ? _listViewAreas()
                    : index == 1
                        ? _listViewDatas()
                        : index == 2
                            ? _searchBar()
                            : _listItem(index - 3);
              },
              itemCount: _listaProgramacaoToDisplay.length + 3,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            (!_loading && _listaProgramacaoToDisplay.isEmpty)
                ? Center(
                    child: Text("Nenhuma programação encontrada."),
                  )
                : Container(),
          ],
        ));
  }

  pesquisar() {
    print(campoPesquisaController.text);
    print(_areaSelecionada);
    print(_dataSelecionada);

    setState(() {
      _listaProgramacaoToDisplay = _listaProgramacao;

      if (campoPesquisaController.text != "") {
        String texto = campoPesquisaController.text.toLowerCase();

        _listaProgramacaoToDisplay =
            _listaProgramacaoToDisplay.where((programacao) {
          var programacaoAtividade = programacao.atividade.toLowerCase();
          return programacaoAtividade.contains(texto);
        }).toList();
      }

      if (_areaSelecionada != 0) {
        _listaProgramacaoToDisplay =
            _listaProgramacaoToDisplay.where((programacao) {
          var programacaoArea = programacao.area;
          return programacaoArea.contains(_listaAreas[_areaSelecionada]);
        }).toList();
      }

      if (_dataSelecionada != 0) {
        _listaProgramacaoToDisplay =
            _listaProgramacaoToDisplay.where((programacao) {
          var programacaoData = programacao.data;
          return programacaoData.contains(_listaDatas[_dataSelecionada]);
        }).toList();
      }
    });
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: campoPesquisaController,
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          suffixIcon: Icon(
            FontAwesomeIcons.search,
            color: Color(Configuracao.primayColor),
          ),
          focusColor: Color(Configuracao.primayColor),
        ),
        onChanged: (text) {
          pesquisar();
        },
      ),
    );
  }

  _listItem(index) {
    return Card(
      shape: Border(
          left: BorderSide(color: Color(Configuracao.primayColor), width: 2)),
      elevation: 0.2,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProgramacaoDetalheScreen(_listaProgramacaoToDisplay[index]),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _listaProgramacaoToDisplay[index].area,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                _listaProgramacaoToDisplay[index].atividade,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.calendarCheck,
                    color: Color(Configuracao.primayColor),
                    size: 10,
                  ),
                  Text(
                    " " + _listaProgramacaoToDisplay[index].data + " ",
                    style: TextStyle(color: Color(Configuracao.primayColor)),
                  ),
                  Icon(
                    FontAwesomeIcons.clock,
                    color: Color(Configuracao.primayColor),
                    size: 10,
                  ),
                  Text(
                    " " + _listaProgramacaoToDisplay[index].periodo,
                    style: TextStyle(color: Color(Configuracao.primayColor)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _listViewDatas() {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _listItemData(index);
        },
        itemCount: _listaDatas.length,
      ),
    );
  }

  _listItemData(index) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5, right: 0, top: 5, left: 5),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              _dataSelecionada = index;
              pesquisar();
              /*
              _listaProgramacaoToDisplay =
                  _listaProgramacao.where((programacao) {
                var programacaoData = programacao.data;
                return programacaoData.contains(_listaDatas[index]);
              }).toList();

              if (_areaSelecionada != 0) {
                _listaProgramacaoToDisplay =
                    _listaProgramacaoToDisplay.where((programacao) {
                  var programacaoArea = programacao.area.toLowerCase();
                  return programacaoArea
                      .contains(_listaAreas[_areaSelecionada]);
                }).toList();
              }*/
            });
          },
          child: Text(
            _listaDatas[index] == "" ? "Todas as datas" : _listaDatas[index],
            style: index == _dataSelecionada
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Color(Configuracao.primayColor)),
          ),
          color: index == _dataSelecionada
              ? Color(Configuracao.primayColor)
              : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(Configuracao.primayColor))),
        ));
  }

  _listViewAreas() {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _listItemArea(index);
        },
        itemCount: _listaAreas.length,
      ),
    );
  }

  _listItemArea(index) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5, right: 0, top: 5, left: 5),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              _areaSelecionada = index;
              pesquisar();
              /*
              _listaProgramacaoToDisplay =
                  _listaProgramacao.where((programacao) {
                var programacaoArea = programacao.area;
                return programacaoArea.contains(_listaAreas[index]);
              }).toList();

              if (_dataSelecionada != 0) {
                _listaProgramacaoToDisplay =
                    _listaProgramacaoToDisplay.where((programacao) {
                  var programacaoData = programacao.data;
                  return programacaoData
                      .contains(_listaDatas[_dataSelecionada]);
                }).toList();

              }
              */
            });
          },
          child: Text(
            _listaAreas[index] == "" ? "Todas as áreas" : _listaAreas[index],
            style: index == _areaSelecionada
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Color(Configuracao.primayColor)),
          ),
          color: index == _areaSelecionada
              ? Color(Configuracao.primayColor)
              : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(Configuracao.primayColor))),
        ));
  }
}
