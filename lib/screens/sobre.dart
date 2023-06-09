import 'dart:convert';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/sobre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SobreScreen extends StatefulWidget {
  @override
  _SobreScreenState createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  Sobre _sobre = new Sobre("");
  bool _loading = true;

  Future<Sobre> carregaInformacoes() async {
    Map<String, String> body = {
      'acao': 'sobre',
    };

    var response = await http.post(
      Uri.parse(Configuracao.urlWebservice),
      headers: Configuracao.getHeaders(),
      body: body,
    );

    late Sobre sobre;

    if (response.statusCode == 200) {
      print(response.body);

      Map<String, dynamic> mapSobreJson = json.decode(response.body);

      List<dynamic> listaSobreJson = mapSobreJson["sobre"];

      for (var sobreJson in listaSobreJson) {
        sobre = Sobre.fromJson(sobreJson);
      }
    }

    return sobre;
  }

  @override
  void initState() {
    carregaInformacoes().then((value) {
      setState(() {
        _sobre = value;
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
          title: Text('Sobre o Evento'),
          backgroundColor: Color(Configuracao.primayColor),
          toolbarHeight: Configuracao.toolbarHeight,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Color(Configuracao.primayColor),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    "III CONGRESSO MINEIRO DE MEDICINA DE EMERGÊNCIA",
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
                        Html(data: _sobre.informacao),
                        _loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(),
                        (!_loading && _sobre.informacao == "")
                            ? Center(
                                child: Text(
                                    "Aguarde! Em breve divulgaremos informações sobre o evento."),
                              )
                            : Container(),
                      ],
                    )))
          ]),
        ));
  }
}
