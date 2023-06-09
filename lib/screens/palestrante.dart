import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/palestrante.dart';
import 'package:app_abramede_mg/models/programacao.dart';
import 'package:app_abramede_mg/screens/palestrante_detalhe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class PalestranteScreen extends StatefulWidget {
  @override
  _PalestranteScreenState createState() => _PalestranteScreenState();
}

class _PalestranteScreenState extends State<PalestranteScreen> {
  List<Palestrante> _listaPalestrante = [];
  List<Palestrante> _listaPalestranteToDisplay = [];
  List<Programacao> _listaProgramacao = [];
  // ignore: unused_field
  List<Programacao> _listaProgramacaoToSend = [];
  List<String> _listaInternacional = [];
  bool _loading = true;
  int _filtroInternacionalSelecionado = 0;

  final campoPesquisaController = TextEditingController();
  @override
  void dispose() {
    campoPesquisaController.dispose();
    super.dispose();
  }

  Future<List<Palestrante>> carregaPalestrante() async {
    Map<String, String> body = {
      'acao': 'palestrante',
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    List<Palestrante> listaPalestrante = [];

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapPalestranteJson = json.decode(response.body);

      List<dynamic> listaInternacionalJson =
          mapPalestranteJson["listaInternacional"];
      _listaInternacional.add("");
      for (var internacionalJson in listaInternacionalJson) {
        _listaInternacional.add(internacionalJson);
      }

      List<dynamic> listaPalestranteJson =
          mapPalestranteJson["listaPalestrante"];

      for (var palestranteJson in listaPalestranteJson) {
        listaPalestrante.add(Palestrante.fromJson(palestranteJson));
      }

      List<dynamic> listaProgramacaoJson =
          mapPalestranteJson["listaProgramacao"];
      for (var programacaoJson in listaProgramacaoJson) {
        _listaProgramacao.add(Programacao.fromJson(programacaoJson));
      }
    }
    return listaPalestrante;
  }

  @override
  void initState() {
    carregaPalestrante().then((value) {
      setState(() {
        _listaPalestrante.addAll(value);
        _listaPalestranteToDisplay = _listaPalestrante;
        _listaProgramacaoToSend = _listaProgramacao;
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Palestrantes'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return index == 0
                    ? _listViewInternacional()
                    : index == 1
                        ? _searchBar()
                        : _listItem(index - 2);
              },
              itemCount: _listaPalestranteToDisplay.length + 2,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            (!_loading && _listaPalestranteToDisplay.isEmpty)
                ? Center(
                    child: Text(
                        "Aguarde! Em breve divulgaremos a lista de palestrantes."),
                  )
                : Container(),
          ],
        ));
  }

  pesquisar() {
    print(campoPesquisaController.text);
    print(_filtroInternacionalSelecionado);

    setState(() {
      _listaPalestranteToDisplay = _listaPalestrante;

      if (campoPesquisaController.text != "") {
        String texto = campoPesquisaController.text.toLowerCase();

        _listaPalestranteToDisplay =
            _listaPalestranteToDisplay.where((palestrante) {
          var palestranteNome = palestrante.nome.toLowerCase();
          return palestranteNome.contains(texto);
        }).toList();
      }

      if (_filtroInternacionalSelecionado != 0) {
        _listaPalestranteToDisplay =
            _listaPalestranteToDisplay.where((palestrante) {
          var palestranteInternacional = palestrante.internacional;
          return palestranteInternacional
              .contains(_listaInternacional[_filtroInternacionalSelecionado]);
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
                builder: (context) => PalestranteDetalheScreen(
                    _listaPalestranteToDisplay[index], _listaProgramacao),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    _listaPalestranteToDisplay[index].urlImagemPerfil == ""
                        ? NetworkImage("images/palestrante.png")
                        : NetworkImage(
                            _listaPalestranteToDisplay[index].urlImagemPerfil),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _listaPalestranteToDisplay[index].nome,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapPin,
                          color: Color(Configuracao.primayColor),
                          size: 10,
                        ),
                        Text(
                          " " +
                              _listaPalestranteToDisplay[index].localidade +
                              " ",
                          style:
                              TextStyle(color: Color(Configuracao.primayColor)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listViewInternacional() {
    return Container(
      margin: EdgeInsets.all(5.0),
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _listItemInternacional(index);
        },
        itemCount: _listaInternacional.length,
      ),
    );
  }

  _listItemInternacional(index) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5, right: 0, top: 5, left: 5),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              _filtroInternacionalSelecionado = index;
              pesquisar();
            });
          },
          child: Text(
            _listaInternacional[index] == ""
                ? "Todos"
                : _listaInternacional[index],
            style: index == _filtroInternacionalSelecionado
                ? TextStyle(color: Colors.white)
                : TextStyle(color: Color(Configuracao.primayColor)),
          ),
          color: index == _filtroInternacionalSelecionado
              ? Color(Configuracao.primayColor)
              : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(Configuracao.primayColor))),
        ));
  }
}
