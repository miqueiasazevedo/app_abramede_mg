import 'dart:convert';
import 'package:app_abramede_mg/models/caso_clinico.dart';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'resposta.dart';

class CasoClinicoScreen extends StatefulWidget {
  @override
  _CasoClinicoScreenState createState() => _CasoClinicoScreenState();
}

class _CasoClinicoScreenState extends State<CasoClinicoScreen> {
  List<CasoClinico> _listaCasoClinico = [];
  List<CasoClinico> _listaCasoClinicoToDisplay = [];
  bool _loading = true;

  Future<List> carregaCasoClinico() async {
    Map<String, String> body = {
      'acao': 'cosos_clinicos',
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    var listaCasoClinico = [];

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapCasoClinicoJson = json.decode(response.body);

      List<dynamic> listaCasoClinicoJson =
          mapCasoClinicoJson["listaCasosClinicos"];

      // ignore: unnecessary_null_comparison
      if (listaCasoClinicoJson != null) {
        for (var casoClinicoJson in listaCasoClinicoJson) {
          listaCasoClinico.add(CasoClinico.fromJson(casoClinicoJson));
        }
      }
    }
    return listaCasoClinico;
  }

  @override
  void initState() {
    carregaCasoClinico().then((value) {
      setState(() {
        _listaCasoClinico.addAll(value as Iterable<CasoClinico>);
        _listaCasoClinicoToDisplay = _listaCasoClinico;
        _loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Casos Clínicos'),
          backgroundColor: Color(Configuracao.primayColor),
          elevation: 0,
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, index) {
                return index == 0
                    ? _searchBar()
                    : _listItem(context, index - 1);
              },
              itemCount: _listaCasoClinicoToDisplay.length + 1,
            ),
            _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            (!_loading && _listaCasoClinicoToDisplay.isEmpty)
                ? Center(
                    child: Text(
                        "Aguarde! Em breve divulgaremos os casos clínicos."),
                  )
                : Container(),
          ],
        ));
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          suffixIcon: Icon(
            FontAwesomeIcons.search,
            color: Color(Configuracao.primayColor),
          ),
          focusColor: Color(Configuracao.primayColor),
        ),
        onChanged: (text) {
          text = text.toLowerCase();

          setState(() {
            _listaCasoClinicoToDisplay = _listaCasoClinico.where((casoClinico) {
              var casoClinicoNome = casoClinico.nomeCasoClinico.toLowerCase();
              return casoClinicoNome.contains(text);
            }).toList();
          });
        },
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
            checkStatusCasoClinico(
                context, _listaCasoClinicoToDisplay[index].id);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _listaCasoClinicoToDisplay[index].nomeCasoClinico,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      color: Color(Configuracao.primayColor),
                      size: 10,
                    ),
                    Text(
                      " " + _listaCasoClinicoToDisplay[index].descritivo + " ",
                      style: TextStyle(color: Color(Configuracao.primayColor)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

Future<void> checkStatusCasoClinico(context, String idCasoClinico) async {
  Map<String, String> body = {
    'acao': 'check_status_caso_clinico',
    'id_caso_clinico': idCasoClinico,
  };

  var response = await http.post(
    Uri.parse(Configuracao.urlWebservice),
    headers: Configuracao.getHeaders(),
    body: body,
  );

  if (response.statusCode == 200) {
    print(response.body);

    Map<String, dynamic> mapStatusCasoClinicoJson = json.decode(response.body);

    if (mapStatusCasoClinicoJson["status_caso_clinico"] == "0") {
      exibirMensagem(context,
          "Este caso clínico ainda não está disponível. Aguarde a liberação do Palestrante para respostas.");
    } else {
      print("id_caso_clinico1:" + idCasoClinico);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RespostaScreen(idCasoClinico),
          ));
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
