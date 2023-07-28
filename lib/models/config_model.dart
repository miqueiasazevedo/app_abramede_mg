class Configuracao {
  // static final String urlRaiz = "http://192.168.100.10:8000/web/";
  static final String url_raiz = "https://cursos.abramedemg.org.br/";
  static final String urlWebservice = url_raiz + "sgc/ws";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = new Map<String, String>();
    headers["Contend-type"] = "application/json";
    headers["Accept"] = "application/json";

    return headers;
  }

  static final int primayColor = 0xff1B3570;
  static final double toolbarHeight = 80;
  static final int menuOlimpiadasTorcedores = 0;
  static final int menuOlimpiadasCompetidores = 1;
  static final int menuOlimpiadasAvaliadores = 2;
  static final String spCpf = "cpf";
  static final String spNome = "nome";
  static final String spEhAlunoDaOlimpiada = "ehAlunoDaOlimpiada";
  static final String spEhDaComissaoAvaliadoraDaOlimpiada =
      "ehDaComissaoAvaliadoraDaOlimpiada";
  static final String idMatriculaComissaoAvaliadora =
      "id_matricula_comissao_avaliadora";
}
