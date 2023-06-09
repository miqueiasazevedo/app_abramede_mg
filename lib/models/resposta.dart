import 'package:app_abramede_mg/models/alternativa.dart';
import 'package:app_abramede_mg/models/pergunta.dart';

class Resposta {
  String idCasoClinico;
  String idMatricula;
  Pergunta pergunta;
  List<Alternativa> listAlternativa;

  Resposta(this.idCasoClinico, this.idMatricula, this.pergunta,
      this.listAlternativa);
}
