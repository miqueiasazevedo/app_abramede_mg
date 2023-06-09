import 'package:app_abramede_mg/models/config_model.dart';
import 'package:app_abramede_mg/screens/caso_clinico.dart';
import 'package:app_abramede_mg/screens/palestrante.dart';
import 'package:app_abramede_mg/screens/programacao.dart';
import 'package:app_abramede_mg/screens/sobre.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home.dart';
import 'olimpiadas_modalidades.dart';

class MenuLateral extends StatelessWidget {
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

  _deslogar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove(Configuracao.spNome);
    prefs.remove(Configuracao.spCpf);
    prefs.remove(Configuracao.spEhAlunoDaOlimpiada);
    prefs.remove(Configuracao.spEhDaComissaoAvaliadoraDaOlimpiada);
    prefs.remove(Configuracao.idMatriculaComissaoAvaliadora);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        margin: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Image.asset("images/logotipo-abramede-2021.png"),
                      ),
                      Text(
                        'III CONGRESSO MINEIRO DE MEDICINA DE EMERGÊNCIA',
                        style:
                            TextStyle(color: Color(Configuracao.primayColor)),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Color(Configuracao.primayColor),
              ),
              Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.calendarCheck,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Programação',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgramacaoScreen(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.users,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Palestrantes',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PalestranteScreen(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.medal,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Olimpíadas',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OlimpiadasModalidadesScreen(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.checkSquare,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Casos Clínicos',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CasoClinicoScreen(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.info,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Sobre o Evento',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SobreScreen(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.facebook,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Facebook',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _abrirLinkFacebook();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.instagram,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Instagram',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _abrirLinkInstagram();
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Color(Configuracao.primayColor),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Color(Configuracao.primayColor),
                    ),
                    title: Text(
                      'Sair',
                      style: TextStyle(
                          fontSize: 18, color: Color(Configuracao.primayColor)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _deslogar();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
