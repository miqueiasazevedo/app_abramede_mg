import 'package:flutter/material.dart';
import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/screens/menu_lateral.dart';
import 'package:app_abramede_mg/screens/palestrante.dart';
import 'package:app_abramede_mg/screens/programacao.dart';
import 'package:app_abramede_mg/screens/olimpiadas_modalidades.dart';
import 'package:app_abramede_mg/screens/caso_clinico.dart';
import 'package:app_abramede_mg/screens/sobre.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  _abrirLinkInscricoes() async {
    Uri url = Uri.parse(
        "https://www.congressoabramede.org.br/inscricoes-e-informacoes");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  _abrirLinkFacebook() async {
    Uri url = Uri.parse("https://www.facebook.com/abramede2021/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  _abrirLinkInstagram() async {
    Uri url = Uri.parse("https://www.instagram.com/abramede2021/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  late CarouselSlider carouselSlider;
  // ignore: unused_field
  int _current = 0;
  List imgList = [
    Image.asset("images/apoio-institucional-amb.png"),
    Image.asset("images/apoio-institucional-ammg.png"),
    Image.asset("images/apoio-institucional-biblioteca-virtual.png"),
    Image.asset("images/apoio-institucional-casa-do-turismo.png"),
    Image.asset("images/apoio-institucional-sinmed.png")
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image.asset("images/logo_abramede.png",
              fit: BoxFit.contain, height: 36),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(Configuracao.primayColor)),
          elevation: 0,
          toolbarHeight: Configuracao.toolbarHeight,
          //brightness: Brightness.light,
        ),
        drawer: MenuLateral(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Image.asset("images/banner.png"),
              ),
              Container(
                color: Color(Configuracao.primayColor),
                height: 110,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 29, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1),
                        child: Center(
                          child: Text(
                            "23 a 25 de setembro de 2021",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 0, bottom: 20, right: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                          child: Text(
                            "O III ABRAMEDE MG ocorrerá de forma presencial e on-line.",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color(Configuracao.primayColor)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Center(
                          child: Text(
                            "O evento terá como temática central o ensino da Emergência da graduação à pós-graduação.",
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(Configuracao.primayColor)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: _abrirLinkInscricoes,
                            child: Text(
                              "Inscreva-se",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color(Configuracao.primayColor),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 0, bottom: 20, right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.calendarCheck),
                                          tooltip:
                                              'Programação do Congresso Abramede MG',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProgramacaoScreen(),
                                                ));
                                          },
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Programação',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Color(Configuracao.primayColor)),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.users),
                                          tooltip:
                                              'Palestrantes do Congresso Abramede MG',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PalestranteScreen(),
                                                ));
                                          },
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Palestrantes',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 60, top: 0, bottom: 20, right: 60),
                        child: Divider(
                          height: 1,
                          color: Color(Configuracao.primayColor),
                          thickness: 0.7,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 0, bottom: 20, right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.medal),
                                          tooltip:
                                              'Saiba mais sobre as olimpíadas do Congresso Abramede MG',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OlimpiadasModalidadesScreen(),
                                                ));
                                          },
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Olimpíadas',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                              Container(
                                  width: 1,
                                  height: 40,
                                  color: Color(Configuracao.primayColor)),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.checkSquare),
                                          tooltip:
                                              'Casos Clínicos do Congresso Abramede MG',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CasoClinicoScreen(),
                                                ));
                                          },
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Casos Clínicos',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 60, top: 0, bottom: 20, right: 60),
                        child: Divider(
                          height: 1,
                          color: Color(Configuracao.primayColor),
                          thickness: 0.7,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 0, bottom: 20, right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.info),
                                          tooltip:
                                              'Saiba mais sobre o Congresso Abramede MG',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SobreScreen(),
                                                ));
                                          },
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Sobre o evento',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Text("Apoio Institucional",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(Configuracao.primayColor)))),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 20),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 120.0,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 2),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 2000),
                          ),
                          items: imgList.map((imgAsset) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: imgAsset,
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Color(Configuracao.primayColor),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 20),
                          child: Text("Organização",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(Configuracao.primayColor)))),
                      Container(
                        width: double.infinity,
                        height: 70,
                        margin: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Image.asset("images/luiz-basso.png"),
                      ),
                      Divider(
                        height: 1,
                        color: Color(Configuracao.primayColor),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Text("Mídias Sociais",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(Configuracao.primayColor)))),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 30, bottom: 20, right: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(FontAwesomeIcons.facebook),
                                          tooltip: 'Facebook',
                                          onPressed: _abrirLinkFacebook,
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Facebook',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon:
                                              Icon(FontAwesomeIcons.instagram),
                                          tooltip: 'Instagram',
                                          onPressed: _abrirLinkInstagram,
                                          color:
                                              Color(Configuracao.primayColor),
                                        ),
                                        Text(
                                          'Instagram',
                                          style: TextStyle(
                                              color: Color(
                                                  Configuracao.primayColor)),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                margin: EdgeInsets.only(
                  top: 30,
                ),
              )
            ],
          ),
        ));
  }
}
