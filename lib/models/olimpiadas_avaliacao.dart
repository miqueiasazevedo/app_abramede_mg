class OlimpiadasAvaliacao {
  late String id;
  late String nomePesquisaInstantanea;
  late String nomeModalidade;
  late String nomeEquipe;

  OlimpiadasAvaliacao(this.id, this.nomePesquisaInstantanea, this.nomeEquipe);

  OlimpiadasAvaliacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomePesquisaInstantanea = json['nome_pesquisa_instantanea'];
    nomeModalidade = json['nome_modalidade'];
    nomeEquipe = json['nome_equipe'];
  }
}
