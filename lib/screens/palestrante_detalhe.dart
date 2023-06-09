import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/models/palestrante.dart';
import 'package:app_abramede_mg/models/programacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_abramede_mg/screens/programacao_detalhe.dart';

// ignore: must_be_immutable
class PalestranteDetalheScreen extends StatefulWidget {
  final Palestrante palestranteAtual;
  List<Programacao> listaProgramacao;

  PalestranteDetalheScreen(this.palestranteAtual, this.listaProgramacao);

  @override
  _PalestranteDetalheScreenState createState() =>
      _PalestranteDetalheScreenState(palestranteAtual, listaProgramacao);
}

class _PalestranteDetalheScreenState extends State<PalestranteDetalheScreen> {
  final Palestrante palestranteAtual;
  List<Programacao> listaProgramacao;
  // ignore: unused_field
  bool _loading = true;

  _PalestranteDetalheScreenState(this.palestranteAtual, this.listaProgramacao);

  @override
  void initState() {
    setState(() {
      _loading = false;

      listaProgramacao = listaProgramacao.where((programacao) {
        var programacaoIdPalestrante = programacao.idPalestrante;
        return programacaoIdPalestrante.contains(palestranteAtual.id);
      }).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Detalhe do palestrante'),
        backgroundColor: Color(Configuracao.primayColor),
        elevation: 0,
        toolbarHeight: Configuracao.toolbarHeight,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Image.asset("images/banner_detalhe_programacao.png"),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: palestranteAtual.urlImagemPerfil == ""
                        ? NetworkImage("images/palestrante.png")
                        : NetworkImage(palestranteAtual.urlImagemPerfil),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Text(
                  palestranteAtual.nome,
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
                  palestranteAtual.localidade,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(Configuracao.primayColor)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            palestranteAtual.miniCurriculo == ""
                ? (Container())
                : (Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 40, bottom: 2, right: 20),
                        child: Text(
                          "MINICURRÍCULO:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(Configuracao.primayColor),
                          ),
                        ),
                      ),
                    ],
                  )),
            palestranteAtual.miniCurriculo == ""
                ? (Container())
                : (Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 0, right: 20, bottom: 0),
                    child: Divider(
                      height: 1,
                      color: Color(Configuracao.primayColor),
                    ),
                  )),
            palestranteAtual.miniCurriculo == ""
                ? (Container())
                : (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 0, bottom: 2, right: 20),
                        child: Html(
                          data: palestranteAtual.miniCurriculo,
                          style: {
                            "body": Style(
                              color: Color(Configuracao.primayColor),
                            ),
                          },
                        ),
                      ),
                    ],
                  )),
            listaProgramacao.length == 0
                ? (Container())
                : (Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, top: 40, bottom: 2, right: 20),
                        child: Text(
                          "PROGRAMAÇÃO:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(Configuracao.primayColor),
                          ),
                        ),
                      ),
                    ],
                  )),
            listaProgramacao.length == 0
                ? (Container())
                : (Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 0, right: 20, bottom: 0),
                    child: Divider(
                      height: 1,
                      color: Color(Configuracao.primayColor),
                    ),
                  )),
            listaProgramacao.length == 0
                ? (Container())
                : (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < listaProgramacao.length; i++)
                        _listItemProgramacao(i)
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  _listItemProgramacao(index) {
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
                    ProgramacaoDetalheScreen(listaProgramacao[index]),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listaProgramacao[index].area,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                listaProgramacao[index].atividade,
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
                    " " + listaProgramacao[index].data + " ",
                    style: TextStyle(color: Color(Configuracao.primayColor)),
                  ),
                  Icon(
                    FontAwesomeIcons.clock,
                    color: Color(Configuracao.primayColor),
                    size: 10,
                  ),
                  Text(
                    " " + listaProgramacao[index].periodo,
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
}
