import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/programacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ProgramacaoDetalheScreen extends StatefulWidget {
  final Programacao programacaoAtual;

  ProgramacaoDetalheScreen(this.programacaoAtual);

  @override
  _ProgramacaoDetalheScreenState createState() =>
      _ProgramacaoDetalheScreenState(programacaoAtual);
}

class _ProgramacaoDetalheScreenState extends State<ProgramacaoDetalheScreen> {
  final Programacao programacaoAtual;
  // ignore: unused_field
  bool _loading = true;

  _ProgramacaoDetalheScreenState(this.programacaoAtual);

  @override
  void initState() {
    setState(() {
      _loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe da programação'),
        backgroundColor: Color(Configuracao.primayColor),
        elevation: 0,
        toolbarHeight: Configuracao.toolbarHeight,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 0,
              ),
              child: Image.asset("images/banner_detalhe_programacao.png"),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  programacaoAtual.data,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(Configuracao.primayColor)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  programacaoAtual.periodo,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(Configuracao.primayColor)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Center(
                child: Text(
                  programacaoAtual.area,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(Configuracao.primayColor)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 40, bottom: 2, right: 20),
                  child: Text(
                    "ATIVIDADE:",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(Configuracao.primayColor),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 0, right: 20, bottom: 20),
              child: Divider(
                height: 1,
                color: Color(Configuracao.primayColor),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, bottom: 2, right: 20),
                  child: Text(
                    programacaoAtual.atividade,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(Configuracao.primayColor),
                    ),
                  ),
                ),
              ],
            ),
            programacaoAtual.outrasInformacoes == ""
                ? (Container())
                : (Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 40, bottom: 2, right: 20),
                        child: Text(
                          "INFORMAÇÕES:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(Configuracao.primayColor),
                          ),
                        ),
                      ),
                    ],
                  )),
            programacaoAtual.outrasInformacoes == ""
                ? (Container())
                : (Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 0, right: 20, bottom: 0),
                    child: Divider(
                      height: 1,
                      color: Color(Configuracao.primayColor),
                    ),
                  )),
            programacaoAtual.outrasInformacoes == ""
                ? (Container())
                : (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 0, bottom: 2, right: 20),
                        child: Html(
                          data: programacaoAtual.outrasInformacoes,
                          style: {
                            "body": Style(
                              color: Color(Configuracao.primayColor),
                            ),
                          },
                        ),
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
