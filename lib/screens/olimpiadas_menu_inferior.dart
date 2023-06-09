import 'package:app_abramede_mg/models/config_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'olimpiadas_avaliadores.dart';
import 'olimpiadas_competidores.dart';
import 'olimpiadas_modalidades.dart';

class OlimpiadasMenuInferior extends StatefulWidget {
  final int idMenuSelecionado;

  OlimpiadasMenuInferior(this.idMenuSelecionado);

  @override
  State<OlimpiadasMenuInferior> createState() =>
      _OlimpiadasMenuInferiorState(idMenuSelecionado);
}

class _OlimpiadasMenuInferiorState extends State<OlimpiadasMenuInferior> {
  final int idMenuSelecionado;

  _OlimpiadasMenuInferiorState(this.idMenuSelecionado);

  Future<void> _onItemTapped(int index) async {
    if (this.idMenuSelecionado != index) {
      if (index == Configuracao.menuOlimpiadasTorcedores) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OlimpiadasModalidadesScreen(),
            ));
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var cpf = prefs.getString(Configuracao.spCpf);

        if (index == Configuracao.menuOlimpiadasCompetidores && cpf == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LoginScreen(OlimpiadasCompetidoresScreen()),
              ));
        } else if (index == Configuracao.menuOlimpiadasCompetidores &&
            cpf != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OlimpiadasCompetidoresScreen(),
              ));
        } else if (index == Configuracao.menuOlimpiadasAvaliadores &&
            cpf == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LoginScreen(OlimpiadasAvaliadoresScreen()),
              ));
        } else if (index == Configuracao.menuOlimpiadasAvaliadores &&
            cpf != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OlimpiadasAvaliadoresScreen(),
              ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.flag),
          label: 'Torcedores',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.running),
          label: 'Competidores',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.tasks),
          label: 'Avaliadores',
        ),
      ],
      currentIndex: idMenuSelecionado,
      selectedItemColor: Color(Configuracao.primayColor),
      onTap: _onItemTapped,
    );
  }
}
